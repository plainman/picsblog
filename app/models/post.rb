class Post < ActiveRecord::Base

  has_many(:comments, :order => 'created_at DESC', :dependent => :destroy)
  validates_presence_of(:title, :description, :date, :image, :thumbnail)
  
  def image_file= (fileobj)
    if fileobj.size > 0
      @image_file = fileobj
      self.image = unique_and_proper_filename(fileobj.original_filename)
    end
  end

  def thumbnail_file= (fileobj)
    if fileobj.size > 0
      @thumbnail_file = fileobj
      self.thumbnail = unique_and_proper_filename(fileobj.original_filename)
    end
  end

  def save_files
    # Bilddatei speichern
    if !save_uploaded_file(@image_file, IMAGE_DIR, self.image)
      return false
    end
    #Thumbnail speichern
    if !save_uploaded_file(@thumbnail_file, THUMBNAIL_DIR, self.thumbnail)
      return false
    end
    return true
  end
  
  private
  def unique_and_proper_filename(filename)
    Time.now.to_i.to_s + '_' + File.basename(filename)
  end

  private
  def save_uploaded_file(fileobj, filepath, filename)
    # Kompletter Pfad
    complete_path = Rails.root.join('public/' + filepath)
    #puts "PATH: " << complete_path.to_s << " / " << filename
    # Falls notwendig, Verzeichnis erstellen
    FileUtils.mkdir_p(complete_path) unless File.exists?(complete_path)
    # Datei speichern
    begin
      f = File.open(complete_path.to_s + '/' + filename, 'wb')
      f.write(fileobj.read)
    rescue
      return false
    ensure
    f.close unless f.nil?
    end
  end
  
end
