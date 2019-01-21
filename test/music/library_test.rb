require_relative '../test_helper.rb'

# Since it is all in memory, omitted using fake album objects
class TestLibrary < MiniTest::Test
  def setup
    @library = Music::Library.new
    @album1 = build_mock_album('Ill Communication', 'Beastie Boys', true)
    @album2 = build_mock_album('Licensed to Ill', 'Beastie Boys', false)
    @album3 = build_mock_album('The Black Album', 'Jay-Z', true)
    @album4 = build_mock_album('The Blueprint', 'Jay-Z', false)
    @library.instance_variable_set(:@albums, [@album1, @album2, @album3, @album4])
  end

  def test_add_album
    expected_title = 'To The 5 Boroughs'
    expected_artist = 'Beastie Boys'
    mock_album = build_mock_album(expected_title, expected_artist)

    album_create_mock = MiniTest::Mock.new
    album_create_mock.expect :call, mock_album, [expected_title, expected_artist]

    Music::Album.stub :new, album_create_mock do
      @library.add_album(expected_title, expected_artist)
    end

    album_create_mock.verify
    assert @library.albums.include?(mock_album)
  end

  def test_add_album_already_exists
    assert_raises Music::AlbumExistsError do
      @library.add_album(@album1.title, @album1.artist_name)
    end
  end

  def test_list_albums_no_albums
    assert_equal [], Music::Library.new.list_albums
  end

  def test_list_albums_no_matches
    assert_equal [], @library.list_albums(artist_name: 'Unknown Artist')
  end

  def test_list_albums_all
    listed_albums = @library.list_albums
    assert_equal [@album1, @album2, @album3, @album4], listed_albums
  end

  def test_list_albums_artist
    listed_albums = @library.list_albums(artist_name: 'Beastie Boys')
    assert_equal [@album1, @album2], listed_albums
  end

  def test_list_albums_unplayed
    listed_albums = @library.list_albums(unplayed_only: true)
    assert_equal [@album2, @album4], listed_albums
  end

  def test_list_albums_unplayed_and_artist_name
    listed_albums = @library.list_albums(unplayed_only: true, artist_name: 'Jay-Z')
    assert_equal [@album4], listed_albums
  end

  def test_play_album_no_albums_raises_error
    assert_raises Music::NoAlbumError do
      Music::Library.new.play_album('Licensed to Ill')
    end
  end

  def test_play_album_album_not_found_raises_error
    assert_raises Music::NoAlbumError do
      @library.play_album('Illmatic')
    end
  end
end
