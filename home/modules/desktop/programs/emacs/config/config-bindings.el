;; === Vim-like bindings with evil ===
;; Maybe switch to meow later: https://github.com/meow-edit/meow
;; https://github.com/ircurry/cfg/blob/master/home/programs/emacs/cur-config/cur-config-bindings.el
;; C-w for evil bindings
(use-package evil ;; C-z to toggle between evil and emacs mode
  :after undo-tree
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  ;;(setq evil-want-C-u-scroll t) ;; Rebind C-u universal argument
  (setq evil-want-C-i-jump nil) ;; Vim jumping keybinds disabled
  ;;  :hook (evil-mode . os/evil-hook)
  (setq evil-undo-system 'undo-tree)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :config
  (general-create-definer os/leader-keys
      :keymaps '(normal insert visual emacs)
      :prefix "SPC"
      :global-prefix "C-SPC"))

;; === Example usage ===
;; (os/leader-keys
;;   "t" '(:ignore t :which-key "Toggles")
;;   "tt" '(counsel-load-theme :which-key "choose theme"))

(use-package hydra)
;; === Example usage ===
(defhydra hydra-text-scale (:timeout 4)
    "scale text"
    ("j" text-scale-increase "in")
    ("k" text-scale-decrease "out")
    ("f" nil "finished" :exit t))

(os/leader-keys
    "ts" 'hydra-text-scale/body :which-key "scale text")

(provide 'config-bindings)
