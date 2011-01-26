
class ListExportsController < ApplicationController
  def show
    @list = SubscriberList.find params[:subscriber_list_id]

    respond_to do |format|
      format.html { redirect_to @list }
      format.xml { render :xml => @list }
      format.csv { send_data @list.contacts.to_csv, :filename => "#{@list.name}.csv" }
      #format.pdf { send_file generate_pdf(@list) }
      format.xls { send_file generate_excel(@list)}
    end

  end

  protected

  def old_generate_pdf(list)
    @contacts = list.contacts
    tmp_dir = File.join(Rails.root, 'tmp')
    html = render_to_string :template => 'layouts/pdf.html.erb', :layout => false

    xhtml_file = File.join(tmp_dir, "#{list.name}.html")
    pdf_file = File.join(tmp_dir, "#{list.name}.pdf")

    File.open(xhtml_file, "w") do |file|
      file << html
    end

    xhtml2pdf(xhtml_file, pdf_file)
    pdf_file
  end

  def generate_excel(list)
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    sheet1.row(0).concat %w{Name Email}

    list.contacts.each_with_index do |contact, index|
      sheet1.row(index + 1).replace [contact.name, contact.email]
    end

    tmp_dir = File.join(Rails.root, 'tmp')
    excel_file = File.join(tmp_dir, "#{list.name}.xls")
    book.write(excel_file)
    excel_file
  end

end
