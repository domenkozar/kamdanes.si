var el = document.getElementById('events'),
    Events = React.createClass({
  componentDidMount: function() {
    jQuery.timeago.settings.allowFuture = true;
    jQuery(document).ready(function() {
      $(".timeago").timeago();
    });
  },
  getInitialState: function() {
    return {showDescription: {}};
  },
  handleClick: function(event) {
    var state = this.state.showDescription,
        id = parseInt($(event.target).closest('.btn-primary')[0].id);
    if (state[id]) {
       state[id] = false;
    } else {
       state[id] = true;
    }
    this.setState({showDescription: state});
  },
  render: function() {
    var self = this,
        mainStyle = {
      maxWidth: '600px',
      margin: '5px auto'
    },  mediaBodyStyle = {
      width: '100%'
    }, eventNodes = this.props.events.map(function (e) {
        var priceTag, descriptionNode, buttonNode;
        if (e.price) {
            priceTag = <i>Vstopnina: {e.price} EUR</i>;
        } else {
            priceTag = "";
        };
       descriptionNode = self.state.showDescription[e.id] ? <div dangerouslySetInnerHTML={{__html: e.description}} /> : "";
       buttonNode = self.state.showDescription[e.id] ? "Skrij opis" : "Opis dogodka";
    return (
        <li className="list-group-item" key={e.id}>
          <div className="media">
            <a className="media-left" href={e.link}>
              <img src={e.image} alt="Event image" width="128px" />
            </a>
            <div className="media-body" style={mediaBodyStyle}>
              <h4 className="media-heading"><a href={e.link}>
                {e.title}
              </a></h4>
              <h4><span className="label label-danger">{e.location}</span>&nbsp;</h4>
              <h5>
                <i className="">Začetek: <abbr className="timeago" title={e.time}>{e.time}</abbr></i>
                <span className="label label-primary">{priceTag}</span>
              </h5>
              {descriptionNode}
              <button className="btn btn-primary" id={e.id} onClick={self.handleClick}>
                <span className="glyphicon glyphicon-info-sign"></span> &nbsp;{buttonNode}
              </button>
            </div>
          </div>
        </li>
    );
    });

    if (this.props.events.length === 0) {
        eventNodes = (
            <li className="text-center"><i>Ni dogodkov.</i></li>
        );
    }

    return (
     <ul className="list-group" style={mainStyle}>
       <li className="list-unstyled text-center"><h3>Danes v Ljubljani</h3></li>
       {eventNodes}
     </ul>
   );
  }
});

module.exports = function () {
  $.get('/events').success(function(data) {
    React.render(<Events events={data.events} />, el);
  }).fail(function() {
    el.innerHTML = "<p class='error'>Error with a request</p>";
  });
}
