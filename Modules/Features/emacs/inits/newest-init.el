;;; emacs.d/init.el -*- lexical-binding: t; -*-
;; Set Emacs State Directories
(setq no-littering-etc-directory
      (expand-file-name "emacs/etc/" (or (getenv "XDG_STATE_HOME") "~/.local/state")))
(setq no-littering-var-directory
      (expand-file-name "emacs/var/" (or (getenv "XDG_CACHE_HOME") "~/.cache")))
(require 'no-littering)
(no-littering-theme-backups)

(setq custom-file (no-littering-expand-etc-file-name "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; --- 3. Package Manager & Modular Files (Exact Dependency Order) ---
(setq use-package-always-ensure nil)
(require 'use-package)
(require 'my-which-key)
(require 'my-autoload)
(require 'my-persp)
(require 'my-consult)
(require 'my-buffer-map)
(require 'my-buffer-load)

;; --- 4. Remaining UI & Mode Defaults ---
(global-display-line-numbers-mode 1)
(recentf-mode 1)

;; Save recentf every 5 minutes so daemon sessions keep history updated
(run-at-time nil (* 5 60) 'recentf-save-list)

(load-theme 'doom-one t)
(doom-modeline-mode 1)

;; --- 5. Icon & Dashboard Setup ---
(use-package nerd-icons
  :demand t)

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
  (dashboard-startup-banner
   (expand-file-name "banners/bcc.txt" user-emacs-directory))
  (dashboard-page-separator "\n\n")
  (dashboard-center-content t)
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

(if (daemonp)
    (add-hook 'server-after-make-frame-hook
              (lambda ()
                (when (string= (buffer-name) "*scratch*")
                  (dashboard-open))))
  (setq initial-buffer-choice #'dashboard-open))

;; --- 6. Editing & Navigation ---
(use-package helix
  :demand t
  :hook ((helix-normal-mode . (lambda () (setq display-line-numbers 'relative)))
         (helix-normal-mode . (lambda () (setq cursor-type 'box)))
         (helix-insert-mode . (lambda () (setq cursor-type 'bar)))
         (helix-insert-mode . (lambda () (setq display-line-numbers t))))
  :config
  (helix-mode))

(use-package projectile
  :demand t)

;; --- 7. Completion (Vertico / Corfu / Orderless) ---
(use-package vertico
  :demand t
  :init (vertico-mode 1))

(use-package marginalia
  :demand t
  :init (marginalia-mode 1))

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

;; --- 8. Org & Org-Roam ---
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
  (org-appear-auto-emphasis t)
  (org-appear-autolinks t)
  (org-appear-autosubmarkers t))

(use-package org-roam
  :demand t
  :init
  (require 'sqlite3)
  (setq org-roam-v2-ack t
        org-roam-database-connector 'sqlite3)
  :custom
  (org-roam-directory (file-truename (expand-file-name "roam" org-directory)))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (unless (file-exists-p org-roam-directory)
    (make-directory org-roam-directory t))
  (unless (file-exists-p (file-name-directory org-roam-db-location))
    (make-directory (file-name-directory org-roam-db-location) t))
  (org-roam-setup)
  (org-roam-db-autosync-mode 1))

;; --- 9. Pandoc & Additional Tools ---
(use-package pandoc-mode
  :hook ((markdown-mode org-mode) . turn-on-pandoc))

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

;; --- 10. GUI-Only Specific Configurations ---
(when (display-graphic-p)
  (custom-set-faces
   '(org-level-1 ((t (:inherit outline-1 :height 1.35 :weight bold))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.2 :weight bold))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.1 :weight bold))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.05 :weight bold))))))
