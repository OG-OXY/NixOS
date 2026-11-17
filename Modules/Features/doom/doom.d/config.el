;;;  doom.d/config.el -*- lexical-binding: t; -*-
(setenv "PATH" (concat (getenv "PATH") ":/run/current-system/sw/bin:~/.nix-profile/bin"))
(setq exec-path (append exec-path '("/run/current-system/sw/bin" "~/.nix-profile/bin")))
(setq org-directory "~/Documents/DOOM/")

(after! undo-fu-session
(setq undo-fu-session-file-limit 1000
      undo-fu-session-compression 'zlib))

(after! which-key
  (setq which-key-idle-delay 0.05
        which-key-popup-type 'side-window
        which-key-side-window-location 'bottom))

(after! dired
	(require 'dired-aux))
(map! :leader
	  :prefix "f"
	  :desc "Find Directory" "d" #'dired)

(after! org
  (setq org-agenda-files (list org-directory)
	    org-journal-dir (expand-file-name "journal" org-directory)
		org-roam-directory (expand-file-name "roam" org-directory)
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-src-preserve-indentation t
        org-cycle-hide-drawer-startup t
        org-hide-leading-stars t
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-startup-indented t
        org-ellipsis " ▾"
        org-return-follows-link t
        org-startup-with-inline-images t
        image-use-external-converter t
        image-converter 'chafa
        browse-url-browser-function 'browse-url-xdg-open))

;; --- Unified Org Typography & Bullet Mix ---
(use-package! org-superstar
  :after org
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-prettify-item-bullets t
		org-superstar-headline-bullets-list '("" "" "" "" "󰫢") ;; Extra symbols ("◉" "○" <-- original header 1 and 2)
		org-superstar-special-item-bullet-alist '((?- . "✸") (?+ . "➤"))))

(use-package! org-modern
  :after org
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star nil))

;; Org-Appear (reveals syntax markers dynamically on cursor approach)
(after! org-appear
  (setq org-appear-auto-emphasis t
        org-appear-autolinks t
        org-appear-autosubmarkers t))
(add-hook! 'org-mode-hook #'org-appear-mode)

(use-package! org-fancy-priorities
  :demand t
  :after org)

;; --- Pandoc Integration ---
(add-hook! '(markdown-mode-hook org-mode-hook) #'pandoc-mode)

;; --- Terminal vs. GUI Conditional Environment Toggles ---
(if (display-graphic-p)
    (custom-set-faces
     '(org-level-1 ((t (:inherit outline-1 :height 1.50 :weight bold))))
     '(org-level-2 ((t (:inherit outline-2 :height 1.35 :weight bold))))
     '(org-level-3 ((t (:inherit outline-3 :height 1.20 :weight bold))))
     '(org-level-4 ((t (:inherit outline-4 :height 1.05 :weight bold)))))
  (setq tooltip-use-echo-area t)
  (after! image-roll
    (global-image-roll-mode 1)))
