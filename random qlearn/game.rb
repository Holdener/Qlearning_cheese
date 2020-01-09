
class Game
  attr_accessor :score, :map_size, :d_f , :old_d_f , :d_t , :old_d_t , :old_moves, :moves
  def initialize player
    @run = 0
    @map_size = rand(12..20)
    @player = player
    

    reset

    # Clear the console
    puts "\e[H\e[2J"

  end

  def reset
    @player.x = rand(1..10)
    @cheese_x = rand(0...@map_size)
    @pit_x = rand(0...@map_size)
    @score = 0
    @run += 1
    @moves = 0
    @tStart = Time.now
    @d_f = 0 # distance from the ia to cheese
    @old_d_f = 0
    @d_t = 0 #distance from the ia to hole
    @old_d_t = 0
    

  end

  def run
    while @score < 5 && @score > -5
      draw
      gameloop
      @old_moves = moves
      @moves += 1
    end

    # Draw one last time to update the
    draw
    if @score >= 5
    	open('result.txt', 'a') do |f|
    	   @tStop = Time.now 
      	 @diff = @tStop - @tStart
          puts "  You win in #{@moves} moves!"
	       f << "run ##{@run} | WIN with #{@moves} moves in #{@diff} seconds!\n"
	   end
	  
    else
    	open('result.txt', 'a') do |f|
    	@tStop = Time.now 
    	@diff = @tStop - @tStart
      puts "  Game over!"
	  f << "run ##{@run} | LOSE with #{@moves} moves in #{@diff} seconds!\n"
	end
	  
    end
	

  end

  def gameloop
    move = @player.get_input
    if move == :left
      @player.x = @player.x > 0 ? @player.x-1 : @map_size-1;
    elsif move == :right
      @player.x = @player.x < @map_size-1 ? @player.x+1 : 0;
    end

    #get distances
    @old_d_f = d_f
    @old_d_t = d_t

    @d_f = (@cheese_x - @player.x).abs
    @d_t = (@pit_x - @player.x).abs

    if @player.x == @cheese_x
      @score += 1
      @player.x = rand(1..10)
      @cheese_x = rand(0...@map_size)
   	  @pit_x = rand(0...@map_size)

    end

    if @player.x == @pit_x
      @score -= 1
      @player.x = rand(1..10)
      @cheese_x = rand(0...@map_size)
      @pit_x = rand(0...@map_size)

    end
  end

  def draw
    # Compute map line
    map_line = @map_size.times.map do |i|
      if @player.x == i
        'P'
      elsif @cheese_x == i
        'C'
      elsif @pit_x == i
        'O'
      else
        '='
      end
    end
    map_line = "\r##{map_line.join}# | Score #{@score} | Run #{@run} | cheese_x #{@cheese_x} | pit_x #{@pit_x} | d #{@d} | move #{@moves}   "

    # Draw to console
    # use printf because we want to update the line rather than print a new one
    printf("%s", map_line)
  end
end
