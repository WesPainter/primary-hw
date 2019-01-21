module Music
  # Service defining the interface for the music collection
  class Controller
    attr_reader :library

    def initialize
      @library = Library.new
    end

    def run
      puts 'Welcome to your music collection!'
      loop do
        print "\n> "
        message = run_command(gets.strip)
        puts "\n#{message}"
      end
    end

    private

    # take user input, normalize, run, return message
    def run_command(input)
      method, *params = input.split(/(".*?"|\S+)/).reject { |argument| argument.delete('"').strip.empty? }
      params.each { |param| param.delete!('"') }

      begin
        send(method, *params)
      rescue NoMethodError
        "#{method} is not a valid command."
      rescue ArgumentError
        "Invalid use of #{method}."
      end
    end

    # add a song to the library
    def add(album_title, artist_name)
      @library.add_album(album_title, artist_name)
      "Added \"#{album_title}\" by #{artist_name}"
    rescue AlbumExistsError
      "An album titled \"#{album_title}\" already exists"
    end

    # list songs by options
    def show(all_or_unplayed, by = nil, artist_name = nil)
      raise ArgumentError if show_params_invalid?(all_or_unplayed, by, artist_name)

      unplayed_only = all_or_unplayed == 'unplayed'
      albums = @library.list_albums(unplayed_only: unplayed_only, artist_name: artist_name)

      return 'No albums to show.' if albums.empty?

      albums.reduce('') do |message, album|
        message << "\"#{album.title}\" by #{album.artist_name} "
        message << "(#{album.played? ? 'played' : 'unplayed'})" unless unplayed_only
        message << "\n"
      end
    end

    # play song by title
    def play(album_title)
      @library.play_album(album_title)
      "You're listening to \"#{album_title}\""
    rescue NoAlbumError
      "Couldn't find an album titled \"#{album_title}\""
    end

    # Exit
    def quit
      puts 'Bye!'
      exit(true)
    end

    def show_params_invalid?(all_or_unplayed, by, artist_name)
      !%w[all unplayed].include?(all_or_unplayed) || by && artist_name.nil? || artist_name && by != 'by'
    end
  end
end
