class InstitutionTypesController < InheritedResources::Base
  before_filter :require_user
  actions :all
  respond_to :html

  def create
    create! do |success, failure|
      success.js {
        update_institution_type_via_ajax(@institution_type, params[:f])
      }

      failure.js {
        if params[:institution_type] && params[:institution_type][:name] && @institution_type = InstitutionType.find_by_name(params[:institution_type][:name])
          update_institution_type_via_ajax(@institution_type, params[:f])
        else
          render :nothing => true
        end
      }
    end
  end

  protected
    def authorized
      unauthorized! if cannot?(:manage, parent) 
    end

    def update_institution_type_via_ajax(institution_type, form)
      render :update do |page|
        page["institution_types"].replace_html(:partial => 'institution_types/institution_select', 
          :locals => {:f => form, :selected => institution_type.id})
        page["institution_type_div"].hide
      end
    end
end
