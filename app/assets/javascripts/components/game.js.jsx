window.Game = React.createClass({
	getInitialState: function(){
	    return {
	    	"score":0,
	    	"write_to_last_frame":false,
	    	"frames":[],
	    	"over":false
    	};
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
					{this.newFrameWhenNecessary()}
				</form>
			</div>
		);
	}
});
