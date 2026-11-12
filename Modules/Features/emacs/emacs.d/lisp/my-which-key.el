;;; emacs.d/lisp/my-which-key.el -*- lexical-binding: t; -*-
(defvar my-leader-map (make-sparse-keymap) "Main leader map.")

(defun my/which-key-custom-sort (a b)
  "Sort keys alphabetically by base letter, placing lowercase before uppercase."
  (let* ((key-a (car a))
         (key-b (car b))
         (base-a (downcase key-a))
         (base-b (downcase key-b)))
    (if (string= base-a base-b)
        ;; If base letters match, put lowercase before uppercase
        (string< key-b key-a)
      (string< base-a base-b))))

(use-package which-key
  :demand t
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.05
        which-key-popup-type 'side-window
        which-key-side-window-location 'bottom
        which-key-sort-order #'my/which-key-custom-sort))

;; Bind space inside helix normal mode to your leader map
(with-eval-after-load 'helix
  (helix-define-key 'normal (kbd "SPC") my-leader-map))

;; --- Centralized Full-Path Key-Based Replacements ---
(which-key-add-key-based-replacements
  "SPC"   "Leader"
  "SPC n" "Notes"
  "SPC X" "Org-Capture"
  "SPC b" "Buffers"
  "SPC f" "Files"

  ;; Buffer Menu ("SPC b")
  "SPC b b" "Switch workspace buffer"
  "SPC b B" "Switch all buffers"
  "SPC b k" "Kill current buffer"
  "SPC b K" "Kill all buffers"
  "SPC b Z" "Kill buried buffers"
  "SPC b i" "Ibuffer dashboard"

  ;; File Menu ("SPC f")
  "SPC f c" "Open project editorconfig"
  "SPC f C" "Copy this file"
  "SPC f d" "Find Directory"
  "SPC f D" "Delete this file"
  "SPC f e" "Find file in emacs.d"
  "SPC f E" "Browse emacs.d"
  "SPC f f" "Find file from here"
  "SPC f F" "Find file literally"
  "SPC f l" "Locate file"
  "SPC f p" "Find file in private config"
  "SPC f P" "Browse private config"
  "SPC f r" "Recent files"
  "SPC f R" "Rename/move file"
  "SPC f s" "Save file as..."
  "SPC f S" "Save all buffers"
  "SPC f u" "Sudo find file"
  "SPC f U" "Sudo this file"
  "SPC f y" "Yank file path"
  "SPC f Y" "Yank file path from project"

  ;; Notes Menu ("SPC n")
  "SPC n a" "Org agenda"
  "SPC n d" "Browse notes"
  "SPC n f" "Find file in notes"
  "SPC n r" "roam"
  "SPC n s" "Search notes"
  "SPC n x" "Org capture"

  ;; Org-Roam Submenu ("SPC n r")
  "SPC n r c" "Capture to node"
  "SPC n r d" "dailies"
  "SPC n r f" "Find node"
  "SPC n r i" "Insert node"
  "SPC n r r" "Toggle roam buffer"

  ;; Org-Roam Dailies Submenu ("SPC n r d")
  "SPC n r d d" "Goto date"
  "SPC n r d n" "Capture today"
  "SPC n r d t" "Goto today")

(provide 'my-which-key)
