require 'data_source'

Venue = Struct.new(:id) do
  #VENUES = [1522,1503,6856,1574,1204, 3471]
  VENUES = [1522,1503,6856,1574,1204,7752,1720,7477,1779,1271,3343,1517,1523,5483,1520,1170,5139,1369,3471,57,1203,1606,1377,40,6938,1518,1507,2432,6780,5307,7726,6181,6671]
  #VENUES = [1522,1503,6856,1574,1204,7752,1720,7477,1779,1271,3343,1517,1523,5483,1520,1170,5139,1369,3471,57,1203,1606,1377,40,6938,1518,1507,2432,6780,5307,7726,6181,6671,5403,2786,1579,6449,6089,3373,1782,5208,6850,6155,4996,1156,1278,1361,6094,1166,1582,5313,1913,1307,1497,1168,6359,1464,7652,1264,1516,6151,1279,1688,5364,1513,1176,6342,1300,1585,1614,2116,5015,1412,1718,5323,1329,1472,3550]

  def self.all
    VENUES.map {|id| Venue.new id}
  end

  def get_films days
    all_films = []
    1.upto(days) {|day| all_films.concat(DataSource.get_films id, day)}
    all_films.select {|film| film.year < 1980}
  end
end
