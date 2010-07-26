require 'ostruct'

Sass::Plugin.options[:template_location] = File.join(RAILS_ROOT, "app/stylesheets")
Sass::Plugin.options[:css_location] = File.join(RAILS_ROOT, "public/stylesheets")

def os_array(values)
  array = []
  
  if values.is_a? Array
    values.each_with_index do |v, i|
      array << OpenStruct.new(:idx => i + 1, :name => v)
    end
  elsif values.is_a? Hash
    values.each do |key, value|
      array << OpenStruct.new(:idx => key, :name => value)
    end
  end

  array
end

COMPANY_STATE = os_array({
  :without_contact             =>  "Sin contactar", 
  :dont_pass_with_boss         => "No nos pasan con responsables", 
  :contact_via_phone_or_email  => "Contacto vía teléfono / mail",
  :meeting_done                => "Entrevista realizada",
  :interview                   => "Rechazado",
  :rejected                    => "No les interesan nuestros servicios",
  :no_money                    =>  "No tienen presupuesto",
  :services_already_contracted => "Servicios ya contratados",
  :do_internally               => "Lo hacen internamente",
  :dont_want_work_with_us      => "No quieren trabajar con nosotros",
  :contacted_but_not_converted => "Contactados pero no convertidos",
  :without_project             => "Cliente sin proyecto vigente",
  :with_projects               => "Con proyectos vigentes"
})

PROPOSAL_STATE = os_array({
  :pending  => "Pendiente de enviar",
  :sent     => "Enviada",
  :rejected => "Rechazada",
  :accepted => "Aceptada"
})

SEX = os_array(["Hombre", "Mujer"])


PROVINCES = os_array(
["A Coru\303\261a", "\303\201lava", "Albacete", "Alicante", "Almer\303\255a", "Asturias", 
"\303\201vila", "Badajoz", "Barcelona", "Burgos", "C\303\241ceres", "C\303\241diz", 
"Cantabria", "Castell\303\263n", "Ciudad Real", "C\303\263rdoba", "Cuenca", "Gerona", 
"Granada", "Guadalajara", "Guip\303\272zcoa", "Huelva", "Huesca", "Baleares", "Ja\303\251n", 
"Le\303\263n", "L\303\251rida", "Lugo", "Madrid", "M\303\241laga", "Murcia", "Navarra", 
"Ourense", "Palencia", "Las Palmas", "Pontevedra", "La Rioja", "Salamanca", "Santa Cruz de Tenerife", 
"Segovia", "Sevilla", "Soria", "Tarragona", "Teruel", "Toledo", "Valencia",
"Valladolid", "Vizcaya", "Zamora", "Zaragoza", "Ceuta", "Melilla"])



