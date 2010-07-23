require 'xhtml2pdf'
class DashboardController < ApplicationController
  before_filter :require_user

  def index
    @activities = Activity.find(:all, :include => [:user], :order => 'created_at desc', 
      :conditions => ["user_id IN (#{current_space.user_ids.join(', ')})"], :limit => 20)
  end
  
  def generate_pdf
    @texto = "Un texto de prueba"
    tmp_dir = File.join(Rails.root, 'tmp')
    html = render_to_string :template => 'layouts/pdf.html.erb', :layout => false
    
    xhtml_file = File.join(tmp_dir, "un_pdf_tmp.html")
    pdf_file = File.join(tmp_dir, "un_pdf_tmp.pdf")
    
    File.open(xhtml_file, "w") do |file|
      file << html
    end
        
    xhtml2pdf(xhtml_file, pdf_file)
    
    send_file(pdf_file)
  end
end
