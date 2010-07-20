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
["A Coru\303\261a\n", "\303\201lava\n", "Albacete\n", "Alicante\n", "Almer\303\255a\n", "Asturias\n", 
"\303\201vila\n", "Badajoz\n", "Barcelona\n", "Burgos\n", "C\303\241ceres\n", "C\303\241diz\n", 
"Cantabria\n", "Castell\303\263n\n", "Ciudad Real\n", "C\303\263rdoba\n", "Cuenca\n", "Gerona\n", 
"Granada\n", "Guadalajara\n", "Guip\303\272zcoa\n", "Huelva\n", "Huesca\n", "Baleares\n", "Ja\303\251n\n", 
"Le\303\263n\n", "L\303\251rida\n", "Lugo\n", "Madrid\n", "M\303\241laga\n", "Murcia\n", "Navarra\n", 
"Ourense\n", "Palencia\n", "Las Palmas\n", "Pontevedra\n", "La Rioja\n", "Salamanca\n", "Santa Cruz de Tenerife\n", 
"Segovia\n", "Sevilla\n", "Soria\n", "Tarragona\n", "Teruel\n", "Toledo\n", "Valencia\n",
"Valladolid\n", "Vizcaya\n", "Zamora\n", "Zaragoza\n", "Ceuta\n", "Melilla\n"])



