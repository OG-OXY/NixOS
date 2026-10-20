;; doom.d/init.el

(doom!
	:input
	;; layout              ; auieo layout support

	:completion
	(corfu +orderless)     ; Minimal, fast auto-completion
	vertico                ; Ultra-lightweight minibuffer search

	:ui
	doom                   ; Visual theme
	doom-dashboard         ; Start screen
	hl-todo                ; Highlight TODO keywords
	modeline               ; Status bar
	window-select          ; Easy window switching

	:editor
	(evil +everywhere)     ; Evil-mode (Vim modal editing)
	file-templates         ; Fast note templates
	snippets               ; Fast snippet expansion

	:emacs
	dired                  ; Fast terminal file manager
	undo                   ; Undo tree

	:lang                  
    org
	markdown

	:config
	(default +bindings +smartparens))
