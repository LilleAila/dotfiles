(use-package company
  :custom
  (company-idle-delay 0.0)
  (company-minimum-prefix-length 2)
  (company-show-numbers t)
  (company-tooltip-align-annotations t)
  (company-frontends '(company-pseudo-tooltip-unless-just-one-frontend
                       company-preview-if-just-one-frontend
                       company-echo-metadata-frontend))
  :config
  (global-company-mode t))

(use-package cape
             :config
             (add-to-list 'completion-at-point-functions #'cape-dabbrev)
             (add-to-list 'completion-at-point-functions #'cape-file)
             (add-to-list 'completion-at-point-functions #'cape-elisp-block))

(use-package vertico
             :config
             (vertico-mode)
             :custom
             (vertico-cycle t)
             (vertico-resize nil))

(use-package orderless
             :custom
             (completion-styles '(orderless basic))
             (completion-category-defaults nil)
             (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
             :config
             (marginalia-mode))

(use-package consult)

(my/leader-keys
  "f" '(:ignore t :which-key "Find")
  "ff" '(consult-find :which-key "Files")
  "fb" '(consult-buffer :which-key "Buffers")
  "fs" '(consult-ripgrep :which-key "Grep"))

(provide 'config-completion)
