; (setq default-input-method "norwegian-keyboard")
; (setq-default default-input-method "norwegian-keyboard")

(use-package ewm
             :init
             (setopt ewm-mode-map (make-sparse-keymap))
             :custom
             (ewm-output-config '(("eDP-1" :width 1920 :height 1200)))
             :config
             (setopt ewm-input-config
                     '((keyboard :xkb-layouts "no"
                                 :xkb-options "ctrl:nocaps")))
            (ewm-text-input-auto-mode-enable)
            :bind (:map ewm-mode-map
                        ("s-spc" . ewm-launch-app)
                        ("s-o" . ewm-toggle-fullscreen)
                        ("s-c" . kill-ring-save)
                        ("s-v" . yank))

                        ("s-h" . ewm-focus-left)
                        ("s-j" . ewm-focus-down)
                        ("s-k" . ewm-focus-up)
                        ("s-l" . ewm-focus-right)

                        ("s-t" . ewm-frame-new)
                        ("s-w" . ewm-frame-close)
                        ("s-S-h" . ewm-frame-left)
                        ("s-S-l" . ewm-frame-right)
                        ("C-s-S-h" . ewm-frame-move-left)
                        ("C-s-S-l" . ewm-frame-move-right)

                        ("s-1" . ewm-frame-select)
                        ("s-2" . ewm-frame-select)
                        ("s-3" . ewm-frame-select)
                        ("s-4" . ewm-frame-select)
                        ("s-5" . ewm-frame-select)
                        ("s-6" . ewm-frame-select)
                        ("s-7" . ewm-frame-select)
                        ("s-8" . ewm-frame-select)
                        ("s-9" . ewm-frame-select))

; (add-hook 'after-change-major-mode-hook
;           (lambda ()
;             (unless current-input-method
;               (activate-input-method "norwegian-keyboard"))))
;
; (setq evil-want-input-method-and-multilingual-display t)
