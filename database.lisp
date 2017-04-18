(defun hash () ((lambda () (progn
                        (let ((storage))
                          (list (cons :init (lambda () (setf storage (make-hash-table))))
                                (cons :set (lambda (k v) (setf (gethash k storage) v)))
                                (cons :get (lambda (k) (gethash k storage)))))))))
