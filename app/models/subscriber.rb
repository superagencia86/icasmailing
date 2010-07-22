class Subscriber < ActiveRecord::Base
  belongs_to :subscriber_list
  belongs_to :contact
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
end
