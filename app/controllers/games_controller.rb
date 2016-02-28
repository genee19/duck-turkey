class GamesController < ApplicationController
	def index
	end

	def new
		game = Game.new
		game.rolls = params[:rolls].reject(&:'blank?').map(&:to_i) or []
		result = game.scores

		render json: result.marshal_dump.to_json
	end
end