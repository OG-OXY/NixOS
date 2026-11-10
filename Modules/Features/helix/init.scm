;; init.scm
(require-builtin steel/random as rand::)
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))
(require "helix/configuration.scm")
(require "helix/keymaps.scm")
(require "helix-file-watcher/file-watcher.scm")
(require "recentf-hx/recentf.scm")
(require "splash-hx/splash.scm")
(require "steel-pty/term.scm")
(require "file-tree.scm")
(require "focus.scm")
(require "git-status-picker.scm")
(require "labelled-buffers.scm")
(require "packages/package.scm")
(require "picker.scm")
(require "scheme-indent.scm")
(require "helix.scm")

;; Shell
(set-default-shell! "/run/current-system/sw/bin/fish")

;; Dashboard
(when (equal? (command-line) '("hx")) 
  (show-splash))

;; Recent Files + Watcher 
(recentf-snapshot)
(spawn-watcher)

;; Options
(file-picker (fp-hidden #f))
(cursorline #t)
(soft-wrap (sw-enable #t))

;; To remove a binding, set it to 'no_op
;; For example, this will make it impossible to enter insert mode:
;; (hash "normal" (hash "i" 'no_op))

;; Binds
(keymap (global) 
  (normal (space (t ":open-term") (l ":load-buffer") (o ":eval-sexpr"))))

; (C-x ":helix.write-buffer-close!") (C-r (f ":recentf-open-files"))


;; Register an event listener or advise the view creation hook
; (define (on-buffer-open-or-split)
;   (let ((current-buf ()))
;     ;; Check if the buffer is empty or matches your splash condition
;     (if (is-empty-buffer? current-buf)
;         (show-splash)
;         #f)))

;; Hooks
;; Hook into Helix buffer/window creation events if exposed by steelix runtime
; (register-event-listener! 'buffer-open on-buffer-open-or-split)

;; Import the core helix commands namespace (require (prefix-in helix. "helix/commands.scm"))
(define scm-keybindings (hash "insert" (hash "ret" ':scheme-indent "C-l" ':insert-lambda)))

(define standard-keybindings (deep-copy-global-keybindings))
(define file-tree-base (deep-copy-global-keybindings))
(merge-keybindings standard-keybindings scm-keybindings)
(merge-keybindings file-tree-base FILE-TREE-KEYBINDINGS)
(set-global-buffer-or-extension-keymap (hash "scm" standard-keybindings FILE-TREE file-tree-base))

;; LSP definitions
(define-lsp "steel-language-server" (command "steel-language-server") (args '()))
(define-lsp "rust-analyzer" (config (experimental (hash 'testExplorer #t))))

;; Language definition
(define-language "scheme"
                 (formatter (command "raco") (args '("fmt" "-i")))
                 (auto-format #true)
                 (language-servers '("steel-language-server")))
