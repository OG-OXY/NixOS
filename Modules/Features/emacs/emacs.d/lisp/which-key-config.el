(use-package which-key
  :ensure nil
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.2)
  (setq which-key-popup-type 'side-window)
  (setq which-key-side-window-location 'bottom))

(defvar my-leader-map (make-sparse-keymap) "Main leader map.")
(keymap-global-set "C-c m" my-leader-map)

(provide 'which-key-config)
