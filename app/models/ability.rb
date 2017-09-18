class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Attachment]
    can %i[update destroy], [Question, Answer, Comment], user: user
    can :set_best, Answer, question: { user: user }
    can :destroy, Attachment, attachable: { user: user }
    can %i[vote_up vote_down vote_destroy], Votable do |v|
      v.user_id != user.id
    end
  end
end
