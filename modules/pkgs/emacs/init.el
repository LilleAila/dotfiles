;; Restore gc and stuff after early-init
(use-package gcmh
             :init
             (setq gcmh-idle-delay 10
                   gcmh-high-cons-threshold #x40000000
                   gcmh-verbose nil)
             :config
             (gcmh-mode 1))

;; Avoid creating files like autosaves and lockfiles in cwd
(use-package no-littering
  :init
  ;; 1. Point no-littering to your writable local share
  (setq no-littering-etc-directory "~/.local/share/emacs/etc/"
        no-littering-var-directory "~/.local/share/emacs/var/")
  
  :config
  ;; 2. Fix the specific Transient issue you had
  ;; This tells transient to use the no-littering paths
  (setq transient-history-file (no-littering-expand-var-file-name "transient/history.el")
        transient-levels-file  (no-littering-expand-etc-file-name "transient/levels.el")
        transient-values-file  (no-littering-expand-var-file-name "transient/values.el"))

  ;; 3. Handle backups and auto-saves (replaces your let block)
  (setq backup-directory-alist
        `((".*" . ,(no-littering-expand-var-file-name "backup/"))))
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

;; Color scheme
(require 'base16-nix-colors-theme)
(setq base16-theme-256-color-source 'colors)
(load-theme 'base16-nix-colors t)

;; Fonts
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 100)
(set-face-attribute 'fixed-pitch nil :font "JetBrainsMono Nerd Font" :height 100)
(set-face-attribute 'variable-pitch nil :font "DejaVu Sans" :height 120 :weight 'regular)

;; Meta -> Command on MacOS
(when (eq system-type 'darwin)
	(setq
	 mac-option-modifier nil
	 mac-right-option-modifier nil
	 mac-command-modifier 'meta))

;; Line numbers
(setq column-number-mode t)
(global-hl-line-mode t)
(global-display-line-numbers-mode t)

(defun my/disable-line-numbers ()
  (display-line-numbers-mode -1))
(add-hook 'org-mode-hook #'my/disable-line-numbers)
(add-hook 'eshell-mode-hook #'my/disable-line-numbers)
(add-hook 'term-mode-hook #'my/disable-line-numbers)

;; Icons and stuff
(use-package nerd-icons
             :custom
             (nerd-icons-font-family "Symbols Nerd Font"))

;; Modeline
(use-package doom-modeline
  :init (add-hook 'after-init-hook #'doom-modeline-mode)
  :custom 
  (doom-modeline-height 25)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
)

;; Vim motions
(use-package evil
             :init
             (setq evil-want-integration t)
             (setq evil-want-keybinding nil)
             (setq evil-undo-system 'undo-redo)
             :config
             (evil-mode 1)
             (evil-set-initial-state 'embr-mode 'emacs)
             (evil-set-initial-state 'embr-vimium-mode 'emacs))

(use-package evil-collection
             :after evil
             :config
             (evil-collection-init))

;; Key bindings
(use-package general
             :config
             (general-evil-setup)
             (general-create-definer my/leader-keys
                                     :states '(normal insert visual emacs)
                                     :keymaps 'override
                                     :prefix "SPC"
                                     :global-prefix "M-SPC"))

;; Completion
(use-package vertico
             :config
             (vertico-mode)
             :custom
             (vertico-cycle t)
             (vertico-resize nil))

(use-package orderless
             :custom
             (completion-styles '(orderless basic))
             (completion-category-defaults nil)
             (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
             :config
             (marginalia-mode))

(use-package consult)

(my/leader-keys
  "f" '(:ignore t :which-key "Find")
  "ff" '(consult-find :which-key "Files")
  "fb" '(consult-buffer :which-key "Buffers")
  "fs" '(consult-ripgrep :which-key "Grep"))

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
                  cmake-mode dockerfile-mode nix-mode)))
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

(use-package flyover
             :hook ((flymake-mode . flyover-mode))
             :custom
             (flyover-checkers '(flymake))
             (flyover-levels '(error warning info)))

(use-package corfu
             :custom
             (corfu-auto t)
             (corfu-auto-prefix 2)
             (corfu-auto-delay 0.0)
             (corfu-quit-at-boundary 'separator)
             :config
             (global-corfu-mode)
             (set-face-attribute 'corfu-border nil :background (face-attribute 'default :background)))

(use-package cape
             :config
             (add-to-list 'completion-at-point-functions #'cape-dabbrev)
             (add-to-list 'completion-at-point-functions #'cape-file)
             (add-to-list 'completion-at-point-functions #'cape-elisp-block))

(use-package evil-commentary
             :ensure t
             :after evil
             :config
             (evil-commentary-mode))

(electric-pair-mode 1)

(my/leader-keys
  "l" '(:ignore t :which-key "LSP")
  "lr" '(eglot-rename :which-key "Rename")
  "le" '(eldoc :which-key "Open diagnostic float")
  "lj" '(flymake-goto-next-error :which-key "Next diagnostic")
  "lk" '(flymake-goto-prev-error :which-key "Previous diagnostic")
  "la" '(eglot-code-actions :which-key "Code actions")

  "lg" '(:ignore t :which-key "Go to")
  "lgd" '(xref-find-definitions :which-key "Definition")
  "lgr" '(xref-find-references :which-key "References"))

;; Which-key
(use-package which-key
             :config
             (which-key-mode)
             (setq which-key-idle-delay 0.2)
             (setq which-key-idle-secondary-delay 0.01))
