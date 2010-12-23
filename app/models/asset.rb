require 'zip/zip'
class Asset < ActiveRecord::Base
  belongs_to :campaign

  Paperclip.interpolates :campaign_id do |attachment, style|
    attachment.instance.campaign.try(:id)
  end

  has_attached_file :data, 
    :path => ":rails_root/public/campaign/:campaign_id/images/:basename.:extension",
    :url => "/campaign/:campaign_id/images/:basename.:extension"

  def self.unzip_file(file, destination)
    if File.exist?(destination) then
      FileUtils.rm_rf destination
    end
    Zip::ZipFile.open(file) { |zip_file|
     zip_file.each { |f|
       f_path=File.join(destination, f.name)
       FileUtils.mkdir_p(File.dirname(f_path))
       zip_file.extract(f, f_path)
     }
    }
  end

  def self.sanitize_image(line)
    doc = Nokogiri::HTML(line)
    if (imgs = doc.search("img")).present?
      for img in imgs
        src = img.attributes["src"]
        line.gsub!(src.to_s, src.to_s.split("/").last)
      end
    end

    line
  end
end
