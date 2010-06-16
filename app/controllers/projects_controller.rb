class ProjectsController < InheritedResources::Base
  before_filter :require_user
  actions :all
  respond_to :html

  def search
    @projects = Project.search(params[:query])

    respond_to do |format|
      format.js   { 
        render :update do |page|
          if @projects.present?
            page["projects"].replace_html(:partial => 'project', :collection => @projects)
          else
            page["projects"].replace_html(:partial => 'common/empty_search')
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
      @projects ||= end_of_association_chain.paginate(paginate_options)
    end
end
