;;; emacs.d/init.el -*- lexical-binding: t; -*-
 
;; --- 1. Package & Environment Setup ---
(require 'use-package)
(setq use-package-always-ensure nil)

;; Basic UI cleanup & startup tweaks
; (setq inhibit-startup-screen t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)

;; Load Theme & Modeline
(load-theme 'doom-one t)
(doom-modeline-mode 1)


;; --- Startup Splash Screen ---
(setq inhibit-startup-screen nil) ; Must be nil to show a dashboard!

(use-package dashboard
  :ensure nil
  :demand t
  :config
  (setq dashboard-display-icons-p t
        dashboard-icon-type 'nerd-icons
        ;; Optional: center it nicely like Doom
        dashboard-center-content t)
  
  ;; Load doom-dashboard extensions and map its custom widgets
  (require 'doom-dashboard)
  (setq dashboard-items '((projects . doom-dashboard-insert-project-shortmenu)
                          (agenda . doom-dashboard-insert-org-agenda-shortmenu)
                          (bookmarks . doom-dashboard-insert-bookmark-shortmenu)
                          (recents . doom-dashboard-insert-recents-shortmenu)))

  (dashboard-setup-startup-hook))

;; Helix-Mode
(use-package helix
  :demand t
  :hook ((helix-normal-mode . (lambda () (setq display-line-numbers 'relative)))
         (helix-normal-mode-hook (lambda () (setq cursor-type 'box)))
         (helix-insert-mode-hook (lambda () (setq cursor-type 'bar)))
         (helix-insert-mode . (lambda () (setq display-line-numbers t))))
  :config
  (helix-mode))
  
;; Old Dashboard Settings (non working?)
; (use-package dashboard
;   :after nerd-icons
;   :config
;   (setq dashboard-display-icons-p t)
;   (setq dashboard-icon-type 'nerd-icons)
;   (dashboard-setup-startup-hook))

; (use-package doom-dashboard
;   :after dashboard
;   :demand t)
              
;; --- 2. Completion (Vertico / Corfu / Orderless) ---
(use-package vertico
  :init (vertico-mode 1))

(use-package marginalia
  :init (marginalia-mode 1))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package corfu
  :init
  (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-quit-no-match t))

;; --- 3. Modal Editing Layer (Meow - Helix Selection Model) ---
; (use-package meow
;   :init
;   (meow-global-mode 1)
;   :config
;   ;; Cursor visibility matching your high-visibility block preferences
;   (setq meow-cursor-type-normal 'box
;         meow-cursor-type-insert 'bar)
;   (meow-setup-indicator)

  ;; Helix-style normal state keybindings
  ; (meow-define-keys 'normal
  ;   ;; Movement
  ;   '("h" . meow-left)
  ;   '("j" . meow-next)
  ;   '("k" . meow-prev)
  ;   '("l" . meow-right)
    
  ;   ;; Selection & Words
  ;   '("w" . meow-mark-word)
  ;   '("b" . meow-back-word)
  ;   '("e" . meow-next-word)
  ;   '("x" . meow-line)
    
  ;   ;; Actions (Action-Last grammar)
  ;   '("d" . meow-kill)
  ;   '("c" . meow-change)
  ;   '("y" . meow-save)
  ;   '("p" . meow-yank)
    
  ;   ;; Undo / Redo
  ;   '("u" . undo)
  ;   '("U" . undo-redo)

  ;   ;; Goto Menu
  ;   '("g h" . move-beginning-of-line)
  ;   '("g l" . move-end-of-line)
  ;   '("g g" . goto-line)

  ;   '("<escape>" . meow-cancel-selection)))

;; --- 4. Org-mode & Ecosystem ---
(use-package org
  :config
  (setq org-directory "~/Notes/Org/"
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

(use-package org-modern
  :hook (org-mode . org-modern-mode))

(use-package org-superstar
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-headline-bullets-list '("◉" "○" "✸" "✿" "•"))
  (org-superstar-special-item-bullet-alist '((?- . "•") (?+ . "➤"))))

(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-auto-emphasis t)
  (org-appear-autolinks t)
  (org-appear-autosubmarkers t))

(use-package org-roam
  :custom
  (org-roam-directory (expand-file-name "Roam" org-directory))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

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
