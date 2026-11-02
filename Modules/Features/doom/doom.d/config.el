;;;  doom.d/config.el -*- lexical-binding: t; -*-
;; --- 1. Package & Environment Setup ---
(setenv "PATH" (concat (getenv "PATH") ":/run/current-system/sw/bin:~/.nix-profile/bin"))
(setq exec-path (append exec-path '("/run/current-system/sw/bin" "~/.nix-profile/bin")))

;: Enable persistent undo history across restarts and increase history limits
(global-undo-fu-session-mode +1)
(setq undo-fu-session-file-limit 1000
      undo-fu-session-compression 'zlib)

;; --- Core Paths ---
(setq org-directory "~/Notes/Org/")
(setq org-agenda-files (list org-directory))

; (after! evil
;   ;; Disable default state overrides if your stripped fork handles keymaps differently
;   (setq evil-want-keybinding nil)
  
;   ;; Initialize your custom evil fork mode
;   (evil-mode 1)

;   ;; Coordinate your custom evil bindings alongside your helix-mode setup
;   (map! :map evil-normal-state-map
;         "SPC" doom-leader-map
;         "C-w" doom-leader-map))

; (after! evil
;   (setq evil-collection-mode-list nil) 
;   (evil-mode -1))

; --- Helix Modal Editing Mode Configuration ---
(after! helix
  (helix-mode)
  (add-hook! 'helix-normal-mode-hook
       (setq display-line-numbers 'relative
              cursor-type 'box))
  (add-hook! 'helix-insert-mode-hook
       (setq display-line-numbers t
             cursor-type 'bar)))
   ; (map! :map helix-normal-mode-map
   ;       "SPC" doom-leader-map
 		; "C-w" doom-leader-map))

;; --- Org-mode Visual & Functional Settings ---
(after! org

  ;; Syntax highlighting inside #+begin_src blocks
  (setq org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-src-preserve-indentation t)

  ;; Collapse ugly :PROPERTIES: drawers on startup
  (setq org-cycle-hide-drawer-startup t)

  ;; Clean typography & layout matching Obsidian style
  (setq org-hide-leading-stars t
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-startup-indented t
        org-ellipsis " ▾")

  (setq org-superstar-headline-bullets-list '("◉" "○" "✸" "✿" "•")
		org-superstar-special-item-bullet-alist '((?- . "•") (?+ . "➤")))
 
  ;; Inline image settings & Chafa terminal preview bridge
  (setq org-startup-with-inline-images t
        image-use-external-converter t
        image-converter 'chafa)

  ;; Safe link handling (route external links via xdg-open instead of failing frames)
  (setq browse-url-browser-function 'browse-url-xdg-open)
  (setq org-link-frame-setup
        '((vm . vm-visit-folder)
          (vm-imap . vm-visit-imap-folder)
          (gnus . gnus)
          (file . find-file)
          (wl . wl-other-frame))))

;; --- Modern UI Overlays & Hooks ---
(add-hook! 'org-mode-hook #'org-modern-mode)
(add-hook! 'org-mode-hook #'org-superstar-mode)

;; Org-Appear (reveals syntax markers dynamically on cursor approach)
(after! org-appear
  (setq org-appear-auto-emphasis t
        org-appear-autolinks t
        org-appear-autosubmarkers t))
(add-hook! 'org-mode-hook #'org-appear-mode)

;; --- Org-Roam ---
(after! org-roam
  (setq org-roam-directory (expand-file-name "Roam" org-directory)))

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
    (add-hook! 'corfu-mode-hook #'corfu-terminal-mode)
	(after! image-roll
      (global-image-roll-mode +1)))
