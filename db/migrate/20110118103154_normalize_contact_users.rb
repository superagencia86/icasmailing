class NormalizeContactUsers < ActiveRecord::Migration
  def self.up
    uids = User.all.map{|u| u.id}
    orphans = Contact.find(:all, :conditions => ["user_id NOT IN (?)", uids])
    orphans.each do |contact|
      contact.user = contact.space.users.first
      contact.save
    end
  end

  def self.down
  end
end
