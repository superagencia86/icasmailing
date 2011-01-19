module DisplayHelper
  def field(label, model, attr)
    value = model.send(attr)
    "<label>#{label}: #{value}</label><br/>" if value.present?
  end
end