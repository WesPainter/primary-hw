module Music
  # information and actions on an individual album
  class Album
    attr_reader :title, :artist_name, :plays

    def initialize(title, artist_name)
      @title = title
      @artist_name = artist_name
      @plays = 0
    end

    # play the album
    def play
      @plays += 1
    end

    # has the album been played before?
    def played?
      @plays.positive?
    end
  end
end
