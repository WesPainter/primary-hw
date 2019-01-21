module Music
  # Store, control, and list albums without interface assumptions
  class Library
    attr_reader :albums

    def initialize
      @albums = []
    end

    # Add an album
    def add_album(album_title, artist_name)
      raise AlbumExistsError if albums.any? { |album| album.title == album_title }

      album = Album.new(album_title, artist_name)
      @albums << album
    end

    # Filter by unplayed or artist_name, if given
    def list_albums(unplayed_only: false, artist_name: nil)
      @albums.reduce([]) do |aggregator, album|
        next aggregator if unplayed_only && album.played? ||
                           artist_name && album.artist_name != artist_name

        aggregator << album
      end
    end

    # find an album and play it
    def play_album(album_title)
      album = @albums.find { |alb| alb.title == album_title }
      raise NoAlbumError unless album

      album.play
    end
  end
end
