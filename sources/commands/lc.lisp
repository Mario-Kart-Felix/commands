;;;; -*- mode:lisp; coding:utf-8 -*-

(defun copy-stream (from to)
  "Copy into TO from FROM until end of the input file.  Do not
translate or otherwise maul anything.
AUTHORS: Daniel Barlow, Xarch"
  (let ((buf (make-array 4096 :element-type (stream-element-type from))))
    (do ((pos (read-sequence buf from) (read-sequence buf from)))
        ((= 0 pos) nil)
      (write-sequence buf to :end pos))))

#-(and) (defun copy-file (src dst &key (if-exists :error) (external-format :default)
                                    (element-type 'character))
          "
DO:     Copy the contents of the file at path SRC to the file at path DST.
"
          (with-open-file (inp src
                               :direction :input
                               :if-does-not-exist :error
                               :external-format external-format
                               :element-type element-type)
            (with-open-file (out dst
                                 :direction :output
                                 :if-does-not-exist :create
                                 :if-exists if-exists
                                 :external-format external-format
                                 :element-type element-type)
              (copy-stream inp out))))

(defun process-file (encoding file)
  (let* ((file (truename file))
         (file.bak (merge-pathnames (make-pathname :type "BAK" :case :common) file)))
    (ignore-errors (delete-file file.bak))
    (handler-case (rename-file file file.bak)
      (error (err)
        (format *error-output* "Cannot rename the file ~A to a backup file ~A~%~A"
                file file.bak err)
        (return-from process-file ex-oserr)))
    (handler-case (copy-file file.bak file :external-format encoding)
      (error (err)
        (format *error-output* "Error while copying the file ~A to ~A~%~A~%"
                file.bak file err)
        (return-from process-file ex-oserr)))
    ex-ok))

(defun process-stream (encoding input output)
  (setf (stream-external-format output) encoding)
  (handler-case (copy-stream input output)
      (error (err)
        (format *error-output*
                "Error while copying the input stream to the output stream~%~A"
                err)
        (return-from process-stream 1)))
  ex-ok)

(defun main (&optional args)
  (labels ((ef (line-terminator)
             #-clisp (declare (ignore                  line-terminator))
             #+clisp (ext:make-encoding :charset charset:iso-8859-1
                                        :line-terminator line-terminator)
             #-clisp :iso-8859-1)

           (usage ()
             (format *standard-output*
                     "~A usage:~
                    ~
                    ~&    ~:*~A -u|-m|-p|-h  [file...] | < input > output~
                    ~&"
                     (if  *load-pathname*
                          (file-namestring *load-pathname*)
                          "lc")))
           (err (fctrl &rest args)
             (apply (function format) *error-output* fctrl args)
             (usage)
             (return-from main 1)))
    (loop
      :with got-file-p := nil
      :with status := 0
      :with ef := nil
      :for arg :in args
      :do (cond ((string= "-u" arg)         (setf ef (ef :unix)))
                ((string= "-m" arg)         (setf ef (ef :mac)))
                ((string= "-p" arg)         (setf ef (ef :dos)))
                ((string= "-h" arg)         (usage) (return-from main 0))
                ((string= "-"  arg :end2 1) (err "Unknown option: ~A" arg))
                (t (let ((new-status (process-file ef arg)))
                     (setf got-file-p t
                           status (if (zerop new-status) status new-status)))))
      :finally (cond
                 ((null ef)  (err "I need an option~%"))
                 (got-file-p (return-from main status))
                 (t          (return-from main (process-stream
                                                ef
                                                *standard-input*
                                                *standard-output*))))))
  ex-ok)

;;;; THE END ;;;;
