;;; emacs.d/lisp/my-consult.el -*- lexical-binding: t; -*-
(use-package consult
  :demand t
  :config
  (setq consult-line-numbers-widen t
        consult-async-min-input 2)

  ;; Exclude hidden space-prefixed buffers and internal asterisk buffers (*scratch*, *Messages*, etc.)
  (setq consult-buffer-filter
        '("\\` "
          "\\`\\*Completions\\*"
          "\\`\\*Compile-Log\\*"
          "\\`\\*Messages\\*"
          "\\`\\*Help\\*"
          "\\`\\*scratch\\*")))

(provide 'my-consult)
