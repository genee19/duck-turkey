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
    var result = [];
    var rolls = this.props.frame.rolls
    if (rolls[0] != null) { // if there was the first roll in this frame
      result.push(<input key="1" name="rolls[]" className="game-frame__input game-frame__input--1" type="number" size="2" max="10" defaultValue={rolls[0]}/>)
      if ((rolls[1] != null) || !(this.props.frame.special == 'strike')) { // there was a second roll already or we're allowed to make it
        result.push(<input key="2" name="rolls[]" className="game-frame__input game-frame__input--2" type="number" size="2" max={10-rolls[0]} defaultValue={rolls[1]}/>)
      }
      if (this.props.is_final) {
        if (this.props.frame.special == 'strike') {
          result.push(<input key="2" name="rolls[]" className="game-frame__input game-frame__input--2" type="number" size="2" max="10"  defaultValue={rolls[1]}/>)
        }
        if (this.props.frame.special > '') {
          result.push(<input key="3" name="rolls[]" className="game-frame__input game-frame__input--3" type="number" size="2" max="10"  defaultValue={rolls[2]}/>)
        }
      }
    } else { // there wasn't any rolls yet
        result.push(<input key="1" name="rolls[]" className="game-frame__input game-frame__input--1" type="number" size="2" max="10" />)
    }
    return result;
  },
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
        <div className="game-frame__output game-frame__output--num">#{this.props.num}</div>
        <div className="game-frame__container game-frame__container--inputs">
          {this.inputs()}
        </div>
        <div className="game-frame__output game-frame__output--score">{this.props.frame.score}</div>
      </div>
    );
  }
});
