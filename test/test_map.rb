require 'test/unit'
require_relative '../lib/map'

class MapTests < Test::Unit::TestCase
  include Rooms

  def test_room()
    gold = Room.new("GoldRoom", 
                %q{This room has gold in it you can grab. There's a
                door to the north.})
    assert_equal(gold.name, "GoldRoom")
    assert_equal(gold.paths, {})
  end

  def test_room_paths()
    center = Room.new("Center", "Test room in the center.")
    north = Room.new("North", "Test room in the north.")
    south = Room.new("South", "Test room in the south.")

    center.add_paths({'north' => north, 'south' => south})
    assert_equal(center.go('north'), north)
    assert_equal(center.go('south'), south)
  end

  def test_map()
    starting = Room.new("starting", "You can go west and down a hole.")
    west = Room.new("Trees", "There are trees here, you can go east.")
    down = Room.new("Dungeon", "It's dark down here, you can go up.")

    starting.add_paths({'west' => west, 'down' => down})
    west.add_paths({'east' => starting})
    down.add_paths({'up' => starting})

    assert_equal(starting.go('west'), west)
    assert_equal(starting.go('west').go('east'), starting)
    assert_equal(starting.go('down').go('up'), starting)
  end

  def test_gothon_game_map()
    assert_equal(START.go('shoot!'), GENERIC_DEATH)
    assert_equal(START.go('dodge!'), GENERIC_DEATH)

    room = START.go('tell a joke')
    assert_equal(room, LASER_WEAPON_ARMORY)
  end

end