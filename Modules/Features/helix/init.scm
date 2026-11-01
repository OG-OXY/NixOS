;; imit.scm
(require-builtin steel/random as rand::)
(require "keymaps.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))
(require "helix/configuration.scm")
(require "helix.scm")
(require "splash.scm")
(require "recentf.scm")
(require "helix-file-watcher/file-watcher.scm")
(require "file-tree.scm")
(require "term.scm")

;; Shell
(set-default-shell! "/bin/fish")

;; Dashboard
(when (equal? (command-line) '("sx")) 
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
  (normal (C-r (f ":recentf-open-files")) (space (t ":open-term") (l ":load-buffer") (o ":eval-sexpr"))))

;; Hooks
;; Import the core helix commands namespace
(require (prefix-in helix. "helix/commands.scm"))

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
