;; doom.d/init.el
(doom!
	:input
	;; layout              ; auieo layout support

	:completion
	(corfu +orderless)     ; Minimal, fast auto-completion
	vertico                ; Ultra-lightweight minibuffer search

	:ui
	doom                   ; Visual theme
	dashboard         ; Start screen
	hl-todo                ; Highlight TODO keywords
	modeline               ; Status bar
	ophints
	window-select          ; Easy window switching
	workspaces
	vi-tilde-fringe
	(popup +defaults)
	(vc-gutter +pretty)
	
	:editor
	(evil +everywhere)     ; Evil-mode (Vim modal editing)
	file-templates         ; Fast note templates
	snippets               ; Fast snippet expansion

	:emacs
	dired                  ; Fast terminal file manager
	undo                   ; Undo tree

	:lang                  
    (org +roam2)
	markdown

	:config
	(default +bindings +smartparens))
