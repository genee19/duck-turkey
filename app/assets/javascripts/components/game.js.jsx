window.Game = React.createClass({
	getInitialState: function(){
	    return {
	    	"score":0,
	    	"write_to_last_frame":false,
	    	"frames":[],
	    	"over":false
    	};
	},
	handleChange: function(event){
		// locate form from event.target
		$form = $(event.target).closest('form.game__form');
		$.post($form.attr('action'), $form.serialize()).done(function(){
		})
	},
	frames: function() {
		var result = [];
		for (var frame in this.state.frames) {
			result.push(<Game.Frame frame={frame} />);
		}
		return result;
	},
	newFrameWhenNecessary: function() {
		if (!this.state.write_to_last_frame) {
			return (
				<Game.Frame />
			);
		}
	},
	// TODO handle inputs and send data back to server
	render: function(){
		return (
			<div className="game">
				<form action={this.props.url} onChange={this.handleChange} className="game__form">
					{this.frames()}
					{this.newFrameWhenNecessary()}
				</form>
			</div>
		);
	}
});
