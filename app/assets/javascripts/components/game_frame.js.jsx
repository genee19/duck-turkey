window.Game.Frame = React.createClass({
  propTypes: {
    frame: React.PropTypes.object,
    is_final: React.PropTypes.bool
  },
  getInitialState: function(){
      return {
        rolls: [],
        score: 0
    };
  },
  inputs: function() {

  },
  render: function() {
    return (
      <div className="game-frame">
        <div className="game-frame__container game-frame__container--inputs">
          <input name="rolls[]" type="number"/>
          <input name="rolls[]" type="number"/>
        </div>
        <div className="game-frame__ouput--score"></div>
      </div>
    );
  }
});
