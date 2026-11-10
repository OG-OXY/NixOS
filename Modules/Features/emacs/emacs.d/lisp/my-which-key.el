;;; emacs.d/lisp/my-which-key.el -*- lexical-binding: t; -*-
;; --- Global Leader Key Definition ---
(defvar my-leader-map (make-sparse-keymap) "Main leader map.")

;; --- Lazy Load Which-Key ---
(use-package which-key
  :demand t
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.05)
  (setq which-key-popup-type 'side-window)
  (setq which-key-side-window-location 'bottom))

;; Bind space inside helix normal mode to your leader map
(with-eval-after-load 'helix
  (helix-define-key 'normal (kbd "SPC") my-leader-map))

  ;; Register custom labels for the buffer leader keymap
  (which-key-add-key-based-replacements "SPC b"
    "b" "Switch workspace buffer"
    "B" "Switch all buffers"
    "k" "Kill current buffer"
    "K" "Kill buffer..."
    "Z" "Bury buffer"
    "i" "Ibuffer dashboard")

(provide 'my-which-key)
