;; -*- lexical-binding: t; -*-
(require 'consult)
(require 'perspective)

(persp-mode 1)

(defun my/persp-switch-buffer ()
  "Switch buffers strictly inside active workspace."
  (interactive)
  (persp-switch-to-buffer))

(defun my/consult-all-buffers ()
  "Switch across ALL buffers system-wide."
  (interactive)
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

(provide 'buffer-load)

;; Autoload stubs so Emacs knows these functions exist before loading the file
;; (Point the filename string to whatever you name this file, e.g., "buffer-load")
(autoload 'my/persp-switch-buffer "buffer-load" "Switch workspace buffer" t)
(autoload 'my/consult-all-buffers "buffer-load" "Switch all buffers" t)
(autoload 'my/kill-current-buffer "buffer-load" "Kill current buffer" t)
(autoload 'my/kill-buffer-prompt "buffer-load" "Kill specific buffer" t)
(autoload 'my/bury-buffer "buffer-load" "Bury buffer" t)
(autoload 'my/ibuffer-dashboard "buffer-load" "Open ibuffer dashboard" t)
