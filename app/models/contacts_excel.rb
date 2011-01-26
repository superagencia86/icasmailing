
# Handle import/export to contacts thought excel
class ContactsExcel
  def self.import(excel, user)
    excel = Spreadsheet.open(excel)
    values = excel.worksheet 0
    user_added = []
    user_no_added = []
    errors = []
    hobbies = Hobby.all

    values.each_with_index do |row, index|
      next if index == 0
      contact, added = import_contact(index, row, {:hobbies => hobbies,
          :user => user, :errors => errors})


      if contact and added
        user_added << contact
      elsif contact
        user_no_added << contact
      end
    end

    [user_added, user_no_added, errors]
  end

  def self.import_contact(row_index, row, options = {})
    user = options[:user]
    space = user.space
    errors = options[:errors] || []
    if !row[0].nil?
      new_contact = {
        :user => user,
        :space => space,
        :email => get_row_data(row_index, row, 0, errors),
        :name => get_row_data(row_index, row, 1, errors),
        :surname => get_row_data(row_index, row, 2, errors),
        :entidad => get_row_data(row_index, row, 3, errors),
        :contact_type_id => Contact::SUBSCRIBER_TYPES.detect{|x| x.name == get_row_data(row_index, row, 4, errors)}.try(:idx),
        :institution_type_id => (InstitutionType.find_by_name(get_row_data(row_index, row, 5, errors)) if row[4].present?),
        :hobby_ids => set_hobbies(row[6], options[:hobbies]),
        :job => get_row_data(row_index, row, 7, errors),
        :sex_id => SEX.detect{|x| x.name == get_row_data(row_index, row, 8, errors)}.try(:idx),
        :web => get_row_data(row_index, row, 9, errors),
        :celular => get_row_data(row_index, row, 10, errors).try(:to_i),
        :telephone => get_row_data(row_index, row, 11, errors).try(:to_i),
        :birthday_at => get_row_data(row_index, row, 12, errors),
        :address => get_row_data(row_index, row, 13, errors),
        :province_id => PROVINCES.detect{|x| x.name == get_row_data(row_index, row, 14, errors)}.try(:idx),
        :locality => get_row_data(row_index, row, 15, errors),
        :zip => get_row_data(row_index, row, 16, errors).try(:to_i),
        :comments => get_row_data(row_index, row, 17, errors)
      }

      contact = Contact.new(new_contact)
      previous = space.contacts.find_by_email(contact[:email])
      if !previous
        [contact, true]
      else
        [previous, false]
      end
    end
  end

  def self.get_row_data(row_index, row, data_index, errors)
    begin
      return row[data_index]
    rescue 
      errors << "No se ha podido leer la columna #{data_index} de la fila #{row_index}"
      return nil
    end
  end

  def self.set_hobbies(hobbies_from_excel, hobbies_from_db)
    ids = []

    if hobbies_from_excel.present?
      hobbies_from_excel.split(",").each do |hobby|
        value = Hobby::FROM_EXCEL[hobby]
        ids << hobbies_from_db.detect{|x| x.name == value}.try(:id)
      end
    end

    ids
  end
end