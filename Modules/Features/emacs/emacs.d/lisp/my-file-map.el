;;; emacs.d/lisp/my-file-map.el -*- lexical-binding: t; -*-
(defvar my-file-map (make-sparse-keymap) "File management map.")

;; Helper commands for file operations
(defun my/find-file-in-project ()
  "Find file in project (Doom's SPC f f)."
  (interactive)
  (if (fboundp 'projectile-find-file)
      (projectile-find-file)
    (call-interactively #'find-file)))

(defun my/recent-files ()
  "Find recent files using Consult (Doom's SPC f r)."
  (interactive)
  (consult-recent-file))

(defun my/locate-file ()
  "Locate a file on system (Doom's SPC f l)."
  (interactive)
  (call-interactively #'locate))

(defun my/find-file-in-emacs-d ()
  "Find file in user emacs directory (Doom's SPC f e)."
  (interactive)
  (let ((default-directory user-emacs-directory))
    (call-interactively #'find-file)))

(defun my/browse-emacs-d ()
  "Browse emacs directory (Doom's SPC f E)."
  (interactive)
  (dired user-emacs-directory))

(defun my/find-file-in-private-config ()
  "Find file in private config (Doom's SPC f p)."
  (interactive)
  (let ((default-directory (expand-file-name "lisp/" user-emacs-directory)))
    (call-interactively #'find-file)))

(defun my/browse-private-config ()
  "Browse private config directory (Doom's SPC f P)."
  (interactive)
  (dired (expand-file-name "lisp/" user-emacs-directory)))

(defun my/copy-current-file-path ()
  "Copy current file path to clipboard (Doom's SPC f y)."
  (interactive)
  (if-let ((filename (or buffer-file-name dired-directory)))
      (progn
        (kill-new filename)
        (message "Copied path: %s" filename))
    (message "Current buffer is not visiting a file.")))

(defun my/copy-current-file-path-relative ()
  "Copy relative project file path (Doom's SPC f Y)."
  (interactive)
  (if-let ((filename (buffer-file-name)))
      (let* ((proj (and (fboundp 'projectile-project-root) (projectile-project-root)))
             (rel (if proj (file-relative-name filename proj) filename)))
        (kill-new rel)
        (message "Copied relative path: %s" rel))
    (message "Current buffer is not visiting a file.")))

;; --- Keybindings matching Doom's SPC f menu ---
(define-key my-file-map (kbd "c") #'add-dir-local-variable) ; approximate for editorconfig
(define-key my-file-map (kbd "C") #'copy-file)
(define-key my-file-map (kbd "d") #'dired)
(define-key my-file-map (kbd "D") #'delete-file)
(define-key my-file-map (kbd "e") #'my/find-file-in-emacs-d)
(define-key my-file-map (kbd "E") #'my/browse-emacs-d)
(define-key my-file-map (kbd "f") #'my/find-file-in-project)
(define-key my-file-map (kbd "F") #'find-file-literally)
(define-key my-file-map (kbd "l") #'my/locate-file)
(define-key my-file-map (kbd "p") #'my/find-file-in-private-config)
(define-key my-file-map (kbd "P") #'my/browse-private-config)
(define-key my-file-map (kbd "r") #'my/recent-files)
(define-key my-file-map (kbd "R") #'rename-file)
(define-key my-file-map (kbd "s") #'save-buffer)
(define-key my-file-map (kbd "S") #'write-file)
(define-key my-file-map (kbd "u") #'sudo-edit)
(define-key my-file-map (kbd "U") #'sudo-edit-current-file)
(define-key my-file-map (kbd "y") #'my/copy-current-file-path)
(define-key my-file-map (kbd "Y") #'my/copy-current-file-path-relative)

;; Mount to global leader map
(when (boundp 'my-leader-map)
  (define-key my-leader-map (kbd "f") (cons "Files" my-file-map)))

(provide 'my-file-map)
