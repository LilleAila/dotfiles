(use-package ewm
             :init
             ;; Reset keymap such that i can define my own in :bind
             (setopt ewm-mode-map (make-sparse-keymap))
             :custom
             (ewm-output-config '(("eDP-1" :width 1920 :height 1200)))
             (ewm-intercept-prefixes
               '("C-x" "C-h" "M-x" ; Emacs stuff
                 "s-:" ; Evil-cmd
                 ("s-o" :fullscreen) ; Fullscreen
                 ("<Print>" :fullscreen)))
             (ewm-input-config
               '((keyboard :xkb-layouts "no"
                           :xkb-options "ctrl:nocaps")))
             :config
            (ewm-text-input-auto-mode-enable)
            :bind (:map ewm-mode-map
                        ("s-:" . evil-ex)
                        ("s-<return>" . (lambda () (interactive)
                                  (start-process "ghostty" nil "ghostty")))

                        ("s-SPC" . ewm-launch-app)
                        ("s-o" . ewm-toggle-fullscreen)

                        ("s-c" . kill-ring-save)
                        ("s-v" . yank)

                        ;; Movement and stuff
                        ("s-h" . ewm-focus-left)
                        ("s-j" . ewm-focus-down)
                        ("s-k" . ewm-focus-up)
                        ("s-l" . ewm-focus-right)

                        ("s-t" . ewm-frame-new)
                        ("s-w" . ewm-frame-close)
                        ("s-H" . ewm-frame-left)
                        ("s-L" . ewm-frame-right)
                        ("C-s-H" . ewm-frame-move-left)
                        ("C-s-L" . ewm-frame-move-right)

                        ("s-1" . ewm-frame-select)
                        ("s-2" . ewm-frame-select)
                        ("s-3" . ewm-frame-select)
                        ("s-4" . ewm-frame-select)
                        ("s-5" . ewm-frame-select)
                        ("s-6" . ewm-frame-select)
                        ("s-7" . ewm-frame-select)
                        ("s-8" . ewm-frame-select)
                        ("s-9" . ewm-frame-select)))
