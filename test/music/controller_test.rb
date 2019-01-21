require_relative '../test_helper.rb'

class TestController < MiniTest::Test
  def setup
    @controller = Music::Controller.new
    @album1 = build_mock_album('Ill Communication', 'Beastie Boys', true)
    @album2 = build_mock_album('Licensed to Ill', 'Beastie Boys', false)
    @album3 = build_mock_album('The Black Album', 'Jay-Z', true)
    @album4 = build_mock_album('The Blueprint', 'Jay-Z', false)
  end

  def test_add_album
    album_title = 'Sticky Fingers'
    artist_name = 'Rolling Stones'
    add_album_mock = MiniTest::Mock.new
    add_album_mock.expect :call, nil, [album_title, artist_name]

    message = @controller.library.stub :add_album, add_album_mock do
      @controller.send(:add, album_title, artist_name)
    end

    add_album_mock.verify
    assert_equal "Added \"#{album_title}\" by #{artist_name}", message
  end

  def test_add_album_exists_error
    album_title = 'Who Are You'
    artist_name = 'The Who'
    raises_exception = ->(_, _) { raise Music::AlbumExistsError }

    message = @controller.library.stub :add_album, raises_exception do
      @controller.send(:add, album_title, artist_name)
    end

    assert_equal "An album titled \"#{album_title}\" already exists", message
  end

  def test_show_album_bad_sub_command_fails
    assert_raises ArgumentError do
      @controller.send(:show, 'random')
    end
  end

  def test_show_album_by_without_artist_fails
    assert_raises ArgumentError do
      @controller.send(:show, 'all', 'by')
    end
  end

  def test_show_album_artist_without_by_fails
    assert_raises ArgumentError do
      @controller.send(:show, 'unplayed', 'wrong', 'artist')
    end
  end

  def test_show_albums_empty
    assert_equal 'No albums to show.', @controller.send(:show, 'unplayed')
  end

  def test_show_albums_all
    albums = [@album1, @album2, @album3, @album4]
    expected_message = "\"Ill Communication\" by Beastie Boys (played)\n\
\"Licensed to Ill\" by Beastie Boys (unplayed)\n\
\"The Black Album\" by Jay-Z (played)\n\
\"The Blueprint\" by Jay-Z (unplayed)\n"
    show_mock = MiniTest::Mock.new
    show_mock.expect :call, albums, [{unplayed_only: false, artist_name: nil}]

    message = @controller.library.stub :list_albums, show_mock do
      @controller.send(:show, 'all')
    end

    show_mock.verify
    assert_equal expected_message, message
  end

  def test_show_albums_unplayed
    albums = [@album2, @album4]
    expected_message = "\"Licensed to Ill\" by Beastie Boys \n\"The Blueprint\" by Jay-Z \n"
    show_mock = MiniTest::Mock.new
    show_mock.expect :call, albums, [{unplayed_only: true, artist_name: nil}]

    message = @controller.library.stub :list_albums, show_mock do
      @controller.send(:show, 'unplayed')
    end

    show_mock.verify
    assert_equal expected_message, message
  end

  def test_show_albums_artist
    albums = [@album3, @album4]
    expected_message = "\"The Black Album\" by Jay-Z (played)\n\"The Blueprint\" by Jay-Z (unplayed)\n"
    show_mock = MiniTest::Mock.new
    show_mock.expect :call, albums, [{unplayed_only: false, artist_name: 'Jay-Z'}]

    message = @controller.library.stub :list_albums, show_mock do
      @controller.send(:show, 'all', 'by', 'Jay-Z')
    end

    show_mock.verify
    assert_equal expected_message, message
  end

  def test_show_albums_artist_unplayed
    albums = [@album2]
    expected_message = "\"Licensed to Ill\" by Beastie Boys \n"
    show_mock = MiniTest::Mock.new
    show_mock.expect :call, albums, [{unplayed_only: true, artist_name: 'Beastie Boys'}]

    message = @controller.library.stub :list_albums, show_mock do
      @controller.send(:show, 'unplayed', 'by', 'Beastie Boys')
    end

    show_mock.verify
    assert_equal expected_message, message
  end

  def test_play_album
    album_title = 'Let It Bleed'
    play_album_mock = MiniTest::Mock.new
    play_album_mock.expect :call, nil, [album_title]

    message = @controller.library.stub :play_album, play_album_mock do
      @controller.send(:play, album_title)
    end

    play_album_mock.verify
    assert_equal "You're listening to \"#{album_title}\"", message
  end

  def test_play_album_no_album
    album_title = 'Let It Bleed'
    raises_exception = ->(_) { raise Music::NoAlbumError }

    message = @controller.library.stub :play_album, raises_exception do
      @controller.send(:play, album_title)
    end

    assert_equal "Couldn't find an album titled \"#{album_title}\"", message
  end
end
