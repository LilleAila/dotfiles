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
