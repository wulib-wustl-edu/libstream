class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  def ldap_before_save
    self.email = Devise::LDAP::Adapter.get_ldap_param(self.username,"mail").first
    self.first_name = Devise::LDAP::Adapter.get_ldap_param(self.username,"givenname").join('')
    self.last_name = Devise::LDAP::Adapter.get_ldap_param(self.username,"sn").join('')
    self.group = get_group()
  end

  def get_group
    user_group = Devise::LDAP::Adapter.get_ldap_param(self.username,"memberOf").join('')
    if user_group.include?("sradmin") && user_group.include?("mradmin")
      group = 'superadmin'
    elsif user_group.include?("sradmin")
      group = 'sradmin'
    elsif user_group.include?("mradmin")
      group = 'mradmin'
    end
    return group
  end

end
