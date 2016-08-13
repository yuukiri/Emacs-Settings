;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)

(package-initialize)
;(when (not package-archive-contents)
;  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    elpy ;; add the elpy package
    labburn-theme))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)


;; C++ related setups ;;

(require 'yasnippet)
(yas-global-mode 1)

(require 'highlight-symbol)
;;(global-set-key [(control f3)] 'highlight-symbol-at-point)
(global-set-key (kbd "C-c h") 'highlight-symbol-at-point)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)
(global-set-key [(control shift f3)] 'unhighlight-regexp)
(global-set-key [(control shift mouse-1)]
                (lambda (event)
                  (interactive "e")
                  (save-excursion
                    (goto-char (posn-point (event-start event)))
                    (highlight-symbol-at-point))))
;; pick either auto-complete or company

;(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-20160710.1544/")
;(require 'auto-complete-config)
;(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete-20160710.1544/dict")

;(require 'auto-complete-clang)
;(setq ac-quick-help-delay 0.5)
;(define-key ac-mode-map  [(control tab)] 'auto-complete)
;(defun my-ac-config ()
;  (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
;  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
;  ;; (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
;  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
;  (add-hook 'css-mode-hook 'ac-css-mode-setup)
;  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
;  (global-auto-complete-mode t))
;(defun my-ac-cc-mode-setup ()
;  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
;(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
;;; ac-source-gtags
;(my-ac-config)

;; company-mode
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

(setq company-backends (delete 'company-semantic company-backends))
(require 'cc-mode)
(define-key c-mode-map  [(tab)] 'company-complete)
(define-key c++-mode-map  [(tab)] 'company-complete)

(add-to-list 'company-backends 'company-c-headers)
(require 'company-c-headers)
(add-to-list 'company-c-headers-path-system "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include/")
(company-mode)


;; Package: smartparens
(require 'smartparens-config)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

;; when you press RET, the curly braces automatically
;; add another newline
(sp-with-modes '(c-mode c++-mode)
  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair "/*" "*/" :post-handlers '((" | " "SPC")
                                            ("* ||\n[i]" "RET"))))

;; Available C style:
;; “gnu”: The default style for GNU projects
;; “k&r”: What Kernighan and Ritchie, the authors of C used in their book
;; “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
;; “whitesmith”: Popularized by the examples that came with Whitesmiths C, an early commercial C compiler.
;; “stroustrup”: What Stroustrup, the author of C++ used in his book
;; “ellemtel”: Popular C++ coding standards as defined by “Programming in C++, Rules and Recommendations,” Erik Nyquist and Mats Henricson, Ellemtel
;; “linux”: What the Linux developers use for kernel development
;; “python”: What Python developers use for extension modules
;; “java”: The default style for java-mode (see below)
;; “user”: When you want to define your own style
(setq
 c-default-style "stroustrup" ;; set style to "linux"
 )

(add-hook 'c-mode-common-hook   'hs-minor-mode)


(require 'compile)
 (add-hook 'c-mode-hook
           (lambda ()
         (unless (file-exists-p "Makefile")
           (set (make-local-variable 'compile-command)
                    ;; emulate make's .c.o implicit pattern rule, but with
                    ;; different defaults for the CC, CPPFLAGS, and CFLAGS
                    ;; variables:
                    ;; $(CC) -c -o $@ $(CPPFLAGS) $(CFLAGS) $<
            (let ((file (file-name-nondirectory buffer-file-name)))
                      (format "%s -c -o %s.o %s %s %s"
                              (or (getenv "CC") "gcc")
                              (file-name-sans-extension file)
                              (or (getenv "CPPFLAGS") "-DDEBUG=9")
                              (or (getenv "CFLAGS") "-ansi -pedantic -Wall -g")
                  file))))))


;; Python setup

(require 'jedi)

(elpy-enable)

(require 'virtualenvwrapper)
(venv-initialize-interactive-shells) ;; if you want interactive shell support
(setq venv-location "/usr/local/bin/virtualenv")

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)                 ; optional

(eval-after-load "python"
  '(define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer))
(add-hook 'jedi-mode-hook 'jedi-direx:setup)

(require 'whitespace)
(setq whitespace-line-column 120) ;; limit line length
(setq whitespace-style '(face lines-tail))

(add-hook 'prog-mode-hook 'whitespace-mode)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
;(load-theme 'labburn t) ;; load labburn theme
(global-linum-mode t) ;; enable line numbers globally
(setq column-number-mode t)

(set-frame-parameter (selected-frame) 'alpha '(85 . 50))
(add-to-list 'default-frame-alist '(alpha . (85 . 50)))


(global-set-key (kbd "RET") 'newline-and-indent)  ; automatically indent when press RET

;;; Nice size for the default window
(defun get-default-height ()
       (/ (- (display-pixel-height) 120)
          (frame-char-height)))

(add-to-list 'default-frame-alist '(width . 150))
(add-to-list 'default-frame-alist '(height . 80))

(set-face-attribute 'default nil :family "Anonymous Pro" :height 140 )

;; init.el ends here


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

