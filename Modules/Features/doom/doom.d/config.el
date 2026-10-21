;; doom.d/config.el -*- lexical-binding: t; -*-
(setq org-directory "~/Notes/Org")
(after! org
  (setq org-hide-emphasis-markers t       ; Hide *bold*, /italic/ markup
        org-pretty-entities t             ; Render symbols/greek letters nicely
        org-ellipsis " ▾"))               ; Clean folded heading indicator
(after! org-roam
  (setq org-roam-directory (expand-file-name "roam" org-directory)))
(after! org-appear
  (setq org-appear-auto-emphasis t
        org-appear-autolinks t
        org-appear-autosubmarkers t))
(add-hook! 'org-mode-hook #'org-appear-mode)
(add-hook! '(markdown-mode-hook org-mode-hook) #'pandoc-mode)
; (map! :leader
;       :prefix ("n p" . "pandoc convert")
;       :desc "Open Pandoc menu" "p" #'pandoc-main-menu
;       :desc "Convert/Export buffer" "e" #'pandoc-convert)
(require 'dired)
