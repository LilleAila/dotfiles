;; https://github.com/emacksnotes/exwm/wiki/EXWM-User-Guide

(defun os/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

(defun os/exwm-init-hook ()
  (exwm-workspace-switch-create 1)

  (os/run-in-background "nm-applet")
)

(defun os/exwm-update-class ()
	(exwm-workspace-rename-buffer exwm-class-name)
)

(use-package exwm
	:config
	;; Set default number of workspaces
	(setq exwm-workspace-number 5)

	;; Fix EXWM buffer names
	(add-hook 'exwm-update-class-hook #'os/exwm-update-class)

	(add-hook 'exwm-init-hook #'os/exwm-init-hook)

	;; Remap caps lock to control
	(start-process-shell-command "xmodmap" nil "xmodmap ~/.emacs.d/exwm/Xmodmap")

	;; Show battery in doom-modeline
	(display-battery-mode)
	(setq doom-modeline-battery t)

	(setq doom-modeline-time t)
	(setq display-time-mode t)
	(setq display-time-24hr-format t)
	(setq display-time-default-load-average nil)

	;; Set screen resolution ( IMPORTANT: run this before (exwm-enable) )
	;; The command comes from `arandr`
	(require 'exwm-randr)
	(exwm-randr-enable)
	(start-process-shell-command "xrandr" nil "xrandr --output LVDS-1 --primary --mode 1600x900 --pos 0x0 --rotate normal --output VGA-1 --off")

	;; System tray ;; Gives an integer-or-something something error, idk
	;; (require 'exwm-systemtray)
	;; (setq exwm-systemtray-height 32)
	;; (exwm-systemtray-enable)

  ;; These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
    '(?\C-x
      ?\C-u
      ?\C-h
      ?\M-x
      ?\M-`
      ?\M-&
      ?\M-:
      ?\C-\M-j  ;; Buffer list
      ?\C-\ ))  ;; Ctrl+Space

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  ;; Set up global key bindings.  These always work, no matter the input state!
  ;; Keep in mind that changing this list after EXWM initializes has no effect.
  (setq exwm-input-global-keys
        `(
          ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
          ([?\s-r] . exwm-reset)

          ;; Move between windows
          ([s-left] . windmove-left)
          ([s-right] . windmove-right)
          ([s-up] . windmove-up)
          ([s-down] . windmove-down)

          ;; Launch applications via shell command
          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))

          ;; Switch workspace
          ([?\s-w] . exwm-workspace-switch)
					([?\s-|] . (lambda () (interactive) (exwm-workspace-switch-create 0)))

          ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

	;; Gets called from `emacs --daemon --eval "(exwm-enable)"
	;; so that exwm does not run when emacs runs as an app
	;; (exwm-enable)
)

(use-package exwm-modeline
  :after (exwm))
(add-hook 'exwm-init-hook #'exwm-modeline-mode)

(provide 'config-exwm)
