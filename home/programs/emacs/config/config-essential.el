;; === Basic configuration ===
;; (setq frame-title-format (format "%s's Emacs" (capitalize user-login-name)))
(setq frame-title-format "%b")
(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq inhibit-startup-message t)
(setq initial-buffer-choice t)
(setq initial-scratch-message ";; Scratch Buffer\n\n")
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-auto-revert-mode t)
(setq custom-file (make-temp-file "emacs-custom-"))
(fset 'yes-or-no-p 'y-or-n-p)

;; === Disable default UI elements ===
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)

;; === Meta -> Command (MacOS) ===
(when (eq system-type 'darwin)
	(setq
	 mac-option-modifier nil
	 mac-right-option-modifier nil
	 mac-command-modifier 'meta))

;; === Line numbers ===
(column-number-mode t)
(line-number-mode t)
(global-hl-line-mode t)

(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook ;; Disable line numbers for certain modes
								term-mode-hook
								shell-mode-hook
								treemacs-mode-hook
								eshell-mode-hook))
	(add-hook mode (lambda () (display-line-numbers-mode 0))))

(provide 'config-essential)
