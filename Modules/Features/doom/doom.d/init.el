;;; doom.d/init.el
(doom!
	:input
	;; layout

	:completion
	(corfu +orderless +icons +dabbrev) ;; add +icons if using gui
	vertico

	:ui
	doom
	dashboard
	hl-todo
	modeline
	ophints
	window-select
	workspaces
	vi-tilde-fringe
	(popup +defaults)
	(vc-gutter +pretty)
	
	:editor
	; (evil +everywhere)
	(evil +everywhere +multiple-cursors)
	; evil
	file-templates
	snippets

	:emacs
	dired
	undo

	:term
	eshell
	vterm

	:os
	(tty +osc)

	:lang
	emacs-lisp
    (org +roam2 +pretty +dragndrop) ; +modern
	nix
	rust
	(cc +ccls)
	markdown

	:tools
	(lsp +eglot +booster)
	(majutsu +forge)
	tree-sitter

	:config
	(default +bindings +smartparens))
	; (default +smartparens))
