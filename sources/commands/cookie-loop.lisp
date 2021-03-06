;;;; -*- mode:lisp; coding:utf-8 -*-


(defparameter *escape*    (code-char 27))
(defparameter *normal*    (format nil "~C[0m" *escape*))
(defparameter *clear*     (format nil "~Cc" *escape*))
(defparameter *colors*    (loop for i from 31 to 37 collect (format nil "~C[~Am" *escape* i)))
(defparameter *key*       (format nil "~C[30;46m" *escape*))
(defparameter *term*      (if (member (getenv "TERM") '("dumb" "emacs") :test (function string=))
                              'dumb
                              'ansi))

(defun one-of (seq) (elt seq (random (length seq))))

(defun clear ()
  (ecase *term*
    ((dumb) (format t "~%--------------------------------------------------~10%"))
    ((ansi) (format t "~A~A" *clear* (one-of *colors*))))
  (finish-output))

(defun go-on-p ()
  (format t "~{~A~%~ARET~A to continue; ~1@*~Aquit RET~A to quit. Next? ~}"
          (ecase *term*
            ((dumb) (list ""       "["   "]"))
            ((ansi) (list *normal* *key* *normal*))))
  (finish-output)
  (string= "" (string-trim #(#\space #\tab) (read-line))))

(defun main (arguments)
  (declare (ignore arguments))
  (loop
    :do (clear)
        (run-program "cookie")
    :while (go-on-p))
  ex-ok)

;;;; THE END ;;;;
