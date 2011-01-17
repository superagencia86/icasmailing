
zombies = 0
Contact.find_each do |contact|
  if contact.subscriber_lists.count == 0 and contact.confirmed? == false
    puts "#{contact.id} - #{contact.name} está en tierra de nadie"
    zombies += 1
  end
end
puts "ZOMBIES #{zombies}"
