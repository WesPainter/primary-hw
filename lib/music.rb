# frozen_string_literal: true

module Music
  require 'music/album'
  require 'music/controller'
  require 'music/library'

  class AlbumExistsError < StandardError; end
  class NoAlbumError < StandardError; end

  def self.run
    Controller.new.run
  end
end
