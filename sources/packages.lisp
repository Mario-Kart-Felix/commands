(defpackage "COM.INFORMATIMAGO.COMMAND.SCRIPT"
  (:nicknames "SCRIPT")
  (:use "COMMON-LISP"
        "COM.INFORMATIMAGO.COMMON-LISP.CESARUM.VERSION")
  (:export  "CLEAN-PACKAGE/COMMON-LISP-USER")
  (:export "*VERBOSE*" "*DEBUG*"
           "*DEFAULT-PROGRAM-NAME*" "*PROGRAM-NAME*" "*PROGRAM-PATH*" "*ARGUMENTS*"

           "WITHOUT-OUTPUT" "WITH-PAGER"
           "REDIRECTING-STDOUT-TO-STDERR"
           "RELAUNCH-WITH-KFULL-LINKSET-IF-NEEDED"

           ;; I/O
           "PERROR" "PMESSAGE" "PQUERY"

           ;; Options
           "DEFINE-OPTION" "CALL-OPTION-FUNCTION"
           "PARSE-OPTIONS"
           "SET-DOCUMENTATION-TEXT"
           "*BASH-COMPLETION-HOOK*"

           ;; Utilities:
           "FIND-DIRECTORIES"
           "CONCAT" "MAPCONCAT"

           "GETPID" "SHELL-QUOTE-ARGUMENT" "SHELL" "EXECUTE" "RUN-PROGRAM"
           "UNAME" "COPY-FILE"  "MAKE-SYMBOLIC-LINK" "MAKE-DIRECTORY"

           ;; Exit codes:
           "EX--BASE" "EX--MAX" "EX-CANTCREAT" "EX-CONFIG"
           "EX-DATAERR" "EX-IOERR" "EX-NOHOST" "EX-NOINPUT"
           "EX-NOPERM" "EX-NOUSER" "EX-OK" "EX-OSERR" "EX-OSFILE"
           "EX-PROTOCOL" "EX-SOFTWARE" "EX-TEMPFAIL" "EX-UNAVAILABLE"
           "EX-USAGE"

           "EXIT"))

(defpackage "COM.INFORMATIMAGO.COMMAND.UTILITY"
  (:use "COMMON-LISP")
  (:export "COMMAND"
           "REGISTER-COMMAND" "COMMAND-NAMED"
           "COMMAND-NAME" "COMMAND-USE-SYSTEMS" "COMMAND-MAIN" "COMMAND-PACKAGE"
           "COMMAND-PATHNAME"
           "COMMAND-PACKAGE-NAME"
           "REGISTER-COMMAND-FILE"
           "DISPATCH-COMMAND"))

(defpackage "COM.INFORMATIMAGO.COMMAND.GENERATE"
  (:use "COMMON-LISP"
        "COM.INFORMATIMAGO.COMMAND.UTILITY"
        "COM.INFORMATIMAGO.COMMAND.SCRIPT"))
