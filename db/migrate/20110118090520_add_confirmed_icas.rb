class AddConfirmedIcas < ActiveRecord::Migration
  def self.up
    cicas = Space.find_by_permalink('confirmados-icas')
    if !cicas
      puts "CREATE CICAS SPACE.."
      cicas = Space.create!(:name => 'Confirmados ICAS')
      puts "DONE."
    end
    if cicas.users.count == 0
      puts "CREATE CICAS ADMIN.."
      cicas.users.create!(:email => 'cadmin@cadmin.com', :name => 'cadmin',
        :surname => 'cadmin',
        :password => 'cadmin', :password_confirmation => 'cadmin')
      puts "DONE."
    end
  end

  def self.down
    cicas = Space.find_by_permalink('confirmados-icas')
    cicas.users.destroy_all
    cicas.destroy
  end
end
