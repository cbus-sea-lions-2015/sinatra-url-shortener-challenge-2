module UrlHelper
  def self.get_short_url
    ('a'..'z').to_a.sample(6).join
  end
end