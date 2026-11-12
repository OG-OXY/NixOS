;;; emacs.d/early-init.el -*- lexical-binding: t; -*-
 
;; 1. Boost garbage collection during startup for faster daemon launch
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))

;; 2. System Environment & Load Paths (Available before any packages load)
(setenv "PATH" (concat (getenv "PATH") ":/run/current-system/sw:/run/current-system/sw/bin:/run/current-system/sw/sbin:/run/current-system/sw/lib:/run/current-system/sw/share:/run/current-system/sw/etc:" (expand-file-name "~/.nix-profile/bin")))
(setq exec-path (append exec-path (list "/run/current-system/sw/bin" (expand-file-name "~/.nix-profile/bin"))))
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; 3. Redirect native compilation cache before anything compiles
(when (boundp 'native-comp-eln-load-path)
  (startup-redirect-eln-cache
   (expand-file-name "emacs/eln-cache/" (or (getenv "XDG_CACHE_HOME") "~/.cache"))))

(setq no-littering-etc-directory
      (expand-file-name "emacs/etc/" (or (getenv "XDG_STATE_HOME") "~/.local/state")))
(setq no-littering-var-directory
      (expand-file-name "emacs/var/" (or (getenv "XDG_CACHE_HOME") "~/.cache")))

;; 5. Prevent GTK frame resize flicker & disable default UI bars early
(setq frame-inhibit-implied-resize t)
(setq inhibit-startup-screen t)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
