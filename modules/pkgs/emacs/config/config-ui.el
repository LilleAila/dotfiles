;; Color scheme
(require 'base16-nix-colors-theme)
(setq base16-theme-256-color-source 'colors)
(load-theme 'base16-nix-colors t)

;; Fonts
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 100)
(set-face-attribute 'fixed-pitch nil :font "JetBrainsMono Nerd Font" :height 100)
(set-face-attribute 'variable-pitch nil :font "DejaVu Sans" :height 120 :weight 'regular)

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

;; Line numbers
(setq column-number-mode t)
(global-hl-line-mode t)
(global-display-line-numbers-mode t)

(defun my/disable-line-numbers ()
  (display-line-numbers-mode -1))
(add-hook 'org-mode-hook #'my/disable-line-numbers)
(add-hook 'eshell-mode-hook #'my/disable-line-numbers)
(add-hook 'term-mode-hook #'my/disable-line-numbers)

(provide 'config-ui)
