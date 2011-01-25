class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def boletin
    # Find or create a subscriber list for icas boletin,
    @sl = SubscriberList.find_or_create_by_name_and_space_id(:name => "ICAS Boletín", :space_id => (space_id = User.first.space.id), :user_id => User.first.id)
    @contact = Contact.new(params[:contact].merge({:space_id => space_id, :user_id => User.first.id}))
    # Create contact and assign to subscriber list
    @contact.subscriber_lists << @sl if @contact.save
    @contact.confirm
    url = params[:url_callback] || 'http://www.icas-sevilla.org/spip.php?article3651'
    redirect_to url
  end

end
