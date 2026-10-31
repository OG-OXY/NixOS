;; -*- lexical-binding: t; -*-
(defvar my-buffer-map (make-sparse-keymap) "Buffer management map.")

(define-key my-buffer-map (kbd "b") '(my/persp-switch-buffer   :which-key "Switch workspace buffer"))
(define-key my-buffer-map (kbd "B") '(my/consult-all-buffers   :which-key "Switch all buffers"))
(define-key my-buffer-map (kbd "k") '(my/kill-current-buffer   :which-key "Kill current buffer"))
(define-key my-buffer-map (kbd "K") '(my/kill-buffer-prompt    :which-key "Kill buffer..."))
(define-key my-buffer-map (kbd "Z") '(my/bury-buffer           :which-key "Bury buffer"))
(define-key my-buffer-map (kbd "i") '(my/ibuffer-dashboard     :which-key "Ibuffer dashboard"))

;; Mount it to your global leader
(when (boundp 'my-leader-map)
  (define-key my-leader-map (kbd "b") (cons "Buffers" my-buffer-map)))

(provide 'buffer-map)
