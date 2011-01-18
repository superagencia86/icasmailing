class AddConfirmedContacts < ActiveRecord::Migration
  def self.up

    cicas = Space.find_by_permalink('confirmados-icas')
    contacts = 0
    Contact.find_each do |contact|
      if contact.confirmed?
        puts "CONTACT: #{contact.email}"

        confirmed = cicas.contacts.find_by_email(contact.email)
        if !confirmed
          confirmed = contact.clone
          confirmed.space = cicas
          confirmed.user = cicas.users.first if !contact.user
          confirmed.save!
          puts "Añadido al espacio de confirmación"
        else
          puts "El contacto #{contact.email} ya está en el espacio de confirmación"
        end

        contact.subscriber_lists.each do |list|
          if (list.space != cicas)
            list_name = "Confirmados #{contact.space.name} - #{list.name}"
            puts "Añadiendo a la lista '#{list_name}'..."
            clist = cicas.subscriber_lists.find_or_create_by_name(list_name)
            subscriber = clist.subscribers.find_by_contact_id(confirmed.id)
            if !subscriber
              clist.subscriber_contacts << confirmed
              clist.save!
              puts "Añadido a la lista #{clist.name}"
            else
              puts "Ya está presente en #{clist.name}"
            end
          end
        end
        contacts += 1
      end
    end

    puts "Procesados #{contacts} contactos."
  end

  def self.down
    cicas = Space.find_by_permalink('confirmados-icas')
    cicas.contacts.destroy_all
    cicas.subscriber_list.destroy_all
  end
end
