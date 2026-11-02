;;; emacs.d/lisp/my-buffer-map.el -*- lexical-binding: t; -*-
(defvar my-buffer-map (make-sparse-keymap) "Buffer management map.")

(define-key my-buffer-map (kbd "b") #'my/persp-switch-buffer)
(define-key my-buffer-map (kbd "B") #'my/consult-all-buffers)
(define-key my-buffer-map (kbd "k") #'my/kill-current-buffer)
(define-key my-buffer-map (kbd "K") #'my/kill-buffer-prompt)
(define-key my-buffer-map (kbd "Z") #'my/bury-buffer)
(define-key my-buffer-map (kbd "i") #'my/ibuffer-dashboard)

;; Mount it to your global leader
(when (boundp 'my-leader-map)
  (define-key my-leader-map (kbd "b") (cons "Buffers" my-buffer-map)))

(provide 'my-buffer-map)
