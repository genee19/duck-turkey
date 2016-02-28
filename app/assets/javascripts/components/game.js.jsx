window.Game = React.createClass({
	componentDidMount: function() {
	      // TODO load data from server
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