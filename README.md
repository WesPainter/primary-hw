# Music Collection

A simple program for managing your music collection.  Add albums to your library and play them.


## Running

With a compatible version of ruby and from within the root directory:

    $ ./music

There are no gems or dependencies outside of the Ruby STL.

A list of commands is as follows.  All commands, titles, and albums are case-sensitive:


    add "$title" "$artist": Adds an album to the collection.
    play "$title": Plays an album
    show all: Displays all albums.
    show unplayed: Displays all unplayed albums.
    show all by "$artist": Displays all albums by an artist.
    show unplayed by "$artist": Displays all unplayed albums my an artist.
    quit: Exits the program


## Testing

To run an individual test file, from the root directory:

    $ ruby test/music/album_test.rb

To run the entire test suite, from the root directory:

    $ rake test
