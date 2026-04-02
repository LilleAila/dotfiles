;; Various startup time optimizations

(setq gc-cons-threshold most-positive-fixnum)
(setq load-prefer-newer t)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(setq frame-inhibit-implied-resize t)
(setq package-enable-at-startup nil)

(when (boundp 'native-comp-deferred-compilation-deny-list)
  (setq native-comp-async-report-warnings-errors 'silent))

(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq blink-cursor-mode nil)
(setq-default cursor-in-non-selected-windows nil)

(setq use-dialog-box nil)
(setq use-file-dialog nil)

(setq-default line-spacing nil)

(setq site-run-file nil)
