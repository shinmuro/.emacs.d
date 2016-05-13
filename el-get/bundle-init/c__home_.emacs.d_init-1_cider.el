(require 'cider-mode)
(setq nrepl-hide-special-buffers t cider-repl-tab-command 'indent-for-tab-command nrepl-buffer-name-show-port t cider-repl-display-in-current-window t)
(define-key cider-mode-map
  (kbd "C-.")
  'complete-symbol)
(define-key cider-mode-map
  (kbd "RET")
  'newline-and-indent)
(define-key cider-mode-map
  (kbd "C-c C-d")
  'ac-nrepl-popup-doc)
(add-hook 'cider-mode-hook 'eldoc-mode)
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(add-hook 'cider-mode-hook 'rainbow-delimiters-mode)
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)
(add-hook 'cider-repl-mode-hook 'cider-turn-on-eldoc-mode)
