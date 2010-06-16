namespace :mailing do
  desc "Create admin space"
  task :setup => :environment do
    name, surname, password, email, space_name = ENV["USERNAME"], ENV["SURNAME"], ENV["PASSWORD"], ENV["EMAIL"], ENV["COMPANY_NAME"]
    unless name && password && email && space_name
      puts "\nTo create the admin user you will be prompted to enter name, password,"
      puts "and email address. You might also specify the name of existing user.\n"
      loop do
        name ||= "admin"
        print "\nName [#{name}]: "
        reply = STDIN.gets.strip
        name = reply unless reply.blank?

        surname ||= "system"
        print "Surname [#{surname}]: "
        reply = STDIN.gets.strip
        surname = reply unless reply.blank?

        password ||= "admin"
        print "Password [#{password}]: "
        echo = lambda { |toggle| return if RUBY_PLATFORM =~ /mswin/; system(toggle ? "stty echo && echo" : "stty -echo") }
        begin
          echo.call(false)
          reply = STDIN.gets.strip
          password = reply unless reply.blank?
        ensure
          echo.call(true)
        end

        email ||= "admin@admin.com"
        print "Email [#{email}]: "
        reply = STDIN.gets.strip 
        email = reply if reply.present?

        loop do
          print "\nNombre del espacio: "
          space_name = STDIN.gets.strip
          break unless space_name.blank?
        end

        puts "\nThe admin user will be created with the following credentials:\n\n"
        puts "  Name: #{name}"
        puts "  Surname: #{surname}"
        puts "  Password: #{'*' * password.length}"
        puts "  Email: #{email}\n\n"
        puts "  Nombre del espacio: #{space_name}\n\n"
        loop do
          print "Continue [yes/no/exit]: "
          reply = STDIN.gets.strip
          break unless reply.blank?
        end
        break if reply =~ /y(?:es)*/i
        redo if reply =~ /no*/i
        puts "No admin user was created."
        exit
      end
    end
    space = Space.find_or_create_by_name(space_name)
    user = space.users.find_by_email(email) || space.users.build
    user.roles += ["superadmin", "admin"]
    user.attributes = {:name => name, :surname => surname, :password => password, :password_confirmation => password, :email => email}
    user.save!
    puts "Admin user has been created."
  end
end
