class QLearningPlayer
  attr_accessor :x, :game

  def initialize
    @x = 0
    @actions = [:left, :right]
    @first_run = true

    @learning_rate = 0.2
    @discount = 0.9
    @epsilon = 0.9

    @r = Random.new
    @r2 = Random.new
    @r3 = Random.new
  end

  def initialize_q_table
    # Initialize q_table states by actions
    @q_table = Array.new(@game.map_size){ Array.new(@actions.length) }

    # Initialize to random values
    @game.map_size.times do |s|
      @actions.length.times do |a|
        @q_table[s][a] = @r.rand
      end
    end
  end

  def get_input
    # Pause to make sure humans can follow along
    sleep 0.05

    if @first_run
      # If this is first run initialize the Q-table
      initialize_q_table
      @first_run = false
    else
      # If this is not the first run
      # Evaluate what happened on last action and update Q table
      # Calculate reward
      r = 0 # default is 0
      r2 = 0
      r3 = 0

    
     
     #reward distance cheese
      if @game.old_d_f > @game.d_f
        r = 1 # reward if we getting closer to the objective
      elsif @game.old_d_f < @game.d_f

        r = -1 #oposite reward, getting far to it
      end

      #reward score
      if @old_score < @game.score
        r2 = 3 # reward is 3 if our score increased
      elsif @old_score > @game.score
        r2 = -5 # reward is -5 if our score decreased
      end

      #reward distance hole
=begin
      
       if @game.old_d_t > @game.d_t
        r3 = -1 # reward if we getting closer to the objective
      elsif @game.old_d_t < @game.d_t

        r3 = 1 #oposite reward, getting far to it
      end
=end

   #reward moves


       if @game.old_moves < @game.moves
        r4 = -0.01 # reward if we getting had a new move
      else r4 = 0
      end



      #total reward

       r = r + r2 + r3 + r4


     
      # Our new state is equal to the player position
      @outcome_state = @x
      @q_table[@old_state][@action_taken_index] = @q_table[@old_state][@action_taken_index] + @learning_rate * (r + @discount * @q_table[@outcome_state].max - @q_table[@old_state][@action_taken_index])
    end

    # Capture current state and score
    @old_score = @game.score
    @old_state = @x

    # Chose action based on Q value estimates for state
    if @r.rand > @epsilon
      # Select random action
      @action_taken_index = @r.rand(@actions.length).round
    else
      # Select based on Q table
      s = @x
      @action_taken_index = @q_table[s].each_with_index.max[1]
    end

    # Take action
    return @actions[@action_taken_index]
  end


  def print_table
    @q_table.length.times do |i|
      puts @q_table[i].to_s
    end
  end

end
