require 'data_source'

Cinema = Struct.new(:id, :name) do
  def self.all datasource
    datasource.find_cinemas('WC1N')
  end

  def get_films datasource, days
    all_films = []
    1.upto(days) {|day| all_films.concat(datasource.get_films self, day)}
    all_films
  end
end
