;; imit.scm

(require "helix.scm")
(require "splash.scm")

;; Trigger the dashboard ONLY if you ran 'hx' with no specific file open
(when (equal? (command-line) '("sx")) 
  (show-splash))

(keymap (global) 
  (normal 
    (space (t ":open-term"))))

;; Example Hook: Print a message to the status bar every time you save a file
(define (my-save-hook cx)
  (helix-status-msg "File written successfully!"))

(register-hook! 'on-save my-save-hook)
