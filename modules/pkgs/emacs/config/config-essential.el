;; Restore gc and stuff after early-init
(use-package gcmh
             :init
             (setq gcmh-idle-delay 2
                   gcmh-high-cons-threshold (* 128 1024 1024) ; 128MB
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

(provide 'config-essential)
