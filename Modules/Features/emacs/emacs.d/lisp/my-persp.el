;;; emacs.d/lisp/my-persp.el -*- lexical-binding: t; -*-
(use-package perspective
  :demand t
  :init
  (setq persp-suppress-no-prefix-key-warning t)
  (add-hook 'emacs-startup-hook #'persp-mode))

(provide 'my-persp)
