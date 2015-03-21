module Avocado::Users
  def users_hash
    @users_hash ||= {
      me['id'] => me['firstName'],
      you['id'] => you['firstName'],
    }
  end

  def me
    users.first
  end

  def you
    users.last
  end

  def users
    @users ||= api.users
  end
end
