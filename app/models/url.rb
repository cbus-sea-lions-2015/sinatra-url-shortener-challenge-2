class Url < ActiveRecord::Base
  include UrlHelper
  before_save :make_short_url
  validates :long_url, format: { with: /(https?:|www)/ }
  
  private
  def make_short_url
    self.short_url = UrlHelper.get_short_url
  end
end
