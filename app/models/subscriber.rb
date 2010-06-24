class Subscriber < ActiveRecord::Base
  belongs_to :subscriber_list
  belongs_to :contact
end
