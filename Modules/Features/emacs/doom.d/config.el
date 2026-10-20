;; doom.d/config.el -*- lexical-binding: t; -*-
(use-package! org-roam
	:custom
	(org-roam-directory "~/Notes/Vault")
	:config
	(org-roam-db-autosync-mode))
