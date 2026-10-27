;;; emacs.d/init.el -*- lexical-binding: t; -*- 

;; --- 1. Package & Environment Setup ---
(require 'use-package)
(setq use-package-always-ensure nil)

;; Basic UI cleanup
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)

;; Load Theme & Modeline
(load-theme 'doom-one t)
(doom-modeline-mode 1)

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

;; --- 3. Helix Emulation Layer (hel) ---
;; Completely isolated from Evil since Evil is absent from the system package list
(use-package hel
  :ensure t
  :custom (inhibit-startup-screen t)
  :config (hel-mode))

;; --- 4. Persistent Undo (Undo-Fu-Session) ---
; (use-package undo-fu-session
;   :init
;   (undo-fu-session-mode +1)
;   :custom
;   (undo-fu-session-file-limit 1000)
;   (undo-fu-session-compression 'zlib))

;; --- 5. Org-mode & Ecosystem ---
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

;; --- 6. Pandoc & Markdown Integration ---
(use-package pandoc-mode
  :hook ((markdown-mode org-mode) . turn-on-pandoc))

;; --- 7. Additional Tools (Magit, Majutsu, Image-Roll) ---
(use-package magit
  :bind ("C-x g" . magit-status))

(use-package majutsu
  :after magit)

(use-package image-roll
  :hook (image-mode . image-roll-mode))

;; --- 8. GUI-Only Specific Configurations ---
(when (display-graphic-p)
  (custom-set-faces
   '(org-level-1 ((t (:inherit outline-1 :height 1.35 :weight bold))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.2 :weight bold))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.1 :weight bold))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.05 :weight bold))))))

;; Terminal echo area safeguard for tooltips
(unless (display-graphic-p)
  (setq tooltip-use-echo-area t))

; ;; 2. Lazy load Evil only when entering modal states (or globally if you want it instantly)
; (use-package evil
;   :init
;   (setq evil-want-keybinding nil)
;   :config
;   (evil-mode 1))

; ;; 3. Lazy load Magit ONLY when you run `M-x magit-status`
; (use-package magit
;   :commands (magit-status magit-dispatch))

; ;; 4. Lazy load Majutsu only when you invoke its workflow commands
; (use-package majutsu
;   :after magit
;   :commands (majutsu-status))

; ;; 5. Lazy load your Helix Emulation Layer (hel) on global hook or keybinding
; (use-package hel
;   :after evil
;   :hook (after-init . global-hel-mode))
