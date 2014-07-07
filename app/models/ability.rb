class Ability
  include CanCan::Ability

  def initialize(user)
    if user.api
      can :manage, :all
    else
      can [:read, :create], :all
      can [:destroy, :update], Pick, vj: {user_id: user.id}
      can [:update], Vj, user_id: user.id
    end
  end
end
