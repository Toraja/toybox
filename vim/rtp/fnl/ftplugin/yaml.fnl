(set vim.wo.foldlevel 2)
(set vim.wo.relativenumber true)

(let [surround (require :nvim-surround)
      surround-config (require :nvim-surround.config)]
  (surround.buffer_setup {:surrounds {:v {:add ["{{" "}}"]
                                          :find (fn []
                                                  (surround-config.get_selection {:motion "a{{"}))
                                          :delete "^(. ?)().-( ?.)()$"}}}))

(fn yaml-lint []
  (vim.cmd "lgetexpr system('yamllint --format parsable ' . expand('%'))")
  (if (not= (length (vim.fn.getloclist 0)) 0)
      (vim.cmd "Trouble loclist")
      (vim.cmd "TroubleClose")))

(local yaml_lint_augroud_id (vim.api.nvim_create_augroup :yaml_lint {}))
(vim.api.nvim_create_autocmd :BufWritePost
                             {:group yaml_lint_augroud_id
                              :pattern :*.yaml
                              :callback yaml-lint})

