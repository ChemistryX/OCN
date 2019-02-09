module Api
    class DeathsController < ModelController
        controller_for Death

        def after_update(death)
            if death.coins && death.coins != 0 and user = death.killer_obj
                user.credit_coins(death.coins)
            end
        end
    end
end
