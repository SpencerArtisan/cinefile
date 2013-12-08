Venue = Struct.new(:id) do
  BFI_SOUTHBANK = 3471

  def self.all
    [Venue.new(BFI_SOUTHBANK)]
  end
end
