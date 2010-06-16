class Campaign < ActiveRecord::Base
  include AASM

  belongs_to :space
  has_and_belongs_to_many :subscriber_lists
  has_many :campaign_recipients do
    def valids
      self.find(:all, :conditions => ["active is true and sent_email is false and visible is true"])
    end
  end
  has_many :subscriber_recipients, :through => :campaign_recipients, :source => :subscriber, 
    :conditions => "campaign_recipients.recipient_type = 'Subscriber' AND visible is true"
  has_many :company_recipients, :through => :campaign_recipients, :source => :company, 
    :conditions => "campaign_recipients.recipient_type = 'Company' AND visible is true"
  has_many :contact_recipients, :through => :campaign_recipients, :source => :contact, 
    :conditions => "campaign_recipients.recipient_type = 'Contact' AND visible is true"
    
  has_many :assets do
    def html
      find_by_data_type("html")
    end

    def images
      find_all_by_data_type("images")
    end
  end

  validates_presence_of :name, :subject, :from

  aasm_column :current_state
  aasm_initial_state :new

  aasm_state :new
  aasm_state :sending
  aasm_state :sent

  aasm_event :send_now do
    transitions :to => :sending, :from => [:new]
  end

  aasm_event :sended do
    transitions :to => :sent, :from => [:sent]
  end  

  def asset_html=(value)
    self.assets.html.destroy if self.assets.html

    tmp = Tempfile.new("temp.html")
    value.each do |line|
      tmp.puts Asset.sanitize_image(line)
    end
    tmp.close

    self.assets.build(:data => tmp.open, :data_type => "html")    
  end

  def asset_images=(value)
    tmp_dir = File.join(Rails.root, "tmp", self.id.to_s)

    self.assets.images.each do |image|; image.destroy; end
    FileUtils.rm_rf(tmp_dir)
    
    begin
      Asset.unzip_file(value.path, File.join(tmp_dir))
      Dir.glob(File.join("#{tmp_dir}", "**", "*.{png,gif,jpg}")).each do |file|
        self.assets.build(:data => File.open(file), :data_type => 'images')
      end
    rescue
      # Corregir
    end
  end


  def subscriber_list_ids_with_subscribing=(args)
    args.each do |subscriber_list_id|
      subscriber_list = SubscriberList.find(subscriber_list_id, :include => [:subscribers])
      create_campaign_recipients_for(subscriber_list.subscribers, subscriber_list_id)
      create_campaign_recipients_for(subscriber_list.companies, subscriber_list_id) if subscriber_list.companies.present?
    end

    deleted_lists = CampaignRecipient.find(:all, :select => 'subscriber_list_id', :group => 'subscriber_list_id').map(&:subscriber_list_id) - args
    deleted_lists.each do |subscriber_list_id|
      CampaignRecipient.update_all('visible = 0', "subscriber_list_id = #{subscriber_list_id}")
    end

    subscriber_list_ids_without_subscribing=(args)
  end

  alias_method_chain :subscriber_list_ids=, :subscribing

  protected

  def create_campaign_recipients_for(list, subscriber_list_id)
    list.each do |element|
      create_campaign_recipient(element, subscriber_list_id)
      
      if element.is_a? Company
        element.contacts.each do |contact|
          create_campaign_recipient(contact, subscriber_list_id)
        end
      end
    end
  end
  
  def create_campaign_recipient(element, subscriber_list_id)
    recipient = CampaignRecipient.find_or_create_by_campaign_id_and_subscriber_list_id_and_recipient_id_and_recipient_type(
      self.id, subscriber_list_id, element.id, element.class.to_s)
    recipient.update_attribute("visible", true) unless recipient.visible
  end
end
