;; https://jwiegley.github.io/use-package/keywords/
; === Split config into multiple files ===
;; The files can now be "loaded" with (require 'file-name)
(dolist (path '("config" "ide"))
  (add-to-list 'load-path (locate-user-emacs-file path)))

(require 'config-essential)
(require 'config-ui)
(require 'config-completion)
(require 'config-help)
(require 'config-bindings)
(require 'config-org)

(require 'config-lsp)
