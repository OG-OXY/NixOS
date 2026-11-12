;;; emacs.d/init.el -*- lexical-binding: t; -*-
;; --- 1. Package & Environment Setup ---
(setenv "PATH" (concat (getenv "PATH") ":/run/current-system/sw:/run/current-system/sw/bin:/run/current-system/sw/sbin:/run/current-system/sw/lib:/run/current-system/sw/share:/run/current-system/sw/etc:~/.nix-profile/bin"))
(setq exec-path (append exec-path '("/run/current-system/sw/bin" "~/.nix-profile/bin")))
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(when (boundp 'native-comp-eln-load-path)
  (startup-redirect-eln-cache
   (expand-file-name "emacs/eln-cache/" (or (getenv "XDG_CACHE_HOME") "~/.cache"))))

(require 'no-littering)
(setq no-littering-etc-directory
      (expand-file-name "emacs/etc/" (or (getenv "XDG_STATE_HOME") "~/.local/state")))
(setq no-littering-var-directory
      (expand-file-name "emacs/var/" (or (getenv "XDG_CACHE_HOME") "~/.cache")))

;; 3. Move custom.el, backups, and auto-saves into those directories too
(setq custom-file (no-littering-expand-etc-file-name "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))
(no-littering-theme-backups)

(setq use-package-always-ensure nil)
(setq package-enable-at-startup nil)

(require 'use-package)
(require 'my-which-key)
(require 'my-autoload)
(require 'my-persp)
(require 'my-consult)
(require 'my-buffer-map)
(require 'my-buffer-load)

;; Basic UI cleanup & startup tweaks
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)
(recentf-mode 1)
(run-at-time nil (* 2 60) 'recentf-save-list)

;; Load Theme & Modeline
(load-theme 'doom-one t)
(doom-modeline-mode 1)

;; --- 1. Icon Dependency ---
(use-package nerd-icons
  :demand t)

;; --- 2. Clean Vanilla Dashboard Setup ---
(use-package dashboard
  :demand t
  :after nerd-icons
  :custom
  (dashboard-icon-type 'nerd-icons)
  (dashboard-display-icons-p t)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-set-navigator-icons t)
  (dashboard-banner-logo-title "E M A C S")
  ; (dashboard-startup-banner 3)
  (dashboard-startup-banner
   (expand-file-name "banners/bcc.txt" user-emacs-directory))
  (dashboard-page-separator "\n\n")
  (dashboard-center-content t)         ;; Centers the layout nicely
  (dashboard-items '((recents   . 5)
                     (bookmarks . 5)
                     (projects  . 5)
                     (agenda    . 5)))
  (dashboard-show-shortcuts t)
  (dashboard-startupify-list '(dashboard-insert-banner
                               dashboard-insert-banner-title
                               dashboard-insert-newline
                               dashboard-insert-navigator
                               dashboard-insert-newline
                               dashboard-insert-items
                               dashboard-insert-newline
                               dashboard-insert-init-info
                               dashboard-insert-footer))
  :config
  (dashboard-setup-startup-hook))

(setq inhibit-startup-screen t)

(if (daemonp)
    (add-hook 'server-after-make-frame-hook
              (lambda ()
                (when (string= (buffer-name) "*scratch*")
                  (dashboard-open))))
  (setq initial-buffer-choice #'dashboard-open))

;; Helix-Mode
(use-package helix
  :demand t
  :hook ((helix-normal-mode . (lambda () (setq display-line-numbers 'relative)))
         (helix-normal-mode . (lambda () (setq cursor-type 'box)))
         (helix-insert-mode . (lambda () (setq cursor-type 'bar)))
         (helix-insert-mode . (lambda () (setq display-line-numbers t))))
  :config
  (helix-mode))
  
(use-package projectile
  :demand t
  :config
  (setq projectile-known-projects-file "~/.local/state/emacs/projectile-bookmarks.eld"
        projectile-cache-file "~/.local/state/emacs/projectile.cache"))
; 
;; --- 2. Completion (Vertico / Corfu / Orderless) ---
(use-package vertico
  :demand t
  :init (vertico-mode 1))

(use-package marginalia
  :demand t
  :init (marginalia-mode 1))

; (use-package consult
;   :bind (("C-s" . consult-line)
;          ("C-x b" . consult-buffer)))

(use-package orderless
  :demand t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package corfu
  :demand t
  :init
  (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-quit-no-match t))

(use-package org
  :demand t
  :config
  (setq org-directory "~/Documents/EMACS/"
        org-agenda-files (list org-directory)
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-src-preserve-indentation t
        org-cycle-hide-drawer-startup t
        org-hide-leading-stars t
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-startup-indented t
        org-ellipsis " ▾"
        org-startup-with-inline-images t
        image-use-external-converter t
        image-converter 'chafa
        browse-url-browser-function 'browse-url-xdg-open
        org-link-frame-setup
        '((vm . vm-visit-folder)
          (vm-imap . vm-visit-imap-folder)
          (gnus . gnus)
          (file . find-file)
          (wl . wl-other-frame))))
 
(use-package org-superstar
  :demand t
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-headline-bullets-list '("◉" "○" "✸" "✿" "•"))
  (org-superstar-special-item-bullet-alist '((?- . "•") (?+ . "➤"))))

(use-package org-appear
  :demand t
  :hook (org-mode . org-appear-mode)
  :custom
  (setq org-appear-auto-emphasis t
        org-appear-autolinks t
        org-appear-autosubmarkers t))

(use-package org-roam
  :demand t
  :init
  (require 'sqlite3)
  (setq org-roam-v2-ack t
        org-roam-database-connector 'sqlite3)
  :custom
  (org-roam-directory (file-truename (expand-file-name "roam" org-directory)))
  ; (org-roam-db-location (expand-file-name "~/.local/share/org-roam/org-roam.db"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (unless (file-exists-p org-roam-directory)
    (make-directory org-roam-directory t))
  (unless (file-exists-p (file-name-directory org-roam-db-location))
    (make-directory (file-name-directory org-roam-db-location) t))
  ;; Start autosync
  (org-roam-setup)
  (org-roam-db-autosync-mode 1))  

;; --- 5. Pandoc & Markdown Integration ---
(use-package pandoc-mode
  :hook ((markdown-mode org-mode) . turn-on-pandoc))

;; --- 6. Additional Tools (Magit, Majutsu, Image-Roll) ---
(use-package magit
  :bind ("C-x g" . magit-status))

(use-package majutsu
  :after magit)

(use-package image-roll
  :hook (image-mode . image-roll-mode))

(use-package helpful
  :demand t
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key]      . helpful-key)
  ([remap describe-command]  . helpful-command)
  ([remap describe-symbol]   . helpful-symbol))

;; --- 7. GUI-Only Specific Configurations ---
(when (display-graphic-p)
  (custom-set-faces
   '(org-level-1 ((t (:inherit outline-1 :height 1.35 :weight bold))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.2 :weight bold))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.1 :weight bold))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.05 :weight bold))))))

;; Terminal echo area safeguard for tooltips
(unless (display-graphic-p)
  (setq tooltip-use-echo-area t))


  ; (setq org-roam-database-connector 'sqlite-builtin)
  ; (setq org-roam-db-location "~/Documents/EMACS/org-roam.db"
;; commented out
;; (use-package org-modern
;;   :demand t
;;   :hook (org-mode . org-modern-mode))
; (use-package emacsql-sqlite
  ; :demand t)
