require 'test_helper'

class GameTest < ActiveSupport::TestCase
	test 'basic game, open first frame' do
		# TODO create a Game instance for empty game
		game = Game.new
		game.rolls = [1]
		result = game.scores
		assert result == OpenStruct.new({
			score: 1, 
			frames: [
				{
					rolls: [1], 
					score: 1
				}
			], 
			write_to_last_frame: true,
			over: false
		}), "Basic game of 1 roll should have 1 frame and resulting score of 1"
	end


	test 'one strike game' do
		game = Game.new
		game.rolls = [10, 1, 1]
		result = game.scores
		assert result == OpenStruct.new({
			score: 14, 
			frames: [
				{
					rolls: [10],
					special: :strike,
					score: 12
				},
				{
					rolls: [1, 1],
					score: 2
				}
			], 
			write_to_last_frame: false,
			over: false
		}), "Strike should accumulate the scores of the next 2 rolls"
	end

	test 'one spare game' do
		game = Game.new
		game.rolls = [9, 1, 1, 1]
		result = game.scores

		assert result.frames[0][:score] == 11, "Spare should accumulate the scores of the next 1 roll"
	end

	test 'two strikes game' do
		game = Game.new
		game.rolls = [10, 10, 1, 1]
		result = game.scores
		assert result.frames[0][:score] == 21, "Strike should accumulate the scores of the next 2 rolls; two strikes accumulate too"
	end


	test 'wikipedia example 1: one strike' do
		game = Game.new
		game.rolls = [10, 3, 6]
		result = game.scores
		assert result.score == 28, "Wikipedia: 10, 3, 9 should result in 28"
	end

	test 'wikipedia example 2: two strikes' do
		game = Game.new
		game.rolls = [10, 10, 9, 0]
		result = game.scores
		assert result.score == 57, "Wikipedia: 10, 10, 9, 0 should result in 57 ('double')"
	end

	test 'wikipedia example 3: three strikes' do
		game = Game.new
		game.rolls = [10, 10, 10, 0, 9]
		result = game.scores
		assert result.score== 78, "Wikipedia: 10, 10, 10, 0, 9 should result in 78 ('turkey')"
	end

	test 'wikipedia example 4: spare' do
		game = Game.new
		game.rolls = [7, 3, 4, 2]
		result = game.scores
		assert result.score == 20, "Wikipedia: 7, 3, 4, 2 should result in 20"
		assert result.frames[0][:special] == :spare, "In a 7, 3, 4, 2 game, first frame must be spare"
	end

	# TODO add cases for final strike and final spare

	test 'perfect game' do
		game = Game.new
		game.rolls = Array.new(12, 10) # 12 times strike
		result = game.scores
		assert result.score == 300, 'Resulting score of a perfect game (12 strikes in a row) should be 300'
		assert result.frames[9][:rolls] == [10, 10, 10], 'The last frame should contain all 3 strikes'
	end
	
	test 'final spare' do
		game = Game.new
		game.rolls = [10, 10, 10, 10, 10, 10, 10, 10, 10, 9, 1, 1]
		result = game.scores
		assert result.score == 270, '9 strikes, 1 final spare and 1 pin in an extra roll would be 270 points'
	end

	test 'final spare and extra 10' do
		game = Game.new
		game.rolls = [10, 10, 10, 10, 10, 10, 10, 10, 10, 9, 1, 10]
		result = game.scores
		assert result.score == 279, '9 strikes, 1 final spare and 10 pins in an extra roll would be 279 points'
	end

	test 'excessive data 1' do 
		game = Game.new
		game.rolls = Array.new(23,1) # 23 rolls by 1 pin, more than should come within a game
		result = game.scores
		assert result.score == 20
	end
end
