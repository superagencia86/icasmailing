class ContactsController < InheritedResources::Base
  before_filter :require_user
  actions :all
  respond_to :html

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
