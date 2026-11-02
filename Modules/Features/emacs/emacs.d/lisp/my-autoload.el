;;; emacs.d/lisp/my-autoload.el -*- lexical-binding: t; -*-

(autoload 'my/persp-switch-buffer "my-buffer-load" "Switch workspace buffer" t)
(autoload 'my/consult-all-buffers "my-buffer-load" "Switch all buffers" t)
(autoload 'my/kill-current-buffer "my-buffer-load" "Kill current buffer" t)
(autoload 'my/kill-buffer-prompt "my-buffer-load" "Kill specific buffer" t)
(autoload 'my/bury-buffer "my-buffer-load" "Bury buffer" t)
(autoload 'my/ibuffer-dashboard "my-buffer-load" "Open ibuffer dashboard" t)
(autoload 'consult-buffer "consult" "Asynchronous buffer and recent file selector." t)

(provide 'my-autoload)
