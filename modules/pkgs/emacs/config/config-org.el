;; Different font sizes for headings
(defun my/org-mode-font-setup ()
    (dolist (face '((org-level-1 . 1.2)
                    (org-level-2 . 1.1)
                    (org-level-3 . 1.05)
                    (org-level-4 . 1.0)
                    (org-level-5 . 1.1)
                    (org-level-6 . 1.1)
                    (org-level-7 . 1.1)
                    (org-level-8 . 1.1)))
        (set-face-attribute (car face) nil :font "DejaVu Sans" :weight 'regular :height (cdr face)))

    (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))


;; Move different things to set into its own function
(defun my/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))


(use-package org
  :hook (org-mode . my/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (my/org-mode-font-setup)

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-return-follows-link t)
  (setq org-hide-emphasis-markers t)
  (setq org-agenda-files '("~/notes/org"))
  (setq org-src-fontify-natively t)

  ;; Increase LaTeX preview size (C-c C-x C-l)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

  ;; Capture templates
  (setq org-capture-templates
    '(
      ("t" "General To-Do"
        entry (file+headline "~/notes/org/todo.org" "General Tasks")
        "* TODO [#B] %?\n:Created: %T\n "
        :empty-lines 0)
    )
  )

  ;; To-Do states
  (setq org-todo-keywords
    '((sequence "TODO(t)" "PLANNING(p)" "IN-PROGRESS(i@/!)" "VERIFYING(v!)" "BLOCKED(b@)" "|" "DONE(d!)" "OBE(o@!)" "Wont-DO(w@/!)"))
  )

  ;; org-babel
  (org-babel-do-load-languages
     'org-babel-load-languages
     '((emacs-lisp . t)
       (python . t)))

  (setq org-confirm-babel-evaluate nil)
  (setq org-babel-python-command "python3") ;; Fix the python executable name
  (push '("conf-unix" . conf-unix) org-src-lang-modes)

  ;; Images
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images) ;; Show output images immediately
  (setq org-startup-with-inline-images t)
  (setq org-image-max-width 800)
  (setq org-image-actual-width nil)

  ;; Bindings and stuff
  (my/leader-keys
    "t" '(:ignore t :which-key "Fonts")
    "tm" '(variable-pitch-mode :which-key "Variable pitch")
   )

  :bind (:map org-mode-map
    ("C-c <up>" . org-priority-up)
    ("C-c <down>" . org-priority-down)
    ("C-c C-g C-r" . org-shiftmetaright)
    ("C-c e" . (lambda ()
                 (interactive)
                 (if (derived-mode-p 'org-mode)
                     (let ((file (buffer-file-name)))
                       (if file
                           (let* ((proc-name "org-to-pdf-proc")
                                  (buf (get-buffer-create " *org-to-pdf-internal*"))
                                  (proc (start-process proc-name buf "org-to-pdf" file)))
                             (set-process-filter
                              proc
                              (lambda (p output)
                                (message "[org-to-pdf] %s" (string-trim-right output))))

                             (set-process-sentinel
                              proc
                              (lambda (p event)
                                (when (string-match-p "finished" event)
                                  (message "org-to-pdf finished successfully for: %s"
                                           (car (process-command p))))))
                             (message "Started org-to-pdf asynchronously for: %s" file))
                         (user-error "Current buffer is not backed by a file")))
                 (user-error "Current buffer is not in org-mode")))))
  :bind
  ("C-c l" . org-store-link)
  ("C-c a" . org-agenda)
  ("C-c c" . org-capture))

(use-package org-modern
             :hook (org-mode . org-modern-mode)
             :custom
             (org-modern-star '("◉" "○" "✸" "✿" "✤")))

; (use-package org-superstar
;              :after org
;              :hook (org-mode . org-superstar-mode)
;              :config
;              (setq org-hide-leading-stars t))

;; Center the editor
(use-package visual-fill-column
  :ensure t
  :after org
  :hook (org-mode . my/org-mode-visual-fill)
  :config
  (defun my/org-mode-visual-fill ()
    (setq visual-fill-column-width 150
          visual-fill-column-center-text t)
    (visual-fill-column-mode 1)))

(defvar my/org-dirs
  '("~/notes/org"
    "~/notes/org/assets"))

(defun my/create-org-dirs ()
  "Ensure all directories in `my/required-directories` exist."
  (dolist (dir my/org-dirs)
    (let ((expanded-dir (file-truename dir)))
      (unless (file-directory-p expanded-dir)
        (make-directory expanded-dir t)
        (message "Created directory: %s" expanded-dir)))))

(use-package org-roam
             :init
             (my/create-org-dirs)
             :bind (("C-c n l" . org-roam-buffer-toggle)
                    ("C-c n f" . org-roam-node-find)
                    ("C-c n i" . org-roam-node-insert)
                    ("C-c n c" . org-roam-capture)
                    ("C-c n j" . org-roam-dailies-capture-today)
                    ("C-c n d" . org-roam-delete-current-note))
             :custom
             (org-roam-directory (file-truename "~/notes/org"))
             :config
             (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
             (org-roam-setup)
             (org-roam-db-autosync-mode +1)
             ; (require 'org-roam-graph)
             ;; Open links with C-c C-o in the same pane
             (setq org-link-frame-setup
                   (quote ((file . find-file))))

             ;; Capture templates and notes and stuff
             (setq org-roam-capture-templates
                   '(
                     ("d" "default" plain
                      "%?"
                      :target (file+head "roam/%<%Y%m%d%H%M%S>.org"
                                         "#+title: ${title}\n#+created: %U\n#+last_modified: %U\n#+filetags:\n\n")
                      :unnarrowed t)))
             (setq org-roam-dailies-directory "daily/")
             (setq org-roam-dailies-capture-templates
                   '(("default" "default" entry
                      "* %U - %?\n\n"
                      :target (file+head "%<%Y-%m-%d>.org"
                                         "#+title: %<%Y-%m-%d>\n\n"))))

             (defun org-roam-delete-current-note ()
                    "Delete the file backing the current Org-roam note, move it to trash, and kill the buffer."
                    (interactive)
                    (unless (org-roam-file-p)
                      (user-error "Current buffer is not an Org-roam note"))
                    (when (yes-or-no-p (format "Are you sure you want to delete '%s'? " (buffer-name)))
                      (let ((delete-by-moving-to-trash t))
                        (delete-file (buffer-file-name) t)
                        (kill-current-buffer)
                        (message "Note deleted and moved to trash.")))))

(defconst my/typst-author "Olai Solsvik" "Default author name for ox-typst exports.")

(use-package ox-typst
             :after org
             :config
             (setq org-typst-from-latex-environment #'org-typst-from-latex-with-naive
                   org-typst-from-latex-fragment     #'org-typst-from-latex-with-naive)

             (setq org-typst-default-template
                   (format "\
                           #import \"%s\": custom-template
                           #show: custom-template.with(
                             title: \"%%t\",
                             author: \"%%a\",
                             date: \"%%d\",
                           )

                           %%c
                           "
                           (expand-file-name "template.typ" user-emacs-directory)))

             (defun my/org-export-output-directory-modifier (orig-fun extension &optional subtreep pub-dir)
                 "Direct exported files (including ox-typst PDFs) to the Downloads directory."
                 (unless pub-dir
                   (setq pub-dir (expand-file-name "~/Downloads/"))
                   (unless (file-directory-p pub-dir)
                     (make-directory pub-dir t)))
                 (apply orig-fun extension subtreep pub-dir nil))

             (advice-add 'org-export-output-file-name :around #'my/org-export-output-directory-modifier))

(use-package ob-typst
             :after org
             :custom
             (ob-typst/default-rules-alist
               '((page . "width: 600pt, height: auto, margin: 1em, fill: rgb(\"#282828\")")
                 (text . "font: \"DejaVu Sans\", size: 14pt, fill: rgb(\"#ebdbb2\")")))
             :config
             (defvar my-ob-typst-inhibit-preamble nil
               "Prevent recursive preamble injection.")

             (advice-add 'org-babel-execute:typst :around
                         (lambda (orig-fun body params)
                           (if my-ob-typst-inhibit-preamble
                               (funcall orig-fun body params)
                             (let* ((preamble-file (expand-file-name "typst/ob-typst-preamble.typ" user-emacs-directory))
                                    (preamble-content (if (file-exists-p preamble-file)
                                                          (with-temp-buffer
                                                            (insert-file-contents preamble-file)
                                                            (buffer-string))
                                                        ""))
                                    (modified-body (concat preamble-content "\n\n" body))
                                    (my-ob-typst-inhibit-preamble t))
                               (funcall orig-fun modified-body params))))))

(use-package typst-overlay
  :custom
  ;; Optional: shown values are the defaults
  (typst-overlay-scale 1.3)
  (typst-overlay-max-active-compiles 8)
  :hook ((typst-ts-mode . typst-overlay-mode)
         (org-mode . typst-overlay-mode)
         (after-save . typst-overlay-save-refresh))
; Instead patched in upstream
;   :config
; (defun typst-overlay--smart-previous-line (orig-fn &rest args)
;   "Move to previous line, but if entering a typst-overlay from below, land at its end."
;   (let* ((old-point (point))
;          (_ (apply orig-fn args))
;          (new-point (point)))
;     (when (> old-point new-point)
;       (let* ((overlays (overlays-at new-point))
;              (typst-ov (cl-find-if (lambda (o) (overlay-get o 'typst-overlay)) overlays)))
;         (when typst-ov
;           (unless (and (>= old-point (overlay-start typst-ov))
;                        (<= old-point (overlay-end typst-ov)))
;             (goto-char (overlay-end typst-ov))))))))
;
; (advice-add 'previous-line :around #'typst-overlay--smart-previous-line)
; (advice-add 'evil-previous-line :around #'typst-overlay--smart-previous-line)
  )

(use-package org-download
             :after org
             :commands (org-download-clipboard)
             :bind (:map org-mode-map
                         ("C-c n p" . org-download-clipboard))
             :config
             (setq-default org-download-image-dir "~/notes/org/assets")
             (setq org-download-method 'directory)
             (setq org-download-heading-lvl nil)
             (setq org-download-timestamp "%Y%m%d%H%M%S_")
             (setq org-download-image-org-width 400)
             (defun my/org-download-ignore-id (orig-fn &rest args)
                 (cl-letf (((symbol-function 'org-id-get-create) #'ignore))
                   (apply orig-fn args)))

             (advice-add 'org-download-clipboard :around #'my/org-download-ignore-id)
             (advice-add 'org-download-screenshot :around #'my/org-download-ignore-id))

(provide 'config-org)
