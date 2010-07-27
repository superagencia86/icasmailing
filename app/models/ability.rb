class Ability
  include CanCan::Ability
 
  def initialize(current_user)
    if current_user
      # Abilities for someone with an account (does not necessarily have a "user" role)
      can [:update, :destroy], Space do |user|
        user == current_user
      end
 
      # User role abilities
      if current_user.is_user?
        # nothing
      end
 
 
      # Admin role abilities
      if current_user.is_superadmin?
        can :manage, :all

        can :destroy, Space do |user|
          user.login != "superadmin"
        end
      end

      can :destroy, Comment do |comment|
        comment.user_id == current_user.id || current_user.is_superadmin?
      end

      can :manage, SubscriberList do |action, subscriber_list|
        (subscriber_list.space_id == current_user.space_id) || current_user.is_superadmin?
      end

      can :manage, Campaign do |action, campaign|
        campaign.space == current_user.space
      end

      can :manage, Space do |action, space|
        current_user.space == space || current_user.is_superadmin?
      end
    end
  end
end

