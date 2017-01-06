{:en =>
     { :i18n =>
           { :plural =>
                 { :keys => [:zero,:one, :two, :three, :other],
                   :rule => lambda { |n|
                     case n
                       when n == 0
                         :zero
                       when n == 1
                         :one
                       when n == 2
                         :two
                       when n == 3
                         :three
                       else
                         :other
                     end
                   }
                 }
           }
     }
}