;;;  doom.d/config.el -*- lexical-binding: t; -*-
;; Append System PATH
(setenv "PATH" (concat (getenv "PATH") ":/run/current-system/sw/bin:/run/current-system/sw/sbin:/run/current-system/sw/lib:/run/current-system/sw/share:/run/current-system/sw/etc:"))
(setq exec-path (append exec-path '("/run/current-system/sw/bin"))) ;; Append System Exec PATH
;; Append "lisp" DIR to Load Path
(let ((default-directory (expand-file-name "lisp" doom-user-dir)))
   (when (file-directory-p default-directory)
     (add-to-list 'load-path default-directory)
     (normal-top-level-add-subdirs-to-load-path)))
(setq org-directory "~/Documents/ORG/") ;; Set Org DIR
;; Require Custom Lisp and Modularized el Files
(require 'my-org-templates) ;; Require Org-Templates and Org-Functions

;; Undo
(after! undo-fu-session
  (setq undo-fu-session-file-limit 1000
        undo-fu-session-compression 'zlib))

;; Corfu Completion
(after! corfu
  (setq corfu-auto t
        corfu-auto-prefix 2
        corfu-auto-delay 0.1))

;; Which-Key
(after! which-key
  (setq which-key-idle-delay 0.05
        which-key-popup-type 'side-window
        which-key-side-window-location 'bottom
        which-key-max-display-columns nil
        which-key-side-window-max-height 0.5))

;; Fix Doom's SPC f d (Invalid Function/Variable "dired-read-dir-and-switches")
(after! dired
  (require 'dired-aux))
(map! :leader
	  :prefix "f"
	  :desc "Find Directory" "d" #'dired)

;; Org
(after! org
  (setq org-agenda-files (list
        (expand-file-name "journal" org-directory)
        (expand-file-name "inbox.org" org-directory)
        (expand-file-name "todo.org" org-directory)
        (expand-file-name "daily" org-directory))
        +org-capture-journal-file
        (expand-file-name "journal/journal.org" org-directory)
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-src-preserve-indentation t
        org-cycle-hide-drawer-startup t
        org-hide-leading-stars t
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-startup-indented t
        org-startup-folded 'content
        org-element-use-cache t
        font-lock-maximum-decoration t
        org-ellipsis " ▾"
        org-return-follows-link t
        org-startup-with-inline-images t
        image-use-external-converter t
        image-converter 'chafa
        browse-url-browser-function 'browse-url-xdg-open
        org-tag-alist '(("nixos" . ?n)
                        ("fish" . ?s)
                        ("nushell" . ?u)
                        ("emacs" . ?e)
                        ("org" . ?o)
                        ("helix" . ?h)
                        ("functions" . ?f)
                        ("scripts" . ?b)
                        ("debug" . ?d))))

;; Org-Roam
(after! org-roam
  (setq org-roam-directory "~/Documents/ORG/"
        org-roam-dailies-directory "daily/"))

;; Org-Modern
(after! org-modern
  (setq org-modern-table t
        org-modern-block t
        org-modern-todo t
        org-modern-tag t
        org-modern-star 'fold
        org-modern-fold-stars '(("◉" . "○") ;;●○
                                ("◉" . "○") ;;◆◇
                                ("◉" . "○") ;;■□
                                ("◉" . "○") ;;▸▾
                                ("◉" . "○")
                                ("◉" . "○"))
        org-modern-list '((?- . "•") ;; 
                          (?+ . "➤")
                          (?* . "✸"))))

;; Org-Appear (reveals org syntax on cursor hover)
(after! org-appear
  (setq org-appear-auto-emphasis t
        org-appear-autolinks t
        org-appear-autosubmarkers t))

(after! org-journal
  (setq org-journal-dir (expand-file-name "journal" org-directory)
        org-journal-file-format "%Y-%m-%d.org"
        org-journal-date-format "%A, %m/%d/%Y"))

;; Majutsu (Magit for Jujutsu)
(use-package! majutsu
  :after magit
  :init
  ;; Remap Magit status to Majutsu status
  (map! :leader
		(:prefix ("g" . "jujutsu")
        :desc "Jujutsu status" "g" #'majutsu))
  :config
  (setq majutsu-display-functions '((status . switch-to-buffer))))

;; Spell Checking
(after! ispell
  (setq ispell-program-name "hunspell"
        ispell-dictionary "en_US"
        text-mode-ispell-word-completion nil))

;; Format +onsave
(after! apheleia
  (add-to-list 'apheleia-inhibit-functions
               (lambda () (derived-mode-p 'nix-mode))))

;; RSS Feed
(after! elfeed
  (setq rmh-elfeed-org-files (list
        (expand-file-name "elfeed/elfeed.org" org-directory))))

;; GUI + TUI Settings
(when (display-graphic-p)
  (custom-set-faces!
    '(org-level-1 :weight bold :height 1.5)
    '(org-level-2 :weight bold :height 1.35)
    '(org-level-3 :weight bold :height 1.2)
    '(org-level-4 :weight bold :height 1.05)))

(after! image-roll
  (when (display-graphic-p)
    (global-image-roll-mode 1)))
    
(unless (display-graphic-p)
  (setq tooltip-use-echo-area t))
