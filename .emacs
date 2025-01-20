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

(setq inhibit-startup-screen t ;; remove splash screen
      backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
      auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory "auto-saves") t)))

(setq-default indent-tabs-mode nil
              tab-width 4
              indent-line-function 'insert-tab)

;; completions
(use-package savehist
  :init
  (savehist-mode)

  (use-package vertico
    :ensure t
    :config
    (vertico-mode))

  ;; rich annotations
  (use-package marginalia
    :ensure t
    :config
    (marginalia-mode)))

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
(set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 160 :weight 'regular)

;; load maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; lazygit
(defun lazygit ()
  "Open lazygit in new kitty terminal window."
  (interactive)
  (if (project-current)
      (let ((default-directory (project-root (project-current))))
        (start-process "kitty" nil "kitty" "--start-as" "maximized" "-e" "lazygit"))
    (message "No active project, cannot start lazygit")))

(global-set-key (kbd "M-l") 'lazygit)

;; path
(when (eq system-type 'gnu/linux)
  (use-package exec-path-from-shell
    :ensure t
    :config
    (exec-path-from-shell-initialize)))

;; popup completions
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  :config
  (add-hook 'corfu-mode-hook (lambda()
                               (setq-local completion-styles '(basic)
                                           completion-category-overrides nil
                                           completion-category-defaults nil)))
  (global-corfu-mode 1))

;; coding
(setq compilation-ask-about-save nil) ;; automatically save buffers before compiling
(global-auto-revert-mode 1) ;; automatically reload files from disk
(electric-pair-mode 1)

;; finding diagnostics
(add-hook 'flymake-mode-hook (lambda()
                               (define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
                               (define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)))

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install t)
  :config
  (global-treesit-auto-mode))

(use-package go-mode
  :ensure t
  :after treesit-auto
  :config
  (setq go-ts-mode-indent-offset tab-width))

;; ansi-colors in compilation buffer
(use-package ansi-color
  :hook (compilation-filter . ansi-color-compilation-filter))
