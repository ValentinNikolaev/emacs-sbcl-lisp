(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (tsdh-dark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; реализация common lisp
(require 'cl)
(setq-default inferior-lisp-program "sbcl")

;; Package manager:
;; Initialise package and add Melpa repository
;; First run install Slime, Smartparens, Auto Complete

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(defvar required-packages '(slime
                            smartparens
                            auto-complete))

(defun packages-installed-p ()
  (loop for package in required-packages
        unless (package-installed-p package)
          do (return nil)
        finally (return t)))

(unless (packages-installed-p)
  (package-refresh-contents)
  (dolist (package required-packages)
    (unless (package-installed-p package)
      (package-install package))))

;; Config packaged after first run
(when (packages-installed-p)
  (require 'smartparens-config)
  (smartparens-global-mode)

  (require 'auto-complete-config)
  (ac-config-default)
  (global-auto-complete-mode t)
  (setq-default ac-auto-start t)
  (setq-default ac-auto-show-menu t)
  (defvar *sources* (list
                     'lisp-mode
                     'ac-source-semantic
                     'ac-source-functions
                     'ac-source-variables
                     'ac-source-dictionary
                     'ac-source-words-in-all-buffer
                     'ac-source-files-in-current-dir))
  (let (source)
    (dolist (source *sources*)
      (add-to-list 'ac-sources source)))
  (add-to-list 'ac-modes 'lisp-mode)

  (require 'slime)
  (require 'slime-autoloads)
  (slime-setup '(slime-asdf
                 slime-fancy
                 slime-indentation))
  (setq-default slime-net-coding-system 'utf-8-unix))

;; Lisp indents
(setq-default lisp-body-indent 2)
(setq-default lisp-indent-function 'common-lisp-indent-function)

