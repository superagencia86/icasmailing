class SendingsHaveListsAndDescription < ActiveRecord::Migration
  def self.up

    add_column :sendings, :description, :string, :limit => 256

    Sending.all.each do |sending|
      list = sending.subscriber_lists.first
      list ||= SubscriberList.first
      sending.update_attributes({:subscriber_list_id => list.id, :description => 'Envío'})
    end



  end

  def self.down
    remove_column :sendings, :description
  end
end
