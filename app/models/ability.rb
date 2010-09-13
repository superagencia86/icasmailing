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

      if current_user.is_users_manager?
        can :manage, User
      end

      if current_user.is_contacts_manager?
        can :manage, Contact
      end

      # if current_user.is_subscriber_lists_manager?
      #   can :manage, SubscriberList
      # end
 
 
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

      # Puede gestionarlo si es admin o un gestor de listas de este espacio
      can :manage, SubscriberList do |action, subscriber_list|
        (current_user.is_subscriber_lists_manager? && (subscriber_list.space_id == current_user.space_id)) || current_user.is_superadmin?
      end

      # Puede visualizarlo si es admin o es un user de este espacio
      can :read, SubscriberList do |subscriber_list|
        (subscriber_list.space_id == current_user.space_id) || current_user.is_superadmin?
      end

      can :manage, Campaign do |action, campaign|
        campaign.space == current_user.space
      end

      # Puede leer los comentarios de las listas de envío si
      # no son privados o son privados pero soy del mismo espacio
      can :read, Comment do |comment|
        comment.private == false || comment.commentable.space_id == current_user.space_id
      end

      can :manage, Space do |action, space|
        current_user.space == space || current_user.is_superadmin?
      end
    end
  end
end

