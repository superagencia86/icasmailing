class SubscriberListsController < InheritedResources::Base
  before_filter :require_user, :authorized
  actions :index, :show, :new, :edit, :create, :update, :destroy
  respond_to :html

  def index
    @companies_subscriber_lists = SubscriberList.find(:all, :conditions => ["space_id != ?", current_space.id]).group_by{|sl| sl.space } if current_user.is_superadmin?
    index!
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
      if current_space.subscriber_lists.include?(shared_list.subscriber_list)
        flash[:notice] = "Has dejado de compartir #{shared_list}"
      end
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to subscriber_list_subscribers_path(@subscriber_list)}
    end
  end
  
  def update
    params[:subscriber_list][:sector_ids] ||= []
    params[:subscriber_list][:relationship_ids] ||= []
    params[:subscriber_list][:company_type_ids] ||= []
    update! do |success, failure|
      success.html { redirect_to subscriber_list_subscribers_path(@subscriber_list)}
    end
  end

  protected
    def authorized
      if params[:id]
        @subscriber_list = SubscriberList.find(params[:id])
        unauthorized! if cannot?(:manage, @subscriber_list)
      end
    end

    def begin_of_association_chain
      current_space
    end  
    
    def collection
      paginate_options ||= {}
      paginate_options[:page] ||= (params[:page] || 1)
      paginate_options[:per_page] ||= (params[:per_page] || 20)
      @subscriber_lists ||= end_of_association_chain.paginate(paginate_options)
    end
end
