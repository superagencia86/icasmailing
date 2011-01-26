class ContactsController < InheritedResources::Base
  before_filter :require_user, :load_space
  actions :all
  respond_to :html

  def index
    @search_path = search_contacts_path
    @count = current_space.contacts.count
    index!
  end

  def new
    @contact = current_space.contacts.build(:confirmed => true)
    new!
  end

  def create
    params[:contact][:hobby_ids] ||= []
    params[:contact][:subscriber_list_ids] ||= []
    
    create!(:notice => 'Contacto registrado!') do
      @contact.confirm if @contact.confirmed?
      @contact
    end
  end
  
  def update
    params[:contact][:hobby_ids] ||= []
    params[:contact][:subscriber_list_ids] ||= []
    
    update!(:notice => 'El contacto ha sido actualizado') do
      @contact.confirmed? ? @contact.confirm : @contact.unconfirm
      @contact
    end
  end

  def search
    @contacts = Contact.finder(:space => current_space, :query => params[:query], :contact_type_id => params[:contact_type_id])
  end

  def add_to_list
    @subscriber_list = SubscriberList.find(params[:subscriber_list_id])
    # Prepare query
    conditions = load_subscription_list_conditions

    # Add to list
    if request.post?
      subscriber = Subscriber.find_or_create_by_subscriber_list_id_and_contact_id_and_excel(params[:subscriber_list_id], params[:id], true).update_attribute(:active, true)
    end

    # Load contacts
    @contacts = Contact.find(:all, :select => 'DISTINCT(contacts.id), contacts.*', :conditions => [conditions, @subscriber_list.id], :joins => "LEFT JOIN subscribers on contacts.id = subscribers.contact_id LEFT JOIN contacts_hobbies on contacts.id = contacts_hobbies.contact_id LEFT JOIN hobbies on contacts_hobbies.hobby_id = hobbies.id").paginate(:per_page => SubscriberList::CONTACTS_PER_PAGE, :page => params[:page])

    respond_to do |format|
      format.js{
        render :update do |page|
          page[:contacts].replace_html(:partial => "subscriber_lists/contacts_list", :locals => {:contacts => @contacts})
          page[:subscribers_count].replace_html(@subscriber_list.subscribers.count(:all, :conditions => {:active => true}))
        end 
      }
    end
  end

  # previous to destroy (just to confirm)
  def delete
    @contact = current_space.contacts.find params[:id]
    @lists = @contact.subscriber_lists
  end
  
  def destroy
    if params[:subscriber_list_id].present?
      @subscriber_list = SubscriberList.find(params[:subscriber_list_id])
      # Subscriber.find_by_subscriber_list_id_and_contact_id(params[:subscriber_list_id], params[:id]).try(:destroy)
      Subscriber.find_by_subscriber_list_id_and_contact_id(params[:subscriber_list_id], params[:id]).update_attribute(:active, false)
      respond_to do |format|
        format.js{
          @contacts = @subscriber_list.active_contacts.find(:all, :select => 'DISTINCT(contacts.id), contacts.*', :joins => "LEFT JOIN contacts_hobbies on contacts.id = contacts_hobbies.contact_id LEFT JOIN hobbies on contacts_hobbies.hobby_id = hobbies.id", :conditions => load_subscription_list_conditions).paginate(:per_page => SubscriberList::CONTACTS_PER_PAGE, :page => params[:page])
          render :update do |page|
            page[:contacts].replace_html(:partial => "subscriber_lists/contacts_list", :locals => {:contacts => @contacts})
            page[:subscribers_count].replace_html(@subscriber_list.subscribers.count(:all, :conditions => {:active => true}))
          end 
        }
        format.html{
          flash[:notice] = "Contacto eliminado de la lista de envío"
          redirect_to subscriber_list_path(params[:subscriber_list_id])
        }
      end
    else
      destroy!
    end
  end

  protected
    def authorized
      unauthorized! if cannot?(:manage, parent) 
    end

    def begin_of_association_chain
      # Company.find(params[:company_id]) if params[:company_id]
      current_space
    end  

    def collection
      paginate_options ||= {}
      paginate_options[:page] ||= (params[:page] || 1)
      paginate_options[:per_page] ||= (params[:per_page] || 20)
      @contacts ||= end_of_association_chain.for(current_user).paginate(paginate_options)
    end
end
