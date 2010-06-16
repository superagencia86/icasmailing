class ProposalsController < InheritedResources::Base
  before_filter :require_user
  actions :all
  respond_to :html

  def search
    @proposals = Proposal.search(params[:query])

    respond_to do |format|
      format.js   { 
        render :update do |page|
          if @proposals.present?
            page["proposals"].replace_html(:partial => 'proposal', :collection => @proposals)
          else
            page["proposals"].replace_html(:partial => 'common/empty_search')
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

    def collection
      paginate_options ||= {}
      paginate_options[:page] ||= (params[:page] || 1)
      paginate_options[:per_page] ||= (params[:per_page] || 20)
      @proposals ||= end_of_association_chain.paginate(paginate_options)
    end
end
