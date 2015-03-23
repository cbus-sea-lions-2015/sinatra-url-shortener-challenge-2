class UrlShortener
    


  def before_save(record)
      record.short_url = make_shorty
  end
  def make_shorty
    shorty = rand(1000..9999)
    if Url.where("short_url LIKE '%#{shorty}'")
      "#{shorty}"
    else
      make_shorty
    end
  end
end

class Url < ActiveRecord::Base
  # Remember to create a migration!
  before_save       UrlShortener.new
  belongs_to :user
  
  def update_count
    if self.click_counter
      self.click_counter += 1
    else
      self.click_counter = 1
    end
    self.save
  end
  
  validates :original_url, format: { with: /(http(s?):\/\/)(www\.)?\w+(\.)\S+\b/ }
end

