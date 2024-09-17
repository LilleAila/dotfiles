(defun os/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
	:commands (lsp lsp-deferred)
	:hook (lsp-mode . os/lsp-mode-setup)
	:custom (lsp-keymap-prefix "C-c l")
	:config
	(lsp-enable-which-key-integration t)
)

(use-package lsp-ui
	:hook (lsp-mode . lsp-ui-mode)
	:custom
	(lsp-ui-doc-position 'bottom)
)

(use-package lsp-treemacs
	:after lsp-mode
)

(use-package lsp-ivy)

(use-package company
	:after lsp-mode
	:hook (lsp-mode . company-mode)
	:bind (:map company-active-map
					("<tab>" . company-complete-selection)
					;; ("<return>" . company-complete-selection)
				)
			  (:map lsp-mode-map
					("<tab>" . company-indent-or-complete-common)
				)
	:custom
	(company-minimum-prefig-length 1)
	(company-idle-delay 0.0)
)

(use-package company-box
	:hook (company-mode . company-box-mode)
)

;; === Undo tree ===
(use-package undo-tree
  :init
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  :config
  (global-undo-tree-mode))

;; === Commenting ===
(use-package evil-nerd-commenter
	:bind ("M-#" . evilnc-comment-or-uncomment-lines)
)

;; === Direnv ===
(use-package direnv
  :config
  (direnv-mode))

;; === Languages === (move to separate files)
(use-package typescript-mode
	:mode "\\.ts\\'"
	:hook (typescript-mode . lsp-deferred)
	:config
	(setq typescript-indent-level 2)
)

(provide 'config-lsp)
