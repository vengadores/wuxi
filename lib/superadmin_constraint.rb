class SuperadminConstraint
  def matches?(request)
    return false unless request.session[:"warden.user.user.key"]
    users = ::Admin::User.find(request.session[:"warden.user.user.key"].first)
    users.first && users.first.role.superadmin?
  end
end
