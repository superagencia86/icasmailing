
SharedList.all.each do |shared|
  space = shared.space
  original_list = shared.subscriber_list
  if original_list
    puts "CLONING LIST #{original_list.name} INTO SPACE #{space.name}"
    list = space.subscriber_lists.find_by_name(original_list.name)
    if !list
      list = original_list.clone
      list.auto_update = false
      list.space = space
      puts "LIST #{list.name} ADDED TO SPACE #{space.name}"
      list.save!
    end
    original_list.subscriber_contacts.each do |contact|
      puts "CLONING #{contact.email} INTO SPACE #{space.name}"
      already_present_contact = space.contacts.find_by_email(contact.email)
      if already_present_contact
        # puts "CONTACT #{contact.email} WAS PRESENT INTO SPACE #{space.name}"
      else
        cloned = contact.clone
        cloned.space = space
        if !cloned.user
          cloned.user = cloned.space.users.first
        end
        cloned.save!
        list.subscriber_contacts << cloned
        list.save!
        puts "CLONED #{contact.email} INTO TO #{list.name} IN SPACE #{space.name}"
      end
    end
  else
    puts "SPACE #{space.name} tiene una lista compartida huérfana"
    shared.destroy
  end
end