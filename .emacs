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
(delete-selection-mode 1)
(which-key-mode 1)

(setq inhibit-startup-screen t ;; remove splash screen
	  backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
	  auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory "auto-saves") t)))

(setq-default indent-tabs-mode 0
			  tab-width 4
			  indent-line-function 'insert-tab
			  isearch-lazy-count t)

;; dired
(setq dired-dwim-target t ;; copy/move between dired panes
	  dired-listing-switches "-alh")
(global-set-key (kbd "C-c C-w") 'wdired-change-to-wdired-mode)

;; changing buffers
(global-set-key (kbd "C-.") 'other-window)

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

;; theme
(use-package modus-themes
  :ensure t
  :config
  (set-face-attribute 'default nil :family "0xProto Nerd Font" :height 150 :weight 'regular)
  (add-to-list 'default-frame-alist '(fullscreen . maximized)))

;; editing
(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package multiple-cursors
  :ensure t
  :bind
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-S-m" . mc/mark-all-like-this))

(use-package move-text
  :ensure t
  :bind
  ("M-n" . 'move-text-down)
  ("M-p" . 'move-text-up))

;; lazygit
(defun my/lazygit ()
  "Open lazygit in new kitty terminal window."
  (interactive)
  (if (project-current)
	  (let ((default-directory (project-root (project-current))))
		(start-process "kitty" nil "kitty" "--start-as" "maximized" "-e" "lazygit"))
	(message "No active project, cannot start lazygit")))

(global-set-key (kbd "C-x p l") 'my/lazygit)

;; PATH
(when (eq system-type 'gnu/linux)
  (use-package exec-path-from-shell
	:ensure t
	:init
	(exec-path-from-shell-initialize)))

;; coding
(setq compilation-ask-about-save nil) ;; automatically save buffers before compiling
(global-auto-revert-mode 1) ;; automatically reload files from disk

(use-package vterm
  :ensure t
  :init
  (setq vterm-shell (getenv "SHELL")))

(use-package elec-pair
  :init
  (setq electric-pair-preserve-balance nil
		electric-pair-delete-adjacent-pairs t)
  (electric-pair-mode 1))

;; ansi-colors in compilation buffer
(use-package ansi-color
  :hook (compilation-filter . ansi-color-compilation-filter))

;; note taking and scientific papers
(use-package org
  :init
  (setq org-adapt-indentation t
		org-hide-leading-stars t
		org-hide-emphasis-markers t

		org-src-fontify-natively t
		org-src-tab-acts-natively t
		org-edit-src-content-indentation 0)

  :hook ((org-mode . toggle-word-wrap)
		 (org-mode . toggle-truncate-lines)))

;; pdf viewing
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install-noverify)
  :hook (pdf-view-mode . (lambda () (display-line-numbers-mode 0))))
