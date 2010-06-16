# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(str)
    content_for(:title) { str }
  end

  def checkbox_for(action, object, value)
     check_box_tag "checked_at_#{object.id}", object.id, value, :onchange => "$.get('/ajax/', {'id': '#{object.id}', 'klass': '#{object.class.name}', 'check':'#{value}', 'to_action': '#{action}'}, null, 'script'); return false;"
  end

  def spacer(width = 10)
    image_tag "1x1.gif", :width => width, :height => 1, :alt => nil
  end  

  def active?(path)
    "active" if (path == :root && request.path == "/") || request.path =~ /^\/#{path}/
    # path.each{|p| return "active" if request.path =~ /^\/#{p}/ } if path.is_a? Array
  end
end
