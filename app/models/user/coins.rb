class User
    module Coins
        extend ActiveSupport::Concern

        included do
            field :coins, type: Integer, default: 0
            api_property :coins
            index({coins: 1})
        end

        def credit_coins(amount)
            return nil if anonymous?
            if amount > 0
                inc(coins: amount)
                self
            elsif amount < 0
                where_self
                    .gte(coins: -amount)
                    .find_one_and_update({$inc => {coins: amount}},
                                         return_document: :after)
            else
                self
            end
        end

        def debit_coins(amount)
            credit_coins(-amount)
        end

        # Purchase the gizmo represented by the given Group for the given price,
        # returning the updated User document if the purchase was successful, or nil if
        # it failed. The purchase will fail if the user does not have enough coins
        # or if they already own the gizmo.
        def purchase_gizmo(group, price)
            # Assume memberships in the given group are always permanent, and so
            # if the user is not a member then it's safe to $push a new Membership.
            membership = Group::Membership.new(group: group,
                                               start: Time.now,
                                               stop: Time::INF_FUTURE)
            membership.validate!

            self.where_self
                .without_membership(group_id: group.id)
                .gte(coins: price)
                .find_one_and_update({$inc => {coins: -price}, $push => {memberships: membership.as_document}},
                                     return_document: :after)
        end
    end
end
