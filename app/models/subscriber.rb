class Subscriber < ActiveRecord::Base
  belongs_to :subscriber_list, :counter_cache => true
  has_and_belongs_to_many :hobbies

  validates_presence_of :name, :surname, :email

  before_save :reset_subcriber_subtype_if

  def full_name
    "#{name} #{surname}"
  end

  protected
  def reset_subcriber_subtype_if
    self.subscriber_subtype_id = nil if self.subscriber_type_id != 2
  end
end
