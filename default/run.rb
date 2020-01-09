require './game.rb'
require './player.rb'

5.times do
p = Player.new
g = Game.new( p )
g.run
g.reset
end