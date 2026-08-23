;; Treesitter and lsp
(use-package treesit
  :config
  (setq jit-lock-defer-time 0.05
        jit-lock-stealth-time 1.0)
  (setq major-mode-remap-alist
        (mapcan (lambda (mode)
                  (let* ((mode-str (symbol-name mode))
                         (ts-mode (intern (concat (string-remove-suffix "-mode" mode-str) "-ts-mode"))))
                    (if (fboundp ts-mode)
                        (list (cons mode ts-mode))
                      nil)))
                '(python-mode rust-mode c-mode c++-mode js-mode
                  typescript-mode json-mode css-mode bash-mode
                  cmake-mode dockerfile-mode nix-mode typst-mode)))
  (setq treesit-font-lock-level 3))

(when-let ((path (getenv "EMACS_GRAMMAR_PATH")))
  (setq treesit-extra-load-path (list path)))

(use-package eglot
             :defer t)

(defun my/eglot-lazy-ensure ()
  "Start Eglot after a short delay to prevent UI stutters on buffer open."
  (run-at-time "0.5 sec" nil #'eglot-ensure))

(use-package nix-ts-mode
             :mode "\\.nix\\'"
             :hook (nix-ts-mode . my/eglot-lazy-ensure)
             :config
             (with-eval-after-load 'eglot
                                   (add-to-list 'eglot-server-programs
                                                '(nix-ts-mode . ("nixd")))
                                   (setq-default eglot-workspace-configuration
                                                 `(:nixd (:diagnostic (:suppress (vector "sema-escaping-with" "var-bind-to-this")))))))

(use-package lua-ts-mode
             :mode "\\.lua\\'"
             :hook (lua-ts-mode . my/eglot-lazy-ensure)
             :config
             (with-eval-after-load 'eglot
                                   (setq-default eglot-workspace-configuration
                                                 `(:Lua (:diagnostics (:globals ( vector "vim")))))))

(use-package c-ts-mode
             :mode ("\\.c\\'" . c-ts-mode)
             :hook (c-ts-mode my/eglot-lazy-ensure))

(use-package c++-ts-mode
             :mode ("\\.cpp\\'" . c++-ts-mode)
             :hook (c++-ts-mode . my/eglot-lazy-ensure))

(use-package python-ts-mode
             :mode "\\.py\\'"
             :hook (python-ts-mode . my/eglot-lazy-ensure))

(use-package rust-ts-mode
             :mode "\\.rs\\'"
             :hook (rust-ts-mode . my/eglot-lazy-ensure))

(use-package typescript-ts-mode
             :mode "\\.ts\\'"
             :hook (typescript-ts-mode . my/eglot-lazy-ensure))

(use-package html-ts-mode
             :mode "\\.html\\'")

(use-package css-ts-mode
             :mode "\\.css\\'")

(use-package svelte-ts-mode
             :mode "\\.svelte\\'"
             :hook (svelte-ts-mode . my/eglot-lazy-ensure))

(use-package astro-ts-mode
             :mode "\\.astro\\'"
             :hook (astro-mode . my/eglot-lazy-ensure))

;; FIXME: ts grammar broken
(use-package typst-ts-mode
             :mode "\\.typ\\'"
             :config
             (add-to-list 'treesit-language-source-alist
                          '(typst "https://github.com/uben0/tree-sitter-typst"))
             (unless (treesit-language-available-p 'typst)
                     (treesit-install-language-grammar 'typst))
             (add-to-list 'org-src-lang-modes '("typst" . typst-ts-mode)))

(use-package flyover
             :hook ((flymake-mode . flyover-mode))
             :custom
             (flyover-checkers '(flymake))
             (flyover-levels '(error warning info)))

(my/leader-keys
  "l" '(:ignore t :which-key "LSP")
  "ln" '(eglot-rename :which-key "Rename")
  "le" '(eldoc :which-key "Open diagnostic float")
  "lj" '(flymake-goto-next-error :which-key "Next diagnostic")
  "lk" '(flymake-goto-prev-error :which-key "Previous diagnostic")
  "la" '(eglot-code-actions :which-key "Code actions")

  "lg" '(:ignore t :which-key "Go to")
  "lgd" '(xref-find-definitions :which-key "Definition")
  "lgr" '(xref-find-references :which-key "References"))

(provide 'config-ide)
