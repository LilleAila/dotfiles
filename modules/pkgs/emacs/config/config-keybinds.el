(defun my-split-window-scratch (split-func &rest args)
  "Split window using SPLIT-FUNC, then focus the new window and switch to *scratch*."
  (let ((new-win (apply split-func args)))
    (select-window new-win)
    (scratch-buffer)
    new-win))

(defun my-split-window-below-scratch (&optional size)
  (interactive "P")
  (my-split-window-scratch #'split-window-below size))

(defun my-split-window-right-scratch (&optional size)
  (interactive "P")
  (my-split-window-scratch #'split-window-right size))

(use-package evil
             :init
             (setq evil-want-integration t)
             (setq evil-want-keybinding nil)
             (setq evil-want-Y-yank-to-eol t)
             (setq evil-undo-system 'undo-redo)
             (setq evil-split-window-below t
                   evil-vsplit-window-right t)
             :config
             (evil-mode 1)
             (evil-define-key 'motion 'global
                              "gj" 'evil-next-visual-line
                              "gk" 'evil-previous-visual-line)
             (evil-ex-define-cmd "sp" #'my-split-window-below-scratch)
             (evil-ex-define-cmd "vs" #'my-split-window-right-scratch))

(use-package evil-collection
             :after evil
             :config
             (evil-collection-init))

(use-package evil-commentary
             :ensure t
             :after evil
             :config
             (evil-commentary-mode))

(use-package general
             :config
             (general-evil-setup)
             (general-create-definer my/leader-keys
                                     :states '(normal insert visual emacs)
                                     :keymaps 'override
                                     :prefix "SPC"
                                     :global-prefix "M-SPC"))

(use-package which-key
             :config
             (which-key-mode)
             (setq which-key-idle-delay 0.2)
             (setq which-key-idle-secondary-delay 0.01))

(provide 'config-keybinds)
