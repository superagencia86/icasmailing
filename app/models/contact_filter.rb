# Un filtro permite encontrar una lista de contactos a partir de unas condiciones esas condiciones pueden venir de una lista inteligente: ContactFilter.new(list) o pueden venir del propio filtro :
# ConctactFilter.new


class ContactFilter
  def initialize(list)
    @data = list
    @contact_ids = nil
  end

  def length
    contact_ids(false).length
  end

  def confirmed_length
    contact_ids(true).length
  end

  def contacts
    Contact.find contact_ids(false)
  end

  def confirmed_contacts
    Contact.find contact_ids(true)
  end


  def contact_ids(confirmed = false)
    if !@contact_ids
      @contact_ids = []
      # General
      if @data.all_general
        scoped = Contact.for_space(@data.space_id).general
        scoped = scoped.confirmed if confirmed
        @contact_ids += scoped.find(:all, :select => :id).map(&:id)
      else
        if @data.hobbies.present?
          scoped = Contact.for_space(@data.space_id).general
          scoped = scoped.confirmed if confirmed
          @contact_ids += scoped.find(:all, :joins => :hobbies, :conditions => ["hobbies.id IN (#{@data.hobbies.map(&:id).join(', ')})"]).map(&:id)
        end
      end
      # Comunication
      scoped = Contact.for_space(@data.space_id).comunication
      scoped = scoped.confirmed if confirmed
      @contact_ids += scoped.map(&:id) if @data.all_comunication

      # Institutions
      institutions = @data.institution_types
      if @data.all_institutions
        scoped = Contact.for_space(@data.space_id).institution
        scoped = scoped.confirmed if confirmed
        @contact_ids += scoped.map(&:id)
      else
        if institutions.present?
          scoped = Contact.for_space(@data.space_id).institution
          scoped = scoped.confirmed if confirmed
          @contact_ids += scoped.find(:all, :conditions => ["institution_type_id IN (#{institutions.map(&:id).join(', ')})"], :select => 'id').map(&:id)
        end
      end
      # Artists
      scoped = Contact.for_space(@data.space_id).artist
      scoped = scoped.confirmed if confirmed
      @contact_ids += scoped.map(&:id) if @data.all_artists
    end
    @contact_ids
  end
end
