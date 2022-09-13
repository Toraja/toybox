(set vim.bo.tabstop 2)
(set vim.bo.shiftwidth 2)

(fn fennel-format []
  (let [cursor-position (vim.fn.getpos ".")]
    (let [current-line (. cursor-position 2)
          current-column (. cursor-position 3)]
      (vim.cmd "silent %!fnlfmt %")
      (vim.fn.cursor current-line current-column))))

(vim.keymap.set :n :-r "<Cmd>vertical split term://fennel % | startinsert<CR>"
                {:desc :Run :buffer true})
(vim.keymap.set :n :-f fennel-format {:desc :Format :buffer true})

;; Looks like fnlfmt does not support stdin
;; Enable autocmd when supported (and remove trailing `%`)
;; (local fennel_format_augroud_id (vim.api.nvim_create_augroup :fennel_format {}))
;; (vim.api.nvim_create_autocmd :BufWritePre
;;                              {:group fennel_format_augroud_id
;;                               :pattern :*.fnl
;;                               :callback fennel-format})

;; The below is demo
;; Object like
(local hello {})

(fn hello.to [to]
  (print (.. "hello " to)))

(fn hello.world []
  (print (.. "hello " :world)))

;; Table lookup
(fn shiftwidth []
  (print (.. "shiftwidth: " (. vim.o :shiftwidth))))

(fn not-yet-implemented []
  (print "not yet implemented"))

;; This can be called either:
;; lua: require('ftplugin.fennel')["not-yet-implemented"]()
;; fennel: (let [fnl (require :ftplugin.fennel)] (fnl.not-yet-implemented))

{: not-yet-implemented : hello : shiftwidth}

