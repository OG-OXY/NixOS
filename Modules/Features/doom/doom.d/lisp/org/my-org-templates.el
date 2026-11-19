;;; lisp/org/org-templates.el --- Org Capture Templates -*- lexical-binding: t; -*-
;;; Commentary:
;; Org Functions and Templates For the Org Mode
(require 'my-org-functions)

(defun +my/org-journal-capture-fullscreen ()
  "Open journal entry full-screen and target the live journal buffer."
  (+my/org-journal-open-fullscreen)
  (set-buffer (find-file-noselect (org-journal--get-entry-path))))

(after! org-capture
  (setq org-capture-templates
        `(("i" "Inbox" entry
           (file ,(expand-file-name "inbox.org" org-directory))
           "* %?\n  %U"
           :prepend t
		   :immediate-finish nil)
          ("t" "Personal todo" entry
           (file+headline +org-capture-todo-file "Inbox")
           "* [ ] %?\n%i\n%a"
           :prepend t)
		  ("n" "New Roam Node" plain
           (function +my/org-roam-new-node-target)
           "%i%?"
           :jump-to-captured t
           :immediate-finish nil)
          ("j" "Journal" plain
           (function +my/org-journal-open-fullscreen)
           ""
           :jump-to-captured t
           :immediate-finish t)
          ("p" "Templates for projects")
          ("pt" "Project-local todo" entry
           (file+headline +org-capture-project-todo-file "Inbox")
           "* TODO %?\n%i\n%a"
           :prepend t)
          ("pn" "Project-local notes" entry
           (file+headline +org-capture-project-notes-file "Inbox")
           "* %U %?\n%i\n%a"
           :prepend t)
          ("pc" "Project-local changelog" entry
           (file+headline +org-capture-project-changelog-file "Unreleased")
           "* %U %?\n%i\n%a"
           :prepend t)
          ("o" "Centralized templates for projects")
          ("ot" "Project todo" entry
           #'+org-capture-central-project-todo-file
           "* TODO %?\n %i\n %a"
           :heading "Tasks"
           :prepend t)
          ("on" "Project notes" entry
           #'+org-capture-central-project-notes-file
           "* %U %?\n %i\n %a"
           :heading "Notes"
           :prepend t)
          ("oc" "Project changelog" entry
           #'+org-capture-central-project-changelog-file
           "* %U %?\n %i\n %a"
           :heading "Changelog"
           :prepend t))))

		  ;; Original Journal Capture Entry Function (mini-buffers)
          ; ("j" "Journal" plain
          ;  (function +my/org-journal-find-location)
          ;  "** %(format-time-string org-journal-time-format)%^{Title}\n%i%?"
          ;  :jump-to-captured t
          ;  :immediate-finish nil)

          ;; Default Notes Capture Entry
          ; ("n" "Personal notes" entry
          ;  (file+headline +org-capture-notes-file "Inbox")
          ;  "* %u %?\n%i\n%a"
          ;  :prepend t)

(provide 'my-org-templates)
