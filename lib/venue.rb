require 'data_source'

Venue = Struct.new(:id) do
  VENUES = [3471]

  def self.all
    VENUES.map {|id| Venue.new id}
  end

  def films
    DataSource.get_films id
  end
end
