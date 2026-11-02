;;; emacs.d/lisp/my-buffer-load.el -*- lexical-binding: t; -*-
(defun my/persp-switch-buffer ()
  "Switch buffers strictly inside active workspace."
  (interactive)
  (require 'perspective)
  ; (persp-switch-to-buffer)
  (call-interactively #'persp-switch-to-buffer))

(defun my/consult-all-buffers ()
  "Switch across ALL buffers system-wide."
  (interactive)
  (require 'consult)
  (consult-buffer))

(defun my/kill-current-buffer ()
  "Kill current active buffer."
  (interactive)
  (kill-current-buffer))

(defun my/kill-buffer-prompt ()
  "Prompt to kill a specific buffer."
  (interactive)
  (call-interactively #'kill-buffer))

(defun my/bury-buffer ()
  "Bury current buffer."
  (interactive)
  (bury-buffer))

(defun my/ibuffer-dashboard ()
  "Open ibuffer dashboard."
  (interactive)
  (ibuffer))

(provide 'my-buffer-load)
