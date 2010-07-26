class SharedList < ActiveRecord::Base
  belongs_to :space
  belongs_to :subscriber_list

  validates_presence_of :space_id#, :expires_at

  # def validate
  #   errors.add(:expires_at, "La fecha debe ser mayor o igual al día de hoy") if self.expires_at < Date.today
  # end
end
