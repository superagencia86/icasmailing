class SubscribersController < InheritedResources::Base
  belongs_to :subscriber_list
  before_filter :require_user, :authorized
  actions :all
  respond_to :html

  def create
    create! do |sucess, failure|
      sucess.html { redirect_to subscriber_list_subscribers_path(@subscriber_list)}
    end
  end

  def update
    update! do |sucess, failure|
      sucess.html { redirect_to subscriber_list_subscribers_path(@subscriber_list)}
    end
  end

  def add_multiple
    unless request.get?
      @subscriber_list.process_subscribers(params[:subscribers])
      flash[:notice] = "Subscriptores añadidos"
      redirect_to subscriber_list_path(@subscriber_list)
    end
  end
  
  protected
    def authorized
      unauthorized! if cannot?(:manage, parent) 
    end

    def begin_of_association_chain
      @subscriber_list
    end  
    
    def collection
      paginate_options ||= {}
      paginate_options[:page] ||= (params[:page] || 1)
      paginate_options[:per_page] ||= (params[:per_page] || 20)
      @subscribers ||= end_of_association_chain.paginate(paginate_options)
    end
end
