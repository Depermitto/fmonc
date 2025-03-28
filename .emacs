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
	  auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory "auto-saves") t))
	  dired-dwim-target t)

(setq-default indent-tabs-mode 0
			  tab-width 4
			  indent-line-function 'insert-tab)

;; completions
(use-package savehist
  :init
  (savehist-mode)

  ;; popup completions UI
  (use-package corfu
	:ensure t
	:custom
	(corfu-cycle t)
	(corfu-preselect 'prompt)
	(tab-always-indent 'complete)

	:bind
	(:map corfu-map
		  ("TAB" . corfu-next)
		  ([tab] . corfu-next)
		  ("S-TAB" . corfu-previous)
		  ([backtab] . corfu-previous))

	:init
	(global-corfu-mode 1))

  ;; M-x completion UI
  (use-package vertico
	:ensure t
	:init
	(vertico-mode))

  ;; rich annotations (used in tandem with vertico)
  (use-package marginalia
	:ensure t
	:init
	(marginalia-mode))

  ;; completion styles
  (use-package orderless
	:ensure t
	:custom
	(completion-styles '(orderless basic))
	(completion-category-overrides '((file (styles basic partial-completion))))))

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
  :init
  (load-theme 'modus-vivendi))

;; font
(set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 170 :weight 'regular)

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
	:init
	(exec-path-from-shell-initialize)))

;; coding
(setq compilation-ask-about-save nil) ;; automatically save buffers before compiling
(global-auto-revert-mode 1) ;; automatically reload files from disk

(use-package elec-pair
  :init
  (setq electric-pair-preserve-balance nil
		electric-pair-delete-adjacent-pairs t)
  (electric-pair-mode 1))

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

(use-package eglot
  :ensure t
  :config
  ;; D
  (add-hook 'd-mode-hook 'eglot-ensure)
  (add-to-list 'eglot-server-programs `(d-mode . ("serve-d"))))

;; ansi-colors in compilation buffer
(use-package ansi-color
  :hook (compilation-filter . ansi-color-compilation-filter))

;; note taking and scientific papers
(use-package org
  :init
  (setq org-adapt-indentation t
		org-hide-leading-stars t
		org-hide-emphasis-markers t
		org-pretty-entities t

		org-src-fontify-natively t
		org-src-tab-acts-natively t
		org-edit-src-content-indentation 0)

  :hook ((org-mode . toggle-word-wrap)
		 (org-mode . toggle-truncate-lines)))
