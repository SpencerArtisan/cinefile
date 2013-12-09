require 'data_source'

Venue = Struct.new(:id, :name) do
  def self.all
    DataSource.find_cinemas('WC1N')
  end

  def get_films days
    all_films = []
    1.upto(days) {|day| all_films.concat(DataSource.get_films self, day)}
    all_films.select {|film| film.year < 1980}
  end
end
