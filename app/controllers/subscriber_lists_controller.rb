class SubscriberListsController < InheritedResources::Base
  before_filter :require_user, :authorized
  actions :index, :show, :new, :edit, :create, :update, :destroy
  respond_to :html

  def index
    @companies_subscriber_lists = SubscriberList.find(:all, :conditions => ["space_id != ?", current_space.id]).group_by{|sl| sl.space } if current_user.is_superadmin?
    index!
  end
  
  def show
    conditions = load_subscription_list_conditions

    # if listing contacts not added to the subscription list
    if params[:filter] && params[:filter][:active] == 'false'
      @contacts = Contact.find(:all, :select => 'DISTINCT(contacts.id), contacts.*', :conditions => [conditions, @subscriber_list.id], :joins => "LEFT JOIN subscribers on contacts.id = subscribers.contact_id LEFT JOIN contacts_hobbies on contacts.id = contacts_hobbies.contact_id LEFT JOIN hobbies on contacts_hobbies.hobby_id = hobbies.id").paginate(:per_page => SubscriberList::CONTACTS_PER_PAGE, :page => params[:page])
    else
      @contacts = @subscriber_list.active_contacts.find(:all, :select => 'DISTINCT(contacts.id), contacts.*', :joins => "LEFT JOIN contacts_hobbies on contacts.id = contacts_hobbies.contact_id LEFT JOIN hobbies on contacts_hobbies.hobby_id = hobbies.id", :conditions => conditions).paginate(:per_page => SubscriberList::CONTACTS_PER_PAGE, :page => params[:page])
    end
  end

  def share
    @shared_list = SharedList.new
    @subscriber_list = SubscriberList.find(params[:id])
    @spaces = Space.find(:all, :conditions => ["id != ?", @subscriber_list.space_id])

    flash[:error] = "No existen otros espacios" and redirect_to(subscriber_lists_path) if @spaces.length == 0

    unless request.get?
      @shared_list = SharedList.find_or_initialize_by_space_id_and_subscriber_list_id(params[:shared_list][:space_id], @subscriber_list.id)
      @shared_list.attributes = params[:shared_list]

      if @shared_list.save
        flash[:notice] = "Lista compartida"
        redirect_to subscriber_lists_path and return
      else
        flash[:error] = "Existen errores en el formulario"
        render :action => :share 
      end
    end
  end

  def unshare
    if params[:idx] && shared_list = SharedList.find(params[:idx])
      if current_space.subscriber_lists.include?(shared_list.subscriber_list) || current_user.is_superadmin?
        shared_list.destroy
        flash[:notice] = "Has dejado de compartir #{shared_list.subscriber_list.name}"
        redirect_to :back
      end
    end
  end

  # This method add all contacts of a type
  def add_all_to
    if params[:contact_type] && [1, 2, 3].include?(params[:contact_type].to_i)
      contacts = Contact.find_all_by_contact_type_id(params[:contact_type])
      for contact in contacts
        Subscriber.find_or_create_by_subscriber_list_id_and_contact_id(@subscriber_list.id, contact.id)
      end

      flash[:notice] = "Todos los #{Contact::SUBSCRIBER_TYPES.select{|x| x.idx == params[:contact_type].to_i}.first.name} han sido añadidos."
    end

    redirect_to :back
  end

  def create
    create! do |success, failure|
      @subscriber_list.update_attribute(:space_id, current_user.space_id)
      success.html { redirect_to edit_subscriber_list_path(@subscriber_list)}
    end
  end
  
  def update
    params[:subscriber_list][:hobby_ids] ||= []
    params[:subscriber_list][:institution_type_ids] ||= []

    
    update! do |success, failure|
      success.html { 
        @subscriber_list.update_assigned_contacts

        if params[:excel]
          user_added, user_no_added = Contact.import(params[:excel], current_user)
          @subscriber_list.contact_ids = @subscriber_list.contact_ids | user_added
          @subscriber_list.save!
        end

        redirect_to subscriber_list_path(@subscriber_list)
      }
    end
  end

  def generate_pdf
    @contacts = @subscriber_list.contacts
    tmp_dir = File.join(Rails.root, 'tmp')
    html = render_to_string :template => 'layouts/pdf.html.erb', :layout => false
    
    xhtml_file = File.join(tmp_dir, "#{@subscriber_list.name}.html")
    pdf_file = File.join(tmp_dir, "#{@subscriber_list.name}.pdf")
    
    File.open(xhtml_file, "w") do |file|
      file << html
    end
        
    xhtml2pdf(xhtml_file, pdf_file)
    
    send_file(pdf_file)
  end

  def generate_excel
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    sheet1.row(0).concat %w{Name Email}

    @subscriber_list.contacts.each_with_index do |contact, index|
      sheet1.row(index + 1).replace [contact.name, contact.email]
    end
    
    tmp_dir = File.join(Rails.root, 'tmp')
    book.write (excel_file = File.join(tmp_dir, "#{@subscriber_list.name}.xls"))
    send_file(excel_file)
  end

  protected
    def authorized
      if params[:id]
        @subscriber_list = SubscriberList.find(params[:id])
        unauthorized! if cannot?(:manage, @subscriber_list) && !current_space.shared_lists.find_by_id(@subscriber_list.id)
      end
    end

    def begin_of_association_chain
      current_space if !current_user.is_superadmin? 
    end  
    
    def collection
      paginate_options ||= {}
      paginate_options[:page] ||= (params[:page] || 1)
      paginate_options[:per_page] ||= (params[:per_page] || 20)
      @subscriber_lists ||= end_of_association_chain.paginate(paginate_options)
    end
end
