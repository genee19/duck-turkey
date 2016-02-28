class Game
  include ActiveModel::Validations
  attr_accessor :rolls
  # TODO Validation: check if rolls are an array of integers
  attr_accessor :over
  
  def scores
  	# Bowling is played by throwing a ball down a narrow alley toward ten wooden pins.
  	# The object is to knock down as many pins as possible per throw 
  	result = OpenStruct.new

  	frames = []

  	awardable_frames = {}
  	awarded_rolls = 0

  	@over = false # we begin to score the game as if new

  	is_frame_started = false

  	result.score = 0

  	# iterate through rolls and divide them into frames. 
  	@rolls.each do |roll|
  		unless is_frame_started
  			#  The game is played in ten frames. At the beginning of each frame, all ten pins are set up. The player then gets two tries to knock them all down. 
  			# add new empty frame to frames
  			frames << {
  				rolls: [],
  				score: 0
  			}
  			# we are now in new frame
  			is_frame_started = true
  		end

  		# if this roll is not in between 0 and 10, this is an error
  		unless roll.is_a? Integer and roll >=0 and roll <=10
  			register_game_status(result, {error: "Any roll may only be integer between 0 and 10, got #{roll} instead"})
  			@over = true
  			break
  		end

  		frames.last[:rolls] << roll 

  		# if we had strike then this frame ends
		# • After the second ball of the frame, the frame ends even if there are still pins standing. 
  		if (roll == 10 or frames.last[:rolls].size == 2) and (frames.size <= 10) # we treat the 11th frame specially
  			is_frame_started = false
  		end

  		if (frames.size <= 10)
	  		# add roll result to current frame
	  		frames.last[:score] += roll
	  		result.score += roll
  		end
  		

		# award extra scores to previous strikes and spares
		# go through awardable frames and modify it, decreasing the numbers, awarding points and discarding zeroes
		awardable_frames = awardable_frames.inject({}) do |new_awardable_frames, (key, value)| 
			# award points of the current roll to the target frame
			frames[key][:score] += roll
			# add the score to overall sum
  			result.score += roll
			# decrease remaining award times and throw away zeroes
			new_awardable_frames[key] = value-1 if value > 1; 
			new_awardable_frames
		end

		awarded_rolls -= 1 if awarded_rolls > 0

  		unless is_frame_started 
  			# score this frame
  			frames.last.merge! find_special_cases(frames.last[:rolls])

  			# process the score of frame
  			# if error, game is over
  			unless frames.last[:error].blank?
  				register_game_status result, {error: frames.last[:error]}
  				@over = true
  				break
			end

		  	# mark this frame for upcoming awards if there was a special case
		  	unless frames.last[:special].blank?
			  	# • A strike frame is scored by adding ten, plus the number of pins knocked down by the next two balls, to the score of the previous frame.
			  	# • A spare frame is scored by adding ten, plus the number of pins knocked down by the next ball, to the score of the previous frame. 
			  	# add a reference to this frame and the number of extra rolls it consumes to awardable frames
			  	awardable_frames[frames.size-1] = (frames.last[:special] == :strike)? 2 : 1
		  	end

	  		# after 10 frames the game may be over
	  		if frames.size == 10
			  	# • If a strike is thrown in the tenth frame, then the player may throw two more balls to complete the score of the strike. 
			  	# • Likewise, if a spare is thrown in the tenth frame, the player may throw one more ball to complete the score of the spare. 
			  	# • Thus the tenth frame may have three balls instead of two.
		  		# calculate if the game is over
			  	if frames.last[:special]
			  		# special case: one extra roll if this was frame 10 and we had spare
			  		# special case: two extra rolls if this was frame 10 and we had strike
			  		awarded_rolls = (frames.last[:special] == :strike)? 2 : 1
			  	else
	  				@over = true
	  			end
	  		end
  		end

  		@over = true if frames.size == 11 and awarded_rolls == 0

  		break if @over
  	end
  	
  	result.frames = frames
  	result.over = @over
  	return result
  end

  private

  def register_game_status(game, status)
  	game.status = status
  end

  def find_special_cases(rolls)
  	result = {score: rolls.sum}

  	# if sum > 10 there was an error
  	if result[:score] > 10
  		result[:error] = 'Could somehow hit more than 10 pins in a frame'
  	end

  	# if sum is exactly 10, we have a special case
  	if result[:score] == 10
		# • If the player knocks all the pins down on the first try, it is called a „strike,“ and the frame ends. 
  		if rolls.size ==1
  			result[:special] = :strike

	  	# • If the player fails to knock down all the pins with his first ball, but succeeds with the second ball, it is called a „spare.“ 
		else
			result[:special] = :spare
  		end
  	end

  	return result
  end
end