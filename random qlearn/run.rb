require './game.rb'
require './player.rb'

p = Player.new
g = Game.new( p )
g.run

while STDIN.getch != "r"
puts "press R to exit"
end
exit