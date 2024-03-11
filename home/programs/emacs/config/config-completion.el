;; === Completion with ivy + counsel ===
(use-package counsel
	:bind (("M-x" . counsel-M-x)
				 ("C-x b" . counsel-ibuffer)
				 ("C-x C-f" . counsel-find-file)
				 :map minibuffer-local-map
				 ("C-r" . 'counsel-minibuffer-history))
	:config
	(setq ivy-initial-inputs-alist nil))

(use-package swiper
	:commands (swiper))

(use-package ivy
  :diminish
	:after (counsel)
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-serarch-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
	:after (counsel ivy)
	:config
	(ivy-rich-mode 1))

(provide 'config-completion)
