;; === Fonts ===
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 100)
(set-face-attribute 'fixed-pitch nil :font "JetBrainsMono Nerd Font" :height 100)
;; (set-face-attribute 'variable-pitch nil :font "Arial" :height 100 :weight 'regular)

;; === Theme ===
(use-package doom-themes
  :config
  (load-theme 'doom-dracula t)
)

;; === Modeline ===
(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 28)))

(provide 'config-ui)
