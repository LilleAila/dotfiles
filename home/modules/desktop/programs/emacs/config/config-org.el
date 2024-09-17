;; Different font sizes for headings
(defun os/org-mode-font-setup ()
    (font-lock-add-keywords 'org-mode
                            '(("^ *\\([-]\\) "
                            (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

    (dolist (face '((org-level-1 . 1.2)
                    (org-level-2 . 1.1)
                    (org-level-3 . 1.05)
                    (org-level-4 . 1.0)
                    (org-level-5 . 1.1)
                    (org-level-6 . 1.1)
                    (org-level-7 . 1.1)
                    (org-level-8 . 1.1)))
        (set-face-attribute (car face) nil :font "DejaVu Sans" :weight 'regular :height (cdr face)))

    (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))


;; Set up the plugin
(defun os/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))


(use-package org
  :hook (org-mode . os/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (os/org-mode-font-setup)

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
        '("~/org/Tasks.org"
          "~/org/Notes.org"))

  (setq org-tag-alist ;; Custom tags for C-c C-q
        '((:startgroup)
          ;; Put mutually exclusive tags here
          (:endgroup)
          ("@home" . ?H)
          ("@work" . ?W)
          ("programming" . ?p)
          ("agenda" . ?a)
          ("note" . ?n)
          ("idea" . ?i)))

    ;; Configure custom agenda views
    (setq org-agenda-custom-commands
    '(("d" "Dashboard"
        ((agenda "" ((org-deadline-warning-days 7)))
        (todo "NEXT"
            ((org-agenda-overriding-header "Next Tasks")))
        (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))
        ))

        ("n" "Next Tasks"
        ((todo "NEXT"
               ((org-agenda-overriding-header "Next Tasks")))))

        ("p" "Programming Tasks" tags-todo "+programming-work") ;; Filter by tags

        ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
         ((org-agenda-overriding-header "Low Effort Tasks")
          (org-agenda-max-todos 20)
          (org-agenda-files org-agenda-files)))
    ))

  ;; TODO states
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "PLAN(p)" "READY(r)" "ACTIVE(a)" "|" "COMPLETED(c)" "CANC(k@)")))

  ;; Refile (move item)
  (setq org-refile-targets
        '(("Archive.org" :maxlevel . 1)
          ("Tasks.org" :maxlevel . 1)
          ("Notes.org" :maxlevel . 1)))
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  ;; Capture templates for quick notes
   (setq org-capture-templates
    `(("t" "Task" entry (file+olp "~/org/Tasks.org" "Inbox")
       "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

      ("n" "Note" entry (file+olp "~/org/Notes.org" "Random Notes")
                                  "** %?" :empty-lines 0)
      ))
)

;; Header bullets
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Centering the view
(defun os/org-mode-visual-fill ()
  (setq visual-fill-column-width 150
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))
(use-package visual-fill-column
  :after org
  :defer t
  :hook (org-mode . os/org-mode-visual-fill))

;; Double the LaTeX preview font size (C-c C-x C-l)
;; (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

;; Set leader key bindings
(os/leader-keys
  "o" '(:ignore t :which-key "Org mode")
;;  "ol" '(org-agenda-list :which-key "Agenda list")
  "oa" '(org-agenda :which-key "Agenda")
  "oo" '(org-capture :which-key "Capture")
  "os" '(org-schedule :which-key "Add SCHEDULE")
  "od" '(org-deadline :which-key "Add DEADLINE")
  "ot" '(org-todo :which-key "Toggle state")
  "oT" '(org-time-stamp :which-key "Time stamp")
  "og" '(counsel-org-tag :which-key "Tag (counsel)")
  "oS" '(org-set-tags-command :which-key "Set tags")
  "oe" '(org-set-effort :which-key "Set effort")
  "op" '(org-set-property :which-key "Set property")
  "or" '(org-refile :which-key "Refile")
  "oO" '(org-open-at-point :which-key "Open link")
)

(os/leader-keys ;; Toggle monospace font
  "tf" '(variable-pitch-mode :which-key "Variable pitch")
 )


;; Configure org-babel
(org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)))

(setq org-confirm-babel-evaluate nil)
(setq org-babel-python-command "python3") ;; Fix the python executable name
(push '("conf-unix" . conf-unix) org-src-lang-modes)


;; Org-babel structure templates
;; You can use for example =<el TAB= to insert en elisp code block
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("cf" . "src conf-unix"))

(provide 'config-org)
