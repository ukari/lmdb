(defun y (g)
  ((lambda (f) (funcall f f))
   (lambda (f) (funcall g (lambda (&rest x) (apply (funcall f f) x))))))


(defun gen-async ()
  (let ((list)
        (tasks)
        (singal))
    (progn
      (sb-thread:make-thread
       (y (lambda (fn) (lambda () (progn
                          (setf list (nconc list tasks))
                          (setf tasks nil)
                          (let ((task (car list)))
                            (progn (if (not (eq task nil))
                                       (progn (setf list (cdr list))
                                              (print "go")
                                              ;;(print task)
                                              (funcall task)
                                              (sleep 0))
                                       (progn (sleep 1)
                                              (print "sil")))
                                   (cond ((equal singal :end) nil)
                                         (t (funcall fn))))))))))
      (list (cons :add (lambda (task)
                         (progn
                           (sleep 0)
                           (setf tasks (append tasks (list task))))))
            (cons :end (lambda () (setf singal :end)))))))


;; (defparameter async (gen-async))
(defun times (max f)
  (do ((i 0 (+ i 1)))
      ((> i max) 'done)
    (funcall f i)))
;;(times 6 (funcall (cdr (assoc :add async)) (lambda () (format t "~%~A~%" i))))
