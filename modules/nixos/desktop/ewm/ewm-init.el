;; Auto-split new window in the direction with the most space
(defun my-ewm-smart-split-toggle (buffer alist)
  "Split the current active pane dynamically and display BUFFER there."
  (let* ((orig-window (selected-window))
         (split-direction (if (> (window-pixel-width orig-window)
                                 (window-pixel-height orig-window))
                              'right
                            'below))
         (new-window (split-window orig-window nil split-direction)))
    (when new-window
      (window--display-buffer buffer new-window 'reuse)
      (select-window new-window))))

;; Open a new workspcae with a scratch buffer
(defun my-ewm-frame-new-scratch ()
  "Create a new EWM frame and open the *scratch* buffer in it instead of cloning the current buffer."
  (interactive)
  (let ((prev-frame (selected-frame)))
    (ewm-frame-new)
    (let ((new-frame (car (frame-list))))
      (when (and new-frame (not (eq new-frame prev-frame)))
        (with-selected-frame new-frame
          (scratch-buffer))))))

;; Window management
;; Extremely janky vibe coded functions to mimic window management in other tiling WMs
; (require 'windmove)
;
; (defun my/column-window-count (&optional win)
;   "Return the number of windows in the same column as WIN."
;   (let* ((w (or win (selected-window)))
;          (edges (window-edges w))
;          (left (nth 0 edges))
;          (right (nth 2 edges))
;          (count 0))
;     (dolist (window (window-list))
;       (let ((e (window-edges window)))
;         (when (and (= (nth 0 e) left) (= (nth 2 e) right))
;           (setq count (1+ count)))))
;     count))
;
; (defun my/bottom-window-in-column (&optional win)
;   "Safely find the bottom-most window in the same column as WIN using window edges."
;   (let* ((target-win (or win (selected-window)))
;          (edges (window-edges target-win))
;          (left (nth 0 edges))
;          (right (nth 2 edges))
;          (best-win target-win)
;          (max-bottom (nth 3 edges)))
;     (dolist (w (window-list))
;       (let ((w-edges (window-edges w)))
;         (when (and (= (nth 0 w-edges) left)
;                    (= (nth 2 w-edges) right)
;                    (> (nth 3 w-edges) max-bottom))
;           (setq max-bottom (nth 3 w-edges)
;                 best-win w))))
;     best-win))
;
; (defun my/top-window-in-column (&optional win)
;   "Safely find the top-most window in the same column as WIN using window edges."
;   (let* ((target-win (or win (selected-window)))
;          (edges (window-edges target-win))
;          (left (nth 0 edges))
;          (right (nth 2 edges))
;          (best-win target-win)
;          (min-top (nth 1 edges)))
;     (dolist (w (window-list))
;       (let ((w-edges (window-edges w)))
;         (when (and (= (nth 0 w-edges) left)
;                    (= (nth 2 w-edges) right)
;                    (< (nth 1 w-edges) min-top))
;           (setq min-top (nth 1 w-edges)
;                 best-win w))))
;     best-win))
;
; (defun my/window-structural-move (dir type)
;   "Move current window buffer structurally.
; DIR is 'left or 'right.
; TYPE is 'below or 'column."
;   (let* ((curr-win (selected-window))
;          (curr-buf (current-buffer)))
;     (cond
;      ((eq type 'below)
;       (let ((target-win (windmove-find-other-window dir)))
;         (when target-win
;           (let ((bottom-win (my/bottom-window-in-column target-win)))
;             (select-window bottom-win)
;             (split-window-vertically)
;             (other-window 1)
;             (set-window-buffer (selected-window) curr-buf)
;             (when (window-live-p curr-win)
;               (delete-window curr-win))))))
;
;      ((eq type 'column)
;       ;; Do nothing if we are already at the outer edge of the screen in direction DIR
;       (when (windmove-find-other-window dir)
;         (if (> (my/column-window-count curr-win) 1)
;             ;; Multiple windows in current column: expel current window into a new column beside this column
;             (let* ((top-col-win (my/top-window-in-column curr-win))
;                    (new-win (split-window top-col-win nil (if (eq dir 'left) 'left 'right))))
;               (set-window-buffer new-win curr-buf)
;               (select-window new-win)
;               (when (window-live-p curr-win)
;                 (delete-window curr-win)))
;           ;; Single window in current column: move past the adjacent column
;           (let* ((adj-win (windmove-find-other-window dir))
;                  (target-top-win (my/top-window-in-column adj-win))
;                  (new-win (split-window target-top-win nil (if (eq dir 'left) 'left 'right))))
;             (set-window-buffer new-win curr-buf)
;             (select-window new-win)
;             (when (window-live-p curr-win)
;               (delete-window curr-win)))))))))
;
; (defun my/window-swap-buffers (direction)
;   "Swap buffer and height of current window with window in DIRECTION ('up or 'down)."
;   (let* ((curr-win (selected-window))
;          (target-win (windmove-find-other-window direction)))
;     (when target-win
;       (let* ((curr-buf (window-buffer curr-win))
;              (target-buf (window-buffer target-win))
;              (target-height (window-total-height target-win)))
;         (set-window-buffer curr-win target-buf)
;         (set-window-buffer target-win curr-buf)
;         (let ((delta (- target-height (window-total-height curr-win))))
;           (window-resize curr-win delta nil t))
;         (select-window target-win)))))

;; Ewm setup
(use-package ewm
             :init
             ;; Reset keymap such that i can define my own in :bind
             (setopt ewm-mode-map (make-sparse-keymap))
             :custom
             (ewm-output-config '(("eDP-1" :width 1920 :height 1200)))
             (ewm-intercept-prefixes
               '("C-x" "C-h" "M-x" "C-c" "M-:" ; Emacs stuff
                 "s-H" "s-L" "C-s-h" "C-s-j" "C-s-k" "C-s-l" ; Window management
                 "s-." ; evil-ex
                 ("s-o" :fullscreen)))
             (ewm-input-config
               '((touchpad :natural-scroll t :tap nil :dwt t :accel-profile "flat")
                 (trackpoint :accel-profile "flat" :accel-speed 0.5)
                 (keyboard :xkb-layouts "no"
                           :xkb-options "ctrl:nocaps"
                           :repeat-delay 200
                           :repeat-rate 60)))
             (ewm-focus-follows-mouse t)
             (ewm-mouse-follows-focus t)
             (ewm-cursor-auto-hide 1)
             (ewm-cursor-hide-while-typing t)
             (ewm-unfocused-alpha 1.0)
             :config
             (require 'buffer-move)
             (ewm-text-input-auto-mode-enable)

             ;; Automatically tile new windows
             (add-to-list 'display-buffer-alist
              `((lambda (buffer _action)
                  (and (with-current-buffer buffer
                         (derived-mode-p 'ewm-surface-mode))
                       (not (string= (buffer-name (window-buffer (selected-window))) "*scratch*"))))
                (my-ewm-smart-split-toggle)
                (inhibit-same-window . t)))

             ;; Close emacs window when wayland surface is closed
             (add-hook 'kill-buffer-hook
                       (lambda ()
                         (when (derived-mode-p 'ewm-surface-mode)
                           (let ((win (get-buffer-window (current-buffer))))
                             (when (and win (not (one-window-p t)))
                               (delete-window win))))))

             ;; Open scratch buffer on new workspaces
             (add-hook 'ewm-new-frame-hook
                       (lambda ()
                         (with-selected-frame (selected-frame)
                           (let ((display-buffer-alist nil))
                             (set-window-buffer (selected-window) "*scratch*")))))
             :bind (:map ewm-mode-map
                         ("s-." . evil-ex)
                         ("s-<return>" . (lambda () (interactive) (start-process "ghostty" nil "ghostty")))

                         ("s-SPC" . ewm-launch-app)
                         ("s-o" . ewm-toggle-fullscreen)

                         ("s-c" . kill-ring-save)
                         ("s-v" . yank)

                         ("s-s" . (lambda () (interactive) (start-process-shell-command "grim" nil "grim - | wl-copy")))
                         ("s-S" . (lambda () (interactive) (start-process-shell-command "grim" nil "grim -g \"$(slurp)\" - | wl-copy")))

                         ;; Movement and stuff
                         ("s-h" . ewm-focus-left)
                         ("s-j" . ewm-focus-down)
                         ("s-k" . ewm-focus-up)
                         ("s-l" . ewm-focus-right)

                         ; ("s-H" . (lambda () (interactive)(my/window-structural-move 'left 'below)))
                         ; ("s-L" . (lambda () (interactive)(my/window-structural-move 'right 'below)))
                         ; ("C-s-h" . (lambda () (interactive)(my/window-structural-move 'left 'column)))
                         ; ("C-s-j" . (lambda () (interactive)(my/window-swap-buffers 'down)))
                         ; ("C-s-k" . (lambda () (interactive)(my/window-swap-buffers 'up)))
                         ; ("C-s-l" . (lambda () (interactive)(my/window-structural-move 'right 'column)))
                         ; ("s-H" . buf-move-left)
                         ; ("s-J" . buf-move down)
                         ; ("s-K" . buf-move-up)
                         ; ("s-L" . buf-move-right)

                         ("s-t" . my-ewm-frame-new-scratch)
                         ("s-w" . ewm-frame-close)
                         ("M-s-H" . ewm-frame-left)
                         ("M-s-L" . ewm-frame-right)
                         ("M-C-s-H" . ewm-frame-move-left)
                         ("M-C-s-L" . ewm-frame-move-right)

                         ("s-1" . ewm-frame-select)
                         ("s-2" . ewm-frame-select)
                         ("s-3" . ewm-frame-select)
                         ("s-4" . ewm-frame-select)
                         ("s-5" . ewm-frame-select)
                         ("s-6" . ewm-frame-select)
                         ("s-7" . ewm-frame-select)
                         ("s-8" . ewm-frame-select)
                         ("s-9" . ewm-frame-select)))
