class NormalizeAutoUpdateInLists < ActiveRecord::Migration
  def self.up
    SubscriberList.find(:all, :conditions => {:auto_update => nil}).each do |sl|
      sl.update_attribute(:auto_update, false)
    end
  end

  def self.down
  end
end
