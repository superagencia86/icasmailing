class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validates_uniqueness_of_email_field_options =  {:case_sensitive => false, :scope => :space_id, :if => "#{email_field}_changed?".to_sym}
  end
  
  belongs_to :space, :counter_cache => true
  has_many :projects
  has_many :contacts
  has_many :proposals
  has_many :comments, :dependent => :destroy

  validates_presence_of :name, :surname, :email

  # Constant variable storing roles in the system
  # FIXME DEPRECATED, admin not used
  ROLES_MASK = %w[superadmin admin user users_manager contacts_manager subscriber_lists_manager mailing_manager]
  easy_roles :roles_mask, :method => :bitmask

  # Ensure the user has the proper roles
  before_create :assign_user_roles
  validates_presence_of :space_id

  validates_each :roles do |record, attr, value|
    begin
      if record.roles_mask_changed? and not (record.new_record? and record.roles == ["user"]) and User.count > 0
        session = UserSession.find
        current_user = session.user unless session.nil?
 
        record.errors.add attr, ' can only be modified by an administrator.' if !current_user.is_admin? && !current_user.is_superadmin?
      end
    rescue Authlogic::Session::Activation::NotActivatedError
      # Do nothing, we are in a console session
    end
  end

  def full_name
    "#{name} #{surname}"
  end

 def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end 

  private
    def assign_user_roles
      self.roles += ["user"]
    end
end
