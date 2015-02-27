module Avocado::Users
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
