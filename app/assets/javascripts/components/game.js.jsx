window.Game = React.createClass({
	getInitialState: function(){
	    return {
	    	"score":0,
	    	"write_to_last_frame":false,
	    	"frames":[],
	    	"over":false
    	};
	},
	// TODO handle inputs and send data back to server
	render: function(){
		return (
			<div class="game">
				<p> Ohhai! </p>
				<form action={this.props.url}>
					
					<GameFrame />
				</form>
			</div>
		)
	}
})