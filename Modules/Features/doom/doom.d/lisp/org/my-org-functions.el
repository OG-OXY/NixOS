;;; lisp/org/org-functions.el --- Functions For Org Mode -*- lexical-binding: t; -*-
;;; Commentary:
;; Functions For Org Mode

;; Convert Markdown To Org by Region or Buffer.
;;;###autoload
(defun +my/org-convert-region-md-to-org (beg end)
  "Convert Markdown in region BEG..END to Org format using pandoc."
  (interactive "r")
  (unless (use-region-p)
    (user-error "Select a region first"))
  (unless (executable-find "pandoc")
    (user-error "Executable 'pandoc' not found in PATH"))
  (shell-command-on-region
   beg end
   "pandoc -f gfm -t org --wrap=none"
   t t))

;; Saved window layout before jumping full-screen into a capture buffer.
(defvar +my/org-return-window-config nil
  "Saved window configuration before opening a full-screen Org capture buffer.")

;; Save current buffer, update Org-roam DB if available, and restore layout.
;;;###autoload
(defun +my/org-capture-finish-and-return ()
  "Save the current Org buffer, sync Org-roam DB, and restore previous windows."
  (interactive)
  (save-buffer)
  (when (and (fboundp 'org-roam-db-update-file)
             (buffer-file-name))
    (org-roam-db-update-file))
  (when (window-configuration-p +my/org-return-window-config)
    (set-window-configuration +my/org-return-window-config)
    (setq +my/org-return-window-config nil)))

;; Org-Journal Entry Capture Template Function.
;;;###autoload
(defun +my/org-journal-open-fullscreen ()
  "Open today's `org-journal' entry full-screen with a timestamped title."
  (interactive)
  (require 'org-journal)
  (setq +my/org-return-window-config (current-window-configuration))
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

;; Org-Roam Daily Journal Entry Function (matching journal headings + tags).
;;;###autoload
(defun +my/org-roam-daily-open-fullscreen ()
  "Open today's `org-roam' daily note full-screen with headings and tags."
  (interactive)
  (require 'org-roam)
  (setq +my/org-return-window-config (current-window-configuration))
  (let* ((daily-dir (expand-file-name org-roam-dailies-directory org-roam-directory))
         (filename (expand-file-name (format-time-string "%Y-%m-%d.org") daily-dir))
         (day-heading (format-time-string "* %A, %d %B %Y"))
         (title (read-string "Entry Title: "))
         (tags-raw (read-string "Tags (space-separated, optional): "))
         (tags-list (split-string (string-trim tags-raw) "[ \t,:]+" t))
         (tags-suffix (if tags-list
                          (format " :%s:" (string-join tags-list ":"))
                        ""))
         (time-str (format-time-string "%H:%M"))
         (sub-heading (if (string-empty-p (string-trim title))
                          (format "\n** %s%s\n" time-str tags-suffix)
                        (format "\n** %s %s%s\n" time-str (string-trim title) tags-suffix)))
         (buf (find-file-noselect filename)))
    (make-directory daily-dir t)
    (with-current-buffer buf
      (setq buffer-read-only nil)
      (when (= (buffer-size) 0)
        (insert (format ":PROPERTIES:\n:ID:       %s\n:END:\n#+title: %s\n\n%s\n"
                        (org-id-new)
                        (format-time-string "%Y-%m-%d")
                        day-heading)))
      (goto-char (point-max))
      (unless (bolp)
        (insert "\n"))
      (insert sub-heading)
      (goto-char (point-max)))
    (switch-to-buffer buf)
    (delete-other-windows)
    (goto-char (point-max))))

;; Org-Roam New Node Function (opens full-screen immediately after title/tags).
;;;###autoload
(defun +my/org-roam-new-node-open-fullscreen ()
  "Prompt for title and filetags, create a new `org-roam' node, and open full-screen."
  (interactive)
  (require 'org-roam)
  (setq +my/org-return-window-config (current-window-configuration))
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
    (switch-to-buffer buf)
    (delete-other-windows)
    (goto-char (point-max))))

;; Org-Lint Flymake Backend Function and Args.
(after! (org flymake)
  (defun my/org-flymake-backend (report-fn &rest _args)
    "Run `org-lint' in org-mode and report diagnostics to Flymake via REPORT-FN."
    (when (derived-mode-p 'org-mode)
      (let* ((issues (org-lint))
             (diagnostics
              (cl-loop
               for item in issues
               for loc = (car item)
               for msg = (cadr item)
               for pos = (if (markerp loc)
                             (marker-position loc)
                           (point-min))
               for clamped-pos = (min (max pos (point-min)) (point-max))
               for end-pos = (min (1+ clamped-pos) (point-max))
               collect (flymake-make-diagnostic
                        (current-buffer)
                        clamped-pos
                        end-pos
                        :warning
                        (format "%s" msg)))))
        (funcall report-fn diagnostics))))

  (defun my/setup-org-flymake ()
    "Enable the custom `org-lint' Flymake backend in Org buffers."
    (add-hook 'flymake-diagnostic-functions #'my/org-flymake-backend nil t)
    (flymake-mode 1))
  (add-hook 'org-mode-hook #'my/setup-org-flymake))

(provide 'my-org-functions)
