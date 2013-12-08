Venue = Struct.new(:id) do
  BFI_SOUTHBANK = 3471

  def self.all
    [Venue.new(BFI_SOUTHBANK)]
  end

  def films
    DataSource.get_films(id)
  end
end
