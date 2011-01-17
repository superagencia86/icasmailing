module DisplayHelper
  def field(label, model, attr)
    value = model.send(attr)
    "#{label}: #{value}<br/>" #if value.present?
  end
end