(defun y (g)
  ((lambda (f) (funcall f f))
   (lambda (f) (funcall g (lambda (&rest x) (apply (funcall f f) x))))))


(defun gen-async ()
  (let ((list)
        (tasks)
        (singal))
    (progn
      (sb-thread:make-thread
       (y (lambda (fn)
            (lambda ()
              (progn
                (setf list (append list tasks))
                (setf tasks nil)
                (let ((task (car list)))
                  (progn (if (not (equal task nil))
                             (progn (setf list (cdr list))
                                    (print "go")
                                    ;;(print task)
                                    (funcall task)
                                    (sleep 0))
                             (progn (sleep 1)
                                    (print "no task")))
                         (cond ((equal singal :end) nil)
                               (t (funcall fn))))))))))
      (list (cons :add (lambda (task) (setf tasks (append tasks (list task)))))
            (cons :end (lambda () (setf singal :end)))))))
