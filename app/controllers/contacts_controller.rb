class ContactsController < InheritedResources::Base
  before_filter :require_user
  actions :all
  respond_to :html

  def create
    params[:contact][:hobby_ids] ||= []
    params[:contact][:subscriber_list_ids] ||= []
    
    create!
  end
  
  def update
    params[:contact][:hobby_ids] ||= []
    params[:contact][:subscriber_list_ids] ||= []
    
    update!
  end

  def search
    @contacts = Contact.search(params[:query])

    respond_to do |format|
      format.js   { 
        render :update do |page|
          if @contacts.present?
            page["contacts"].replace_html(:partial => 'contact', :collection => @contacts)
          else
            page["contacts"].replace_html(:partial => 'common/empty_search')
          end
          page["paginate"].hide
        end
      }
    end
  end

  def add_by_type_to
    @subscriber_list = SubscriberList.find(params[:subscriber_list_id])

    if request.get?
      if params[:contact_type] && [1, 2, 3, 4].include?(params[:contact_type].to_i)
        @contacts = Contact.find_all_by_contact_type_id(params[:contact_type])
      end
    else
      params[:subscriber_list] ||= {}
      params[:subscriber_list][:contact_ids] ||= []

      if @subscriber_list.update_attributes(params[:subscriber_list])
        flash[:notice] = "Lista de envío actualizada"
      end
      
      redirect_to subscriber_list_path(@subscriber_list)
    end
  end
  
  def destroy
    if params[:subscriber_list_id].present?
      @subscriber_list = SubscriberList.find(params[:subscriber_list_id])
      # Subscriber.find_by_subscriber_list_id_and_contact_id(params[:subscriber_list_id], params[:id]).try(:destroy)
      Subscriber.find_by_subscriber_list_id_and_contact_id(params[:subscriber_list_id], params[:id]).update_attribute(:active, false)
      respond_to do |format|
        format.js{
          @contacts = @subscriber_list.active_contacts.find(:all, :include => :hobbies, :conditions => load_subscription_list_conditions).paginate(:per_page => SubscriberList::CONTACTS_PER_PAGE, :page => params[:page])
          render :update do |page|
            page[:contacts].replace_html(:partial => "subscriber_lists/contacts_list", :locals => {:contacts => @contacts})
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
      Company.find(params[:company_id]) if params[:company_id]
    end  

    def collection
      paginate_options ||= {}
      paginate_options[:page] ||= (params[:page] || 1)
      paginate_options[:per_page] ||= (params[:per_page] || 20)
      @contacts ||= end_of_association_chain.for(current_user).paginate(paginate_options)
    end
end
