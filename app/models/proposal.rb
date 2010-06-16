class Proposal < ActiveRecord::Base
  acts_as_paranoid
  record_activity_of :user

  belongs_to :user
  belongs_to :company
  has_many :comments, :as => :commentable

  validates_presence_of :name, :company_id

  simple_column_search :name, :match => :middle, :escape => lambda { |query| query.gsub(/[^\w\s\-\.']/, "").strip }

  def human_state
    if state.blank?
      "Sin estado"
    else
      PROPOSAL_STATE.select{|x| x.idx == state.to_sym}.first.name
    end
  end
end
