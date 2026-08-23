;; Scrolling stuff
(pixel-scroll-precision-mode 1)
(setq scroll-conservatively 101)
(advice-add #'mouse-wheel-text-scale :override #'ignore)

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

(electric-pair-mode 1)

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

(provide 'config-misc)
