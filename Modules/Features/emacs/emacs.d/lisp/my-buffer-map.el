;;; emacs.d/lisp/my-buffer-map.el -*- lexical-binding: t; -*-
(defvar my-buffer-map (make-sparse-keymap) "Buffer management map.")

(defun my/persp-switch-buffer ()
  "Switch to a buffer in the current workspace (Doom's SPC b b)."
  (interactive)
  (require 'perspective)
  (let ((consult-buffer-sources
         (if (boundp 'persp-consult-source)
             '(persp-consult-source)
           '(consult--source-buffer)))
        (consult-buffer-filter
         '("\\` "
           "\\`\\*Completions\\*"
           "\\`\\*Compile-Log\\*"
           "\\`\\*Messages\\*"
           "\\`\\*Help\\*"
           "\\`\\*scratch\\*"
           "\\`\\*Warnings\\*"
           "\\`\\*Async-native-compile-log\\*")))
    (consult-buffer)))

(defun my/consult-all-buffers ()
  "Switch across ALL buffers system-wide (Doom's SPC b B)."
  (interactive)
  (require 'consult)
  (consult-buffer))

(defun my/kill-current-buffer ()
  "Kill current active buffer (Doom's SPC b k)."
  (interactive)
  (kill-current-buffer))

(defun my/kill-all-buffers ()
  "Kill all buffers (Doom's SPC b K)."
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(defun my/kill-buried-buffers ()
  "Kill all buried (non-visible) buffers (Doom's SPC b Z)."
  (interactive)
  (let ((visible-buffers (mapcar #'window-buffer (window-list))))
    (dolist (buf (buffer-list))
      (unless (or (memq buf visible-buffers)
                  (string-prefix-p " " (buffer-name buf)))
        (kill-buffer buf))))
  (message "Killed all buried buffers"))

(defun my/ibuffer-dashboard ()
  "Open ibuffer dashboard (Doom's SPC b i)."
  (interactive)
  (ibuffer))

;; Map each custom function/variable to a key
(define-key my-buffer-map (kbd "b") #'my/persp-switch-buffer)
(define-key my-buffer-map (kbd "B") #'my/consult-all-buffers)
(define-key my-buffer-map (kbd "k") #'my/kill-current-buffer)
(define-key my-buffer-map (kbd "K") #'my/kill-all-buffers)
(define-key my-buffer-map (kbd "Z") #'my/kill-buried-buffers)
(define-key my-buffer-map (kbd "i") #'my/ibuffer-dashboard)

;; Mount it to your global leader
(when (boundp 'my-leader-map)
  (define-key my-leader-map (kbd "b") (cons "Buffers" my-buffer-map)))

(provide 'my-buffer-map)
