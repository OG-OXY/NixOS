;;; doom.d/init.el
(doom!
	:completion
	(corfu +orderless +icons +dabbrev)
	vertico

	:ui
	doom
	dashboard
	(emoji +unicode +ascii +github) 
	hl-todo
	indent-guides
	ligatures
	modeline
	ophints
	(popup +defaults)
	smooth-scroll
	tabs
	treemacs
	(vc-gutter +pretty)
	vi-tilde-fringe
	window-select
	workspaces
	
	:editor ; objed parinfer
	(evil +everywhere) ; evil
	file-templates
	fold
	(format +onsave)
	multiple-cursors
	rotate-text
	snippets
	(whitespace +guess +trim)
	word-wrap

	:emacs
	dired
	electric
	ibuffer
	tramp
	undo

	:term
	eshell
	shell
	vterm
	ghostel

	:checkers
	(syntax +icons +flymake)
	(spell +everywhere +flyspell +hunspell)
	grammar

	:tools
	biblio
	collab
	debugger
	direnv
	(eval +overlay)
	lookup
	(lsp +eglot +booster)
	(magit +forge)
	make
	pdf
	tree-sitter
	upload

	:os
	(tty +osc)

	:lang
	(nix +lsp +tree-sitter)
	(rust +lsp +tree-sitter)
	zig
	(cc +lsp +tree-sitter)
	csharp
	(go +lsp +tree-sitter)
	python
	sh
	lua
	json
	yaml
	toml
	(scheme +guile)
	common-lisp
	emacs-lisp
    (org +pretty +dragndrop +pandoc +journal +roam)
	latex
	(markdown +lsp +tree-sitter) ;; +grip?

	:email
	(mu4e +org +gmail)

	:app
	calendar
	emms
	everywhere
	(rss +org)

	:config
	(default +bindings +smartparens +gnupg))
