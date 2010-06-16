class CompaniesController < InheritedResources::Base
  before_filter :require_user
  actions :all
  respond_to :html

  def create
    create! do |success, failure|
      success.js {
        update_company_via_ajax(@company, params[:f])
      }

      failure.js {
        if params[:company] && params[:company][:name] && @company = Company.find_by_name(params[:company][:name])
          update_company_via_ajax(@company, params[:f])
        else
          render :nothing => true
        end
      }
    end
  end


  def edit
    @company = Company.find(params[:id], :include => [:sectors, :relationships, :company_types])
    edit!
  end

  def update
    params[:company][:sector_ids] ||= []
    params[:company][:relationship_ids] ||= []
    params[:company][:company_type_ids] ||= []
    update!
  end

  def search
    @companies = Company.search(params[:query])

    respond_to do |format|
      format.js   { 
        render :update do |page|
          if @companies.present?
            page["companies"].replace_html(:partial => 'company', :collection => @companies)
          else
            page["companies"].replace_html(:partial => 'common/empty_search')
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
      current_space
    end  
    
    def collection
      paginate_options ||= {}
      paginate_options[:page] ||= (params[:page] || 1)
      paginate_options[:per_page] ||= (params[:per_page] || 20)
      @companies ||= end_of_association_chain.paginate(paginate_options)
    end

    def update_company_via_ajax(company, form)
      render :update do |page|
        page["company"].replace_html(:partial => 'companies/company_select', 
          :locals => {:f => form, :selected => company.id})
        page["company_div"].hide
      end
    end
end
