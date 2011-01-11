# == Schema Information
# Schema version: 20101214111833
#
# Table name: sectors
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

class Sector < ActiveRecord::Base
  default_scope :order => 'name ASC'
end
