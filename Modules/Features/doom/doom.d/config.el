;;;  doom.d/config.el -*- lexical-binding: t; -*-
;; Append System PATH's
(setenv "PATH" (concat (getenv "PATH") ":/run/current-system/sw/bin:/run/current-system/sw/sbin:/run/current-system/sw/lib:/run/current-system/sw/share:/run/current-system/sw/etc:"))
(setq exec-path (append exec-path '("/run/current-system/sw/bin"))) ;; Append System Exec PATH (/bin)
;; Append "lisp" DIR to Load Path
(let ((default-directory (expand-file-name "lisp" user-emacs-directory)))
  (when (file-directory-p default-directory)
    (add-to-list 'load-path default-directory)
    (normal-top-level-add-subdirs-to-load-path)))
; (add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(setq org-directory "~/Documents/ORG/") ;; Set Org DIR

;; Undo
(after! undo-fu-session
  (setq undo-fu-session-file-limit 1000
        undo-fu-session-compression 'zlib))

;; Corfu Completion
(after! corfu
  (setq corfu-auto t
        corfu-auto-prefix 2
        corfu-auto-delay 0.05))

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
        (expand-file-name "inbox.org" org-directory)
        (expand-file-name "notes.org" org-directory)
        (expand-file-name "todo.org" org-directory))
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
        browse-url-browser-function 'browse-url-xdg-open))
        ; org-tag-alist '(("nixos" . ?n)
        ;                 ("nushell" . ?u)
        ;                 ("emacs" . ?e)
        ;                 ("helix" . ?h)
        ;                 ("debug" . ?d)))

;; Org-Roam
(after! org-roam
  (setq org-roam-directory
        (expand-file-name "roam" org-directory)))

;; Org-Modern
(after! org-modern
  (setq org-modern-table t
        org-modern-block t
        org-modern-todo t
        org-modern-tag t
  		org-modern-star 'replace
        org-modern-replace-stars "◉○◉○◉○"
        ; org-modern-star 'fold
        ; org-modern-fold-stars '(("●" . "○")
        ;                         ("◆" . "◇")
        ;                         ("■" . "□")
        ;                         ("▸" . "▾"))
        org-modern-list '((?- . "•") ;; 
                          (?+ . "➤")
                          (?* . "✸"))))

;; Org-Appear (reveals org syntax on cursor hover)
(after! org-appear
  (setq org-appear-auto-emphasis t
        org-appear-autolinks t
        org-appear-autosubmarkers t))
(add-hook! 'org-mode-hook #'org-appear-mode)

(after! org-journal
  (setq org-journal-dir (expand-file-name "journal/" org-directory)
        org-journal-file-format "%Y%m%d"
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
(setq text-mode-ispell-word-completion nil)
(after! ispell
  (setq ispell-program-name "hunspell"
        ispell-dictionary "en_US"))

(after! cape
  ;; Emacs Lisp symbols + file paths in Elisp buffers
  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions
                           (cape-capf-super (cape-capf-buster #'cape-elisp-symbol)
                                            #'cape-file))))

  ;; Elisp inside Org and Markdown code blocks
  (add-hook 'org-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions #'cape-elisp-block)))
  (add-hook 'markdown-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions #'cape-elisp-block)))

  ;; Keywords + file paths in programming buffers
  (add-hook 'prog-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions
                           (cape-capf-super (cape-capf-buster #'cape-keyword)
                                            #'cape-file))))

  ;; History completion in Eshell and shell/comint modes
  (add-hook 'eshell-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions
                               (cape-capf-buster #'cape-history))))
  (add-hook 'comint-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions
                               (cape-capf-buster #'cape-history)))))

;; Format +onsave
(after! apheleia
  ;; Exclude nix in apheleia's format-on-save
  (push 'nix-mode apheleia-inhibit-functions))

;; RSS Feed
(after! elfeed
  (setq rmh-elfeed-org-files (list (expand-file-name "elfeed/elfeed.org" org-directory))))

;; GUI + TUI Settings
(add-hook 'server-after-make-frame-hook
          (lambda ()
            (when (display-graphic-p)
              (custom-set-faces!
                '(org-level-1 :weight bold :height 1.3)
                '(org-level-2 :weight bold :height 1.15)
                '(org-level-3 :weight bold :height 1.05)
                '(org-level-4 :weight bold))
              (setq-default line-spacing 0.15)
              (after! image-roll
                (global-image-roll-mode 1)))))

(unless (display-graphic-p)
  (setq tooltip-use-echo-area t))

;; DISABLED
;; --- Unified Org Typography & Bullet Mix ---
; (use-package! org-superstar
;   :after org
;   :hook (org-mode . org-superstar-mode)
;   :config
;   (setq org-superstar-prettify-item-bullets t
; 		org-superstar-headline-bullets-list '( "◉" "○" "◉" "○" "◉" "○") ;; Extra symbols ("◉" "○" <-- original header 1 and 2) Current pick: "" ""  "" "" "󰫢"
; 		org-superstar-special-item-bullet-alist '((?- . "✸") (?+ . "➤"))))
 
; (use-package! org-modern
;   :after org
;   :hook (org-mode . org-modern-mode)
;   :config
;   (setq org-modern-star nil))
; 
; (after! org-superstar
;   (setq org-superstar-headline-bullets-list '("◉" "○" "◉" "○" "◉" "○"))) ;; "" "" "" "󰫢" "" ""
