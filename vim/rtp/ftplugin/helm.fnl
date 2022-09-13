(let [surround (require :nvim-surround)
      surround-config (require :nvim-surround.config)]
  (surround.buffer_setup {:surrounds {:v {:add ["{{ $" " }}"]
                                          :find (fn []
                                                  (surround-config.get_selection {:motion "a{{ $"}))
                                          :delete "^(. ?)().-( ?.)()$"}
                                      :V {:add ["{{ " " }}"]
                                          :find (fn []
                                                  (surround-config.get_selection {:motion "a{{"}))
                                          :delete "^(. ?)().-( ?.)()$"}}}))

