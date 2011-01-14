# Un filtro permite encontrar una lista de contactos a partir de unas condiciones esas condiciones pueden venir de una lista inteligente: ContactFilter.new(list) o pueden venir del propio filtro :
# ConctactFilter.new


class ContactFilter
  def initialize(data = nil)
    @data = data || self
    @contact_ids = nil
  end

  def length
    contact_ids.length
  end

  def contacts
    Contact.find contact_ids
  end


  def contact_ids
    if !@contact_ids
      @contact_ids = []
      # General
      if @data.all_general
        @contact_ids += Contact.for_space(@data.space_id).general.find(:all, :select => :id).map(&:id)
      else
        if @data.hobbies.present?
          @contact_ids += Contact.for_space(@data.space_id).general.find(:all, :joins => :hobbies, :conditions => ["hobbies.id IN (#{@data.hobbies.map(&:id).join(', ')})"]).map(&:id)
        end
      end
      # Comunication
      @contact_ids += Contact.for_space(@data.space_id).comunication.map(&:id) if @data.all_comunication
      # Institutions
      institutions = @data.institution_types
      if @data.all_institutions
        @contact_ids += Contact.for_space(@data.space_id).institution.map(&:id)
      else
        if institutions.present?
          @contact_ids += Contact.for_space(@data.space_id).institution.find(:all, :conditions => ["institution_type_id IN (#{institutions.map(&:id).join(', ')})"], :select => 'id').map(&:id)
        end
      end
      # Artists
      @contact_ids += Contact.for_space(@data.space_id).artist.map(&:id) if @data.all_artists
    end
    @contact_ids
  end
end
