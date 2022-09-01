;; Object like
(local hello {})

(fn hello.to [to]
   (print (.. "hello " to)))

(fn hello.world []
   (print (.. "hello " "world")))

;; Table lookup
(fn shiftwidth []
   (print (.. "shiftwidth: " (. vim.o :shiftwidth))))

(fn not-yet-implemented []
   (print "not yet implemented"))

(vim.keymap.set "n" "-" not-yet-implemented { :desc "dummy" })

;; This can be called either:
;; lua: require('ftplugin.fennel')["not-yet-implemented"]()
;; fennel: (let [fnl (require :ftplugin.fennel)] (fnl.not-yet-implemented))
{: not-yet-implemented
 : hello
 : shiftwidth}
