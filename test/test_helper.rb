$LOAD_PATH << 'lib'

require 'minitest/autorun'
require 'music.rb'

Struct.new('Album', :title, :artist_name, :played?)

def build_mock_album(title, artist, played = false)
  Struct::Album.new(title, artist, played)
end
