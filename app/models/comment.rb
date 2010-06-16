class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  named_scope :visible_for, Proc.new{|user| {:conditions => ["(private = 1 and user_id = ?) or private is false", user.id]}}
end
