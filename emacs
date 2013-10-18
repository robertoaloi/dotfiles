;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Tabs should die
(setq-default indent-tabs-mode nil)

;; A tab corresponds to two spaces
(setq-default tab-width 2)

;; Show trailing whitespaces
(setq-default show-trailing-whitespace t)

;; Highlight long lines
(require 'whitespace)
(setq-default whitespace-style '(face trailing lines empty indentation::space))
(setq-default whitespace-line-column 80)
(global-whitespace-mode 1)
(whitespace-mode 1)

;; X11 Copy & Paste to/from Emacs:
(setq x-select-enable-clipboard t)

;; Menus and scrollbars are for the weak
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Show line numbers
(global-linum-mode 1)

;; Darkness will reign
(require 'color-theme)
(load-file "/home/robertoaloi/emacs-theme-tangotango.el")
(color-theme-initialize)
(color-theme-tangotango)

;; Highlight the current line in dark gray
(global-hl-line-mode t)
(set-face-background hl-line-face "gray13")

;; Save history between sessions
(savehist-mode 1)

;; Store Backup files in a common place
(setq backup-directory-alist `(("." . "~/.emacs-backups")))

;; Allow emacs to open file as root
;; C-x C-f /sudo::/path/to/file
(require 'tramp)

;; Show coloured diffs in Emacs
(defun update-diff-colors ()
  "update the colors for diff faces"
  (set-face-attribute 'diff-added nil
                      :background "#2e3436" :foreground "green")
  (set-face-attribute 'diff-removed nil
                      :background "#2e3436" :foreground "red"))
(eval-after-load "diff-mode"
  '(update-diff-colors))

;; ido mode decoration
(ido-mode 1)
(setq ido-decorations
      (quote
       ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
(add-hook 'ido-minibuffer-setup-hook
          #'(lambda() (set (make-local-variable 'truncate-lines) nil)))
(add-hook 'ido-minibuffer-setup-hook
          #'(lambda() (enlarge-window 10)))

;; Set Chrome as the default browser
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Erlang
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Use MELPA packaging system
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; erlang-mode, powered by MELPA
(require 'erlang-start)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(edts-face-error-line ((t (:background "firebrick4" :weight bold))))
 '(edts-face-error-mode-line ((t (:background "firebrick4" :foreground "white"))))
 '(edts-face-warning-line ((t (:background "DarkOrange4" :foreground "white" :weight bold))))
 '(edts-face-warning-mode-line ((t (:background "DarkOrange4" :foreground "white"))))
 '(erlang-font-lock-exported-function-name-face ((t (:inherit font-lock-function-name-face :foreground "#edd400"))))
 '(font-lock-function-name-face ((t (:foreground "tan3" :weight bold)))))

;; EDTS
(add-to-list 'load-path "~/Projects/edts/")
(require 'edts-start)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(edts-man-root "~/.emacs.d/edts/doc/R15B03")
 '(safe-local-variable-values (quote ((allout-layout . t)))))

;; Browse Erlang Doc (Original idea and code from @legoscia)
(defvar browse-erlang-doc-history nil)
(defvar erlang-doc-root-dir "~/docs/erlang/R15B03-1/")
(defun browse-erlang-doc (module)
  "Open documentation for erlang module MODULE in a web browser."
  (interactive
   (let* ((files
           (append
            (file-expand-wildcards
             (concat erlang-doc-root-dir
                     "lib/*/doc/html/*.html"))))
          (completion-table
           (mapcar
            (lambda (file)
              (cons (file-name-sans-extension
                     (file-name-nondirectory file))
                    file))
            files))
          (module-name (completing-read "Search: "
                                        completion-table
                                        nil t nil
                                        'browse-erlang-doc-history)))
     (list (cdr (assoc module-name completion-table)))))
  (browse-url-of-file module))
(local-set-key (kbd "C-e d") 'browse-erlang-doc)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Fix indentation for JS Mode
;; (setq js-indent-level 2)

;; ;; Validate JSON files on the fly
;; ;; Requires jslint. Install it via `npm -g install jslint`
;; ;; Source: http://www.emacswiki.org/emacs/FlymakeJavaScript
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode))
;; (add-to-list 'auto-mode-alist '("\\.json\\'" . js-mode))
;; (when (load "flymake" t)
;;   (defun flymake-jslint-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list "jslint" (list "--terse" local-file))))

;;   (setq flymake-err-line-patterns
;;         (cons '("^\\(.*\\)(\\([[:digit:]]+\\)):\\(.*\\)$"
;;                 1 2 nil 3)
;;               flymake-err-line-patterns))

;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.json\\'" flymake-jslint-init))
;;   )

;; (add-hook 'js-mode-hook
;;           (lambda () (flymake-mode t)))
;; (put 'erase-buffer 'disabled nil)
