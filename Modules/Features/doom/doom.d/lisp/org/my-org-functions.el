;;; lisp/org/org-functions.el -*- lexical-binding: t; -*-
;;; Commentary:
;; Functions For Org Mode 
 
(defvar +my/org-journal-return-window-config nil
  "Saved window configuration before jumping full-screen into `org-journal'.")

;;;###autoload
(defun +my/org-journal-open-fullscreen ()
  "Open today's `org-journal' entry full-screen with a timestamped title."
  (interactive)
  (require 'org-journal)
  (setq +my/org-journal-return-window-config (current-window-configuration))
  (org-journal-new-entry t)
  (delete-other-windows)
  (unless (eq org-journal-file-type 'daily)
    (org-narrow-to-subtree))
  (goto-char (point-max))
  (let* ((title (read-string "Entry Title: "))
         (time-str (format-time-string org-journal-time-format))
         (heading (if (string-empty-p (string-trim title))
                      (format "\n** %s\n" (string-trim time-str))
                    (format "\n** %s%s\n" time-str title))))
    (unless (bolp)
      (insert "\n"))
    (insert heading)
    (goto-char (point-max))))

;;;###autoload
(defun +my/org-journal-finish-and-return ()
  "Save the current journal buffer and restore the previous window layout."
  (interactive)
  (save-buffer)
  (when (window-configuration-p +my/org-journal-return-window-config)
    (set-window-configuration +my/org-journal-return-window-config)
    (setq +my/org-journal-return-window-config nil)))

;;;###autoload
(defun +my/org-roam-new-node-target ()
  "Create a new `org-roam' node file with title and filetags for capture."
  (require 'org-roam)
  (let* ((title (read-string "New Roam Node Title: "))
         (tags-raw (read-string "Filetags (space-separated, e.g. nix functions systemd user): "))
         (tags-list (split-string (string-trim tags-raw) "[ \t,:]+" t))
         (filetags-line (if tags-list
                            (format "#+filetags: :%s:\n" (string-join tags-list ":"))
                          ""))
         (slug (org-roam-node-slug (org-roam-node-create :title title)))
         (filename (expand-file-name
                    (format "%s-%s.org"
                            (format-time-string "%Y%m%d%H%M%S")
                            slug)
                    org-roam-directory))
         (id (org-id-new))
         (buf (find-file-noselect filename)))
    (make-directory (file-name-directory filename) t)
    (with-current-buffer buf
      (setq buffer-read-only nil)
      (when (= (buffer-size) 0)
        (insert (format ":PROPERTIES:\n:ID:       %s\n:END:\n#+title: %s\n%s\n"
                        id title filetags-line)))
      (goto-char (point-max)))
    (set-buffer buf)
    (goto-char (point-max))))

(provide 'my-org-functions)
