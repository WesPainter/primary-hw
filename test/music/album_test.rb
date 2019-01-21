require_relative '../test_helper.rb'

class TestAlbum < MiniTest::Test
  def setup
    @expected_title = 'a test title'
    @expected_artist = 'A Test Artist'
    @album = Music::Album.new(@expected_title, @expected_artist)
  end

  def test_album_initialize
    assert_equal @expected_title, @album.title
    assert_equal @expected_artist, @album.artist_name
    assert_equal 0, @album.plays
  end

  def test_album_played_false_0_plays
    refute @album.played?
  end

  def test_album_played_true_1_play
    @album.instance_variable_set(:@plays, 1)
    assert @album.played?
  end

  def test_album_play_once
    @album.play
    assert_equal 1, @album.plays
  end

  def test_album_play_100_times
    100.times do
      @album.play
    end

    assert_equal 100, @album.plays
  end
end
