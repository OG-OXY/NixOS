;; splash.scm
(require "helix.scm")

(define (show-splash)
  (helix-command "vsplit")
  (helix-command "open-debug-window")
  (helix-status-msg "Dashboard loaded."))

(provide show-splash)
