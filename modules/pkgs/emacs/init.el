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

;; Simpler yes/no confirmation
(setf (symbol-function 'yes-or-no-p) #'y-or-n-p)

;; Spaces instead of tabs
; (setq-default indent-tabs-mode nil)
; (setq-default tab-width 4)

;; Line numbers
(setq column-number-mode t)
(global-hl-line-mode t)
(global-display-line-numbers-mode t)

(defun my/disable-line-numbers ()
  (display-line-numbers-mode -1))
(add-hook 'org-mode-hook #'my/disable-line-numbers)
(add-hook 'eshell-mode-hook #'my/disable-line-numbers)
(add-hook 'term-mode-hook #'my/disable-line-numbers)

;; Scrolling stuff
(pixel-scroll-precision-mode 1)
(setq scroll-conservatively 101)

;; Detect scrolling with debounce
;; Used to inhibit typst-overlay causing jittering by updating while scrolling.
(defvar my/native-scrolling-p nil)
(defvar my/scroll-idle-timer nil)
(advice-add 'pixel-scroll-precision :around
            (lambda (orig-fun &rest args)
              (setq my/native-scrolling-p t)
              (when (timerp my/scroll-idle-timer)
                (cancel-timer my/scroll-idle-timer))
              (apply orig-fun args)
              (setq my/scroll-idle-timer
                    (run-with-idle-timer
                     0.2 nil
                     (lambda ()
                       (setq my/native-scrolling-p nil)
                       (setq my/scroll-idle-timer nil)
                       (typst-overlay--post-command-update))))))
(advice-add 'typst-overlay--post-command-update :around
            (lambda (orig-fun &rest args)
              (unless my/native-scrolling-p
                (apply orig-fun args))))

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
             (evil-define-key 'motion 'global
                              "gj" 'evil-next-visual-line
                              "gk" 'evil-previous-visual-line))

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

(use-package company
  :custom
  (company-idle-delay 0.0)
  (company-minimum-prefix-length 2)
  (company-show-numbers t)
  (company-tooltip-align-annotations t)
  (company-frontends '(company-pseudo-tooltip-unless-just-one-frontend
                       company-preview-if-just-one-frontend
                       company-echo-metadata-frontend))
  :config
  (global-company-mode t))

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
  "ln" '(eglot-rename :which-key "Rename")
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

;; Dirvish
(use-package dirvish
             :config
             (dirvish-override-dired-mode)
             (with-eval-after-load 'evil
                                   (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
                                   (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-find-file)))

(my/leader-keys
  "fm" '(dirvish-dwim :which-key "Dirvish dwim")
  "fd" '(dirvish :which-key "Dirvish")
  "fq" '(dirvish-quit :which-key "Quit dirvish"))

;; Vterm
(defun my/vterm-setup-ui ()
  (display-line-numbers-mode -1)
  (hl-line-mode -1)
  (setq-local face-remapping-alist '((hl-line :inherit default)))

  (setq-local face-remapping-alist
              '((hl-line :inherit default)
                (nobreak-space :inherit default)
                (escape-glyph :inherit default)
                (glyphless-char :inherit default)))

  (setq-local show-trailing-whitespace nil)
  (if (bound-and-true-p whitespace-mode) (whitespace-mode -1))
  (if (bound-and-true-p indent-guide-mode) (indent-guide-mode -1))

  (setq-local line-spacing nil)
  (setq-local line-height 1.0)
  (setq-local window-vscroll nil)

  (set-window-fringes (selected-window) 0 0)
  (setq-local window-divider-default-places nil)
  (setq-local indent-tabs-mode nil)

  (setq-local scroll-margin 0)
  (setq-local fast-but-imprecise-scrolling t))

(use-package vterm
             :commands vterm
             :hook (vterm-mode . my/vterm-setup-ui)
             :config
             (setq vterm-keymap-exceptions nil)
             (evil-set-initial-state 'vterm-mode 'emacs))

;; Different font sizes for headings
(defun my/org-mode-font-setup ()
    (dolist (face '((org-level-1 . 1.2)
                    (org-level-2 . 1.1)
                    (org-level-3 . 1.05)
                    (org-level-4 . 1.0)
                    (org-level-5 . 1.1)
                    (org-level-6 . 1.1)
                    (org-level-7 . 1.1)
                    (org-level-8 . 1.1)))
        (set-face-attribute (car face) nil :font "DejaVu Sans" :weight 'regular :height (cdr face)))

    (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))


;; Move different things to set into its own function
(defun my/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))


(use-package org
  :hook (org-mode . my/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (my/org-mode-font-setup)

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-return-follows-link t)
  (setq org-hide-emphasis-markers t)
  (setq org-agenda-files '("~/notes/org"))
  (setq org-src-fontify-natively t)

  ;; Increase LaTeX preview size (C-c C-x C-l)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

  ;; Capture templates
  (setq org-capture-templates
    '(
      ("t" "General To-Do"
        entry (file+headline "~/notes/org/todo.org" "General Tasks")
        "* TODO [#B] %?\n:Created: %T\n "
        :empty-lines 0)
    )
  )

  ;; To-Do states
  (setq org-todo-keywords
    '((sequence "TODO(t)" "PLANNING(p)" "IN-PROGRESS(i@/!)" "VERIFYING(v!)" "BLOCKED(b@)" "|" "DONE(d!)" "OBE(o@!)" "Wont-DO(w@/!)"))
  )

  ;; org-babel
  (org-babel-do-load-languages
     'org-babel-load-languages
     '((emacs-lisp . t)
       (python . t)))

  (setq org-confirm-babel-evaluate nil)
  (setq org-babel-python-command "python3") ;; Fix the python executable name
  (push '("conf-unix" . conf-unix) org-src-lang-modes)

  ;; Images
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images) ;; Show output images immediately
  (setq org-startup-with-inline-images t)
  (setq org-image-max-width 800)
  (setq org-image-actual-width nil)

  ;; Bindings and stuff
  (my/leader-keys
    "t" '(:ignore t :which-key "Fonts")
    "tm" '(variable-pitch-mode :which-key "Variable pitch")
   )

  :bind (:map org-mode-map
    ("C-c <up>" . org-priority-up)
    ("C-c <down>" . org-priority-down)
    ("C-c C-g C-r" . org-shiftmetaright)
    ("C-c e" . (lambda ()
                 (interactive)
                 (if (derived-mode-p 'org-mode)
                     (let ((file (buffer-file-name)))
                       (if file
                           (let* ((proc-name "org-to-pdf-proc")
                                  (buf (get-buffer-create " *org-to-pdf-internal*"))
                                  (proc (start-process proc-name buf "org-to-pdf" file)))
                             (set-process-filter
                              proc
                              (lambda (p output)
                                (message "[org-to-pdf] %s" (string-trim-right output))))

                             (set-process-sentinel
                              proc
                              (lambda (p event)
                                (when (string-match-p "finished" event)
                                  (message "org-to-pdf finished successfully for: %s"
                                           (car (process-command p))))))
                             (message "Started org-to-pdf asynchronously for: %s" file))
                         (user-error "Current buffer is not backed by a file")))
                 (user-error "Current buffer is not in org-mode")))))
  :bind
  ("C-c l" . org-store-link)
  ("C-c a" . org-agenda)
  ("C-c c" . org-capture))

(use-package org-modern
             :hook (org-mode . org-modern-mode)
             :custom
             (org-modern-star '("◉" "○" "✸" "✿" "✤")))

; (use-package org-superstar
;              :after org
;              :hook (org-mode . org-superstar-mode)
;              :config
;              (setq org-hide-leading-stars t))

;; Center the editor
(use-package visual-fill-column
  :ensure t
  :after org
  :hook (org-mode . my/org-mode-visual-fill)
  :config
  (defun my/org-mode-visual-fill ()
    (setq visual-fill-column-width 150
          visual-fill-column-center-text t)
    (visual-fill-column-mode 1)))

(defvar my/org-dirs
  '("~/notes/org"
    "~/notes/org/assets"))

(defun my/create-org-dirs ()
  "Ensure all directories in `my/required-directories` exist."
  (dolist (dir my/org-dirs)
    (let ((expanded-dir (file-truename dir)))
      (unless (file-directory-p expanded-dir)
        (make-directory expanded-dir t)
        (message "Created directory: %s" expanded-dir)))))

(use-package org-roam
             :init
             (my/create-org-dirs)
             :bind (("C-c n l" . org-roam-buffer-toggle)
                    ("C-c n f" . org-roam-node-find)
                    ("C-c n i" . org-roam-node-insert)
                    ("C-c n c" . org-roam-capture)
                    ("C-c n j" . org-roam-dailies-capture-today)
                    ("C-c n d" . org-roam-delete-current-note))
             :custom
             (org-roam-directory (file-truename "~/notes/org"))
             :config
             (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
             (org-roam-setup)
             (org-roam-db-autosync-mode +1)
             ; (require 'org-roam-graph)
             ;; Open links with C-c C-o in the same pane
             (setq org-link-frame-setup
                   (quote ((file . find-file))))
             ;; Capture templates and notes and stuff
             (setq org-roam-capture-templates
                   '(
                     ("d" "default" plain
                      "%?"
                      :target (file+head "%<%Y%m%d%H%M%S>.org"
                                         "#+title: ${title}\n#+created: %U\n#+last_modified: %U\n#+filetags:\n\n")
                      :unnarrowed t)))
             (setq org-roam-dailies-directory "daily/")
             (setq org-roam-dailies-capture-templates
                   '(("default" "default" entry
                      "* %U - %?\n\n"
                      :target (file+head "%<%Y-%m-%d>.org"
                                         "#+title: %<%Y-%m-%d>\n\n"))))

             (defun org-roam-delete-current-note ()
                    "Delete the file backing the current Org-roam note, move it to trash, and kill the buffer."
                    (interactive)
                    (unless (org-roam-file-p)
                      (user-error "Current buffer is not an Org-roam note"))
                    (when (yes-or-no-p (format "Are you sure you want to delete '%s'? " (buffer-name)))
                      (let ((delete-by-moving-to-trash t))
                        (delete-file (buffer-file-name) t)
                        (kill-current-buffer)
                        (message "Note deleted and moved to trash.")))))

(defconst my/typst-author "Olai Solsvik" "Default author name for ox-typst exports.")

(use-package ox-typst
             :after org
             :config
             (setq org-typst-from-latex-environment #'org-typst-from-latex-with-naive
                   org-typst-from-latex-fragment     #'org-typst-from-latex-with-naive)

             (setq org-typst-default-template
                   (format "\
                           #import \"%s\": custom-template
                           #show: custom-template.with(
                             title: \"%%t\",
                             author: \"%%a\",
                             date: \"%%d\",
                           )

                           %%c
                           "
                           (expand-file-name "template.typ" user-emacs-directory)))

             (defun my/org-export-output-directory-modifier (orig-fun extension &optional subtreep pub-dir)
                 "Direct exported files (including ox-typst PDFs) to the Downloads directory."
                 (unless pub-dir
                   (setq pub-dir (expand-file-name "~/Downloads/"))
                   (unless (file-directory-p pub-dir)
                     (make-directory pub-dir t)))
                 (apply orig-fun extension subtreep pub-dir nil))

             (advice-add 'org-export-output-file-name :around #'my/org-export-output-directory-modifier))

(use-package ob-typst
             :after org
             :custom
             (ob-typst/default-rules-alist
               '((page . "width: 600pt, height: auto, margin: 1em, fill: rgb(\"#282828\")")
                 (text . "font: \"DejaVu Sans\", size: 14pt, fill: rgb(\"#ebdbb2\")")))
             :config
             (defvar my-ob-typst-inhibit-preamble nil
               "Prevent recursive preamble injection.")

             (advice-add 'org-babel-execute:typst :around
                         (lambda (orig-fun body params)
                           (if my-ob-typst-inhibit-preamble
                               (funcall orig-fun body params)
                             (let* ((preamble-file (expand-file-name "typst/ob-typst-preamble.typ" user-emacs-directory))
                                    (preamble-content (if (file-exists-p preamble-file)
                                                          (with-temp-buffer
                                                            (insert-file-contents preamble-file)
                                                            (buffer-string))
                                                        ""))
                                    (modified-body (concat preamble-content "\n\n" body))
                                    (my-ob-typst-inhibit-preamble t))
                               (funcall orig-fun modified-body params))))))

(use-package typst-overlay
  :custom
  ;; Optional: shown values are the defaults
  (typst-overlay-scale 1.3)
  (typst-overlay-max-active-compiles 8)
  :hook ((typst-ts-mode . typst-overlay-mode)
         (org-mode . typst-overlay-mode)
         (after-save . typst-overlay-save-refresh))
;   :config
; (defun typst-overlay--smart-previous-line (orig-fn &rest args)
;   "Move to previous line, but if entering a typst-overlay from below, land at its end."
;   (let* ((old-point (point))
;          (_ (apply orig-fn args))
;          (new-point (point)))
;     (when (> old-point new-point)
;       (let* ((overlays (overlays-at new-point))
;              (typst-ov (cl-find-if (lambda (o) (overlay-get o 'typst-overlay)) overlays)))
;         (when typst-ov
;           (unless (and (>= old-point (overlay-start typst-ov))
;                        (<= old-point (overlay-end typst-ov)))
;             (goto-char (overlay-end typst-ov))))))))
;
; (advice-add 'previous-line :around #'typst-overlay--smart-previous-line)
; (advice-add 'evil-previous-line :around #'typst-overlay--smart-previous-line)
  )

; (defun my/org-download-clipboard-no-id ()
;   "Paste image from clipboard without letting org-download create a property drawer."
;   (interactive)
;   (let ((org-id-include-to-child nil))
;     (org-download-clipboard)))

(use-package org-download
             :after org
             :commands (org-download-clipboard)
             :bind (:map org-mode-map
                         ("C-c n p" . org-download-clipboard))
             :config
             (setq-default org-download-image-dir "~/notes/org/assets")
             (setq org-download-method 'directory)
             (setq org-download-heading-lvl nil)
             (setq org-download-timestamp "%Y%m%d%H%M%S_")
             (setq org-download-image-org-width 400)
             (defun my/org-download-ignore-id (orig-fn &rest args)
                 (cl-letf (((symbol-function 'org-id-get-create) #'ignore))
                   (apply orig-fn args)))

             (advice-add 'org-download-clipboard :around #'my/org-download-ignore-id)
             (advice-add 'org-download-screenshot :around #'my/org-download-ignore-id))
