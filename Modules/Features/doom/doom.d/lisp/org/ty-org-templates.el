;;; lisp/org/org-templates.el --- Org Capture Templates -*- lexical-binding: t; -*-
;;; Commentary:
;; Org Templates and Keybindings For Org Mode
(require 'ty-org-functions)

(after! org
  (map! :map org-mode-map
        "C-c M-p" #'+ty/org-convert-region-md-to-org
        "C-c q" #'+ty/org-capture-finish-and-return))

(after! org-roam
  (setq org-roam-node-display-template
      (concat "${doom-hierarchy:*} "
              (propertize "${doom-tags:24}" 'face 'org-tag)))
  (map! :leader
        :desc "Find node" "n r f" #'ty/org-roam-node-find
        :desc "Insert node" "n r i" #'ty/org-roam-node-insert))

(after! org-roam-dailies
  (map! :leader
        :desc "Find node daily" "n r d f" #'ty/org-roam-daily-find))
		
				
(after! org-capture
  (setq org-capture-templates
        `(("i" "Inbox" entry
           (file+headline ,(expand-file-name "inbox.org" org-directory) "Inbox")
           "* %?\n  %U"
           :prepend t
           :immediate-finish nil)
          ("t" "Tasks" entry
           (file+headline +org-capture-todo-file "Tasks")
           "* [ ] %?\n%i\n%a"
           :prepend t)
          ("n" "Note" plain
           (function +ty/org-roam-new-node-open-fullscreen)
           ""
           :jump-to-captured t
           :immediate-finish t)
          ("d" "Daily" plain
           (function +ty/org-roam-daily-open-fullscreen)
           ""
           :jump-to-captured t
           :immediate-finish t)
          ("j" "Journal" plain
           (function +ty/org-journal-open-fullscreen)
           ""
           :jump-to-captured t
           :immediate-finish t)
          ("p" "Templates for projects")
          ("pt" "Project-local tasks" entry
           (file+headline +org-capture-project-todo-file "Tasks")
           "* TODO %?\n%i\n%a"
           :prepend t)
          ("pn" "Project-local notes" entry
           (file+headline +org-capture-project-notes-file "Notes")
           "* %U %?\n%i\n%a"
           :prepend t)
          ("pc" "Project-local changelog" entry
           (file+headline +org-capture-project-changelog-file "Unreleased")
           "* %U %?\n%i\n%a"
           :prepend t)
          ("o" "Centralized templates for projects")
          ("ot" "Project tasks" entry
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

(provide 'ty-org-templates)
