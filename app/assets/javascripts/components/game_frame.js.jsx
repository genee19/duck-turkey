window.Game.Frame = React.createClass({
  propTypes: {
    frame: React.PropTypes.object,
    is_final: React.PropTypes.bool
  },
  getDefaultProps(){
      return {
        frame: {
          rolls: [],
          score: 0
        }
    };
  },

  inputs() {
  frameClass() {
    result = ["game-frame"];
    if (this.props.frame.special > '') {
      result.push("game-frame--special-" + this.props.frame.special);
    }
    if (this.props.frame.error > '') {
      result.push("game-frame--has-error");
    }
    return result.join(" ");
  },
  render() {
    return (
      <div className={this.frameClass()}>
        <div className="game-frame__container game-frame__container--inputs">
          <input name="rolls[]" type="number"/>
          <input name="rolls[]" type="number"/>
        </div>
        <div className="game-frame__ouput--score"></div>
      </div>
    );
  }
});
