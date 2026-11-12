;;;  doom.d/config.el -*- lexical-binding: t; -*-
;; --- 1. Package & Environment Setup ---
(setenv "PATH" (concat (getenv "PATH") ":/run/current-system/sw/bin:~/.nix-profile/bin"))
(setq exec-path (append exec-path '("/run/current-system/sw/bin" "~/.nix-profile/bin")))

; (use-package! helix
;   :demand t
;   :hook ((helix-normal-mode . (lambda () (setq display-line-numbers 'relative)))
;          (helix-normal-mode . (lambda () (setq cursor-type 'box)))
;          (helix-insert-mode . (lambda () (setq cursor-type 'bar)))
;          (helix-insert-mode . (lambda () (setq display-line-numbers t))))
;   :config
;   (helix-mode))

; (with-eval-after-load 'helix
;   (helix-define-key 'normal (kbd "SPC") doom-leader-map))

; (with-eval-after-load 'doom-dashboard
;   (helix-define-key 'normal "j" #'helix-next-line '+doom-dashboard-mode)
;   (helix-define-key 'normal "k" #'helix-previous-line '+doom-dashboard-mode))
; 
; This one prob is right not this one^
; (after! doom-dashboard
  ; (define-key +doom-dashboard-mode-map (kbd "j") #'next-line)
  ; (define-key +doom-dashboard-mode-map (kbd "k") #'previous-line))

; (with-eval-after-load 'dired
;   (helix-define-key 'normal "h" #'dired-up-directory 'dired-mode)
;   (helix-define-key 'normal "l" #'dired-find-file 'dired-mode))


;: Enable persistent undo history across restarts and increase history limits
(global-undo-fu-session-mode +1)
(setq undo-fu-session-file-limit 1000
      undo-fu-session-compression 'zlib)

;; --- Core Paths ---

(after! dired
	(require 'dired-aux))
(map! :leader
	  :prefix "f"
	  :desc "Find Directory" "d" #'dired)

(use-package! which-key
	:demand t
	:config
	(which-key-mode 1)
	(setq which-key-idle-delay 0.05
    which-key-popup-type 'side-window
    which-key-side-window-location 'bottom))

;; --- Org-mode Visual & Functional Settings ---
(setq org-directory "~/Documents/DOOM/")
(after! org
  (setq org-agenda-files (list org-directory)
		org-journal-dir (expand-file-name "journal" org-directory)
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

(use-package! org-roam
  :after org
  :config
  (setq org-roam-directory
       (expand-file-name "roam" org-directory)))

;; --- Unified Org Typography & Bullet Mix ---
(use-package! org-superstar
  :after org
  :hook (org-mode . org-superstar-mode)
  :config  (setq org-superstar-headline-bullets-list '("◉" "○" "✸" "✿" "•")
        org-superstar-special-item-bullet-alist '((?- . "•") (?+ . "➤"))
        org-superstar-prettify-item-bullets t))

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

;; Autoload helpful commands when invoked
(autoload #'helpful-callable "helpful" nil t)
(autoload #'helpful-variable "helpful" nil t)
(autoload #'helpful-key      "helpful" nil t)
(autoload #'helpful-command  "helpful" nil t)
(autoload #'helpful-symbol   "helpful" nil t)

(global-set-key [remap describe-function] #'helpful-callable)
(global-set-key [remap describe-variable] #'helpful-variable)
(global-set-key [remap describe-key]      #'helpful-key)
(global-set-key [remap describe-command]  #'helpful-command)
(global-set-key [remap describe-symbol]   #'helpful-symbol)

;; --- Terminal vs. GUI Conditional Environment Toggles ---
(if (display-graphic-p)
    ;; --- GUI-ONLY SETTINGS ---
    (progn
      ;; Custom proportional font scaling for GUI headings if desired
      (custom-set-faces
       '(org-level-1 ((t (:inherit outline-1 :height 1.35 :weight bold))))
       '(org-level-2 ((t (:inherit outline-2 :height 1.2 :weight bold))))
       '(org-level-3 ((t (:inherit outline-3 :height 1.1 :weight bold))))
       '(org-level-4 ((t (:inherit outline-4 :height 1.05 :weight bold))))))

  ;; --- TERMINAL / TUI-ONLY SETTINGS (-nw inside Ghostty) ---
  (progn
    ;; Force tooltips into the echo area to prevent child-frame window errors
    (setq tooltip-use-echo-area t)
    ;; Enable corfu-terminal fallback so completion overlays render as TUI text
	(fter! image-roll
      (global-image-roll-mode +1)))
