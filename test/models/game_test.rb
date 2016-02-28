require 'test_helper'

class GameTest < ActiveSupport::TestCase
	test 'basic game, open first frame' do
		# TODO create a Game instance for empty game
		game = Game.new
		game.rolls = [1]
		result = game.scores
		# TODO assert the state of the score object for empty game
		assert result == OpenStruct.new({
			score: 1, 
			frames: [
				{
					rolls: [1], 
					score: 1
				}
			], 
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
			over: false
		}), "Strike should accumulate the scores of the next 2 rolls"
	end

	test 'one spare game' do
		game = Game.new
		game.rolls = [9, 1, 1, 1]
		result = game.scores

		assert result == OpenStruct.new({
			score: 13, 
			frames: [
				{
					rolls: [9, 1],
					special: :spare,
					score: 11
				},
				{
					rolls: [1, 1],
					score: 2
				}
			], 
			over: false
		}), "Spare should accumulate the scores of the next 1 roll"
	end

	test 'two strikes game' do
		game = Game.new
		game.rolls = [10, 10, 1, 1]
		result = game.scores
		assert result == OpenStruct.new({
			score: 35, 
			frames: [
				{
					rolls: [10],
					special: :strike,
					score: 21
				},
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
			over: false
		}), "Strike should accumulate the scores of the next 2 rolls; two strikes accumulate too"
	end


	test 'wikipedia example 1: one strike' do
		game = Game.new
		game.rolls = [10, 3, 6]
		result = game.scores
		assert result == OpenStruct.new({
			score: 28, 
			frames: [
				{
					rolls: [10],
					special: :strike,
					score: 19
				},
				{
					rolls: [3, 6],
					score: 9
				}
			], 
			over: false
		}), "Wikipedia: 10, 3, 9 should result in 28"
	end

	test 'wikipedia example 2: two strikes' do
		game = Game.new
		game.rolls = [10, 10, 9, 0]
		result = game.scores
		assert result == OpenStruct.new({
			score: 57, 
			frames: [
				{
					rolls: [10],
					special: :strike,
					score: 29
				},
				{
					rolls: [10],
					special: :strike,
					score: 19
				},
				{
					rolls: [9, 0],
					score: 9
				}
			], 
			over: false
		}), "Wikipedia: 10, 10, 9, 0 should result in 57 ('double')"
	end

	test 'wikipedia example 3: three strikes' do
		game = Game.new
		game.rolls = [10, 10, 10, 0, 9]
		result = game.scores
		assert result == OpenStruct.new({
			score: 78, 
			frames: [
				{
					rolls: [10],
					special: :strike,
					score: 30
				},
				{
					rolls: [10],
					special: :strike,
					score: 20
				},
				{
					rolls: [10],
					special: :strike,
					score: 19
				},
				{
					rolls: [0, 9],
					score: 9
				}
			], 
			over: false
		}), "Wikipedia: 10, 10, 10, 0, 9 should result in 78 ('turkey')"
	end

	test 'wikipedia example 4: spare' do
		game = Game.new
		game.rolls = [7, 3, 4, 2]
		result = game.scores
		assert result == OpenStruct.new({
			score: 20, 
			frames: [
				{
					rolls: [7, 3],
					special: :spare,
					score: 14
				},
				{
					rolls: [4, 2],
					score: 6
				}
			], 
			over: false
		}), "Wikipedia: 7, 3, 4, 2 should result in 20"
	end

	# TODO add cases for final strike and final spare

	test 'perfect game' do
		game = Game.new
		game.rolls = Array.new(12, 10) # 12 times strike
		result = game.scores
		assert result.score == 300, 'Resulting score of a perfect game (12 strikes in a row) should be 300'
		assert result.frames[9][:rolls].size == 3
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
