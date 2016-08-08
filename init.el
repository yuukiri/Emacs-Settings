;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

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

(require 'jedi)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
;(load-theme 'labburn t) ;; load labburn theme
(global-linum-mode t) ;; enable line numbers globally

(set-frame-parameter (selected-frame) 'alpha '(85 . 50))
(add-to-list 'default-frame-alist '(alpha . (85 . 50)))

;;; Nice size for the default window
(defun get-default-height ()
       (/ (- (display-pixel-height) 120)
          (frame-char-height)))

(add-to-list 'default-frame-alist '(width . 180))
(add-to-list 'default-frame-alist '(height . 120))

(set-face-attribute 'default nil :family "Anonymous Pro" :height 140 )

(elpy-enable)

(require 'virtualenvwrapper)
(venv-initialize-interactive-shells) ;; if you want interactive shell support
(setq venv-location "/usr/local/bin/virtualenv")

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)                 ; optional

(eval-after-load "python"
  '(define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer))
(add-hook 'jedi-mode-hook 'jedi-direx:setup)



;; init.el ends here
