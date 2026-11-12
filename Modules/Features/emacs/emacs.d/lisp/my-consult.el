;;; emacs.d/lisp/my-consult.el -*- lexical-binding: t; -*-
(use-package consult
  :demand t
  :config
  (setq consult-line-numbers-widen t
        consult-async-min-input 2))

(provide 'my-consult)
