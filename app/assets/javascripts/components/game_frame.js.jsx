window.Game.Frame = React.createClass({
  propTypes: {
    frame: React.PropTypes.object,
    is_final: React.PropTypes.bool
  },
  getDefaultProps(){
      return {
        rolls: [],
        score: 0
    };
  },

  inputs() {
  },
  render() {
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
