;;; emacs.d/lisp/my-notes-load.el -*- lexical-binding: t; -*-
(defvar my-notes-map (make-sparse-keymap) "Notes management map.")
(defvar my-roam-map (make-sparse-keymap) "Org-roam map.")
(defvar my-roam-dailies-map (make-sparse-keymap) "Org-roam dailies map.")

(defun my/org-agenda ()
  "Open Org agenda (Doom's SPC n a)."
  (interactive)
  (require 'org-agenda)
  (org-agenda))

(defun my/org-capture ()
  "Open Org capture menu (Doom's SPC X / SPC n x)."
  (interactive)
  (require 'org-capture)
  (org-capture))

(defun my/find-file-in-notes ()
  "Find a file in your org-directory (Doom's SPC n f)."
  (interactive)
  (require 'org)
  (let ((default-directory org-directory))
    (call-interactively #'find-file)))

(defun my/browse-notes ()
  "Open Dired in your org-directory (Doom's SPC n d)."
  (interactive)
  (require 'org)
  (dired org-directory))

(defun my/search-notes ()
  "Ripgrep search across all notes using Consult (Doom's SPC n s)."
  (interactive)
  (require 'org)
  (require 'consult)
  (consult-ripgrep org-directory))

;; --- Org-roam Commands (SPC n r ...) ---

(defun my/roam-node-find ()
  "Find or create an Org-roam node (Doom's SPC n r f)."
  (interactive)
  (require 'org-roam)
  (org-roam-node-find))

(defun my/roam-node-insert ()
  "Insert a link to an Org-roam node (Doom's SPC n r i)."
  (interactive)
  (require 'org-roam)
  (org-roam-node-insert))

(defun my/roam-capture ()
  "Capture directly into an Org-roam node (Doom's SPC n r c)."
  (interactive)
  (require 'org-roam)
  (org-roam-capture))

(defun my/roam-buffer-toggle ()
  "Toggle the Org-roam backlinks sidebar (Doom's SPC n r r)."
  (interactive)
  (require 'org-roam)
  (org-roam-buffer-toggle))

(defun my/roam-dailies-today ()
  "Open today's daily scratch/journal note (Doom's SPC n r d t)."
  (interactive)
  (require 'org-roam)
  (org-roam-dailies-goto-today))

(defun my/roam-dailies-capture-today ()
  "Capture a quick brain-dump into today's daily note (Doom's SPC n r d n)."
  (interactive)
  (require 'org-roam)
  (org-roam-dailies-capture-today))

(defun my/roam-dailies-date ()
  "Jump to a specific date's daily note (Doom's SPC n r d d)."
  (interactive)
  (require 'org-roam)
  (org-roam-dailies-goto-date))

;; Notes menu (SPC n ...)
(define-key my-notes-map (kbd "a") #'my/org-agenda)
(define-key my-notes-map (kbd "d") #'my/browse-notes)
(define-key my-notes-map (kbd "f") #'my/find-file-in-notes)
(define-key my-notes-map (kbd "r") (cons "roam" my-roam-map))
(define-key my-notes-map (kbd "s") #'my/search-notes)
(define-key my-notes-map (kbd "x") #'my/org-capture)

;; Roam submenu (SPC n r ...)
(define-key my-roam-map (kbd "c") #'my/roam-capture)
(define-key my-roam-map (kbd "d") (cons "dailies" my-roam-dailies-map))
(define-key my-roam-map (kbd "f") #'my/roam-node-find)
(define-key my-roam-map (kbd "i") #'my/roam-node-insert)
(define-key my-roam-map (kbd "r") #'my/roam-buffer-toggle)

;; Dailies submenu (SPC n r d ...)
(define-key my-roam-dailies-map (kbd "d") #'my/roam-dailies-date)
(define-key my-roam-dailies-map (kbd "n") #'my/roam-dailies-capture-today)
(define-key my-roam-dailies-map (kbd "t") #'my/roam-dailies-today)

;; Mount to global leader
(when (boundp 'my-leader-map)
  (define-key my-leader-map (kbd "n") (cons "Notes" my-notes-map))
  (define-key my-leader-map (kbd "X") #'my/org-capture))

(provide 'my-notes-map)
