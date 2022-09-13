(set vim.wo.foldlevel 2)
(set vim.wo.relativenumber true)

(fn yaml-lint []
  (vim.cmd "lgetexpr system('yamllint --format parsable ' . expand('%'))")
  (if (not= (length (vim.fn.getloclist 0)) 0)
      (vim.cmd "Trouble loclist")
      (vim.cmd :TroubleClose)))

(vim.keymap.set :n :-l yaml-lint {:desc :Lint :silent true :buffer true})

;; Disable autocmd as some yaml files are not genuine yaml file.
;; (local yaml_lint_augroud_id (vim.api.nvim_create_augroup :yaml_lint {}))
;; (vim.api.nvim_create_autocmd :BufWritePost
;;                              {:group yaml_lint_augroud_id
;;                               :pattern :*.yaml
;;                               :callback yaml-lint})

