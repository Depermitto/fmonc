(setq custom-file "~/.emacs.local/custom.el")
(load custom-file)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(global-display-line-numbers-mode 1)
(setq inhibit-startup-screen t
      backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

(setq-default indent-tabs-mode nil
              tab-width 4
              indent-line-function 'insert-tab)

;; ido
(use-package smex
  :ensure t
  :config
  (global-set-key (kbd "M-x") 'smex)
  (ido-mode 1)
  (ido-everywhere 1))

;; modal editing
(use-package meow
  :ensure t
  :config
  (load-file "~/.emacs.local/meow.el")
  (meow-setup)
  (meow-global-mode 1))

;; theme
(use-package modus-themes
  :ensure t
  :config
  (load-theme 'modus-vivendi))

;; font
(set-face-attribute 'default nil :family "Firacode Nerd Font" :height 160 :weight 'regular)

;; load maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; lazygit
(defun lazygit ()
  "Open lazygit in new kitty terminal window."
  (interactive)
  (start-process "kitty" nil "kitty" "--start-as" "maximized" "-e" "lazygit"))

(global-set-key (kbd "M-l") 'lazygit)

;; path
(when (eq system-type 'gnu/linux)
  (use-package exec-path-from-shell
    :ensure t
    :config
    (exec-path-from-shell-initialize)))

;; coding
(setq eglot-report-progress nil) ; eglot, please stop spamming
(global-unset-key (kbd "C-x C-p")) ; lessen friction with meow's god-mode

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  :config
  (global-corfu-mode 1))

(use-package go-mode
  :ensure t
  :mode "\\.go\\'")

(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'")
