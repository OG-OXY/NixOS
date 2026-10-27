		;;; emacs.d/init.el -*- lexical-binding: t; -*- 

 ;; 1. Built-in use-package configuration
(require 'use-package)
(setq use-package-always-ensure nil) ; Since Nix manages packages, don't let MELPA auto-install

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
