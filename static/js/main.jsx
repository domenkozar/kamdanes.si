var el = document.getElementById('events'),
    Events = React.createClass({
  componentDidMount: function() {
    jQuery.timeago.settings.allowFuture = true;
    jQuery(document).ready(function() {
      $(".timeago").timeago();
    });
  },
  render: function() {
    var mainStyle = {
      maxWidth: '600px',
      margin: '5px auto'
    }, eventNodes = this.props.events.map(function (e) {
        var priceTag;
        if (e.price) {
            priceTag = <i>Vstopnina: {e.price} EUR</i>;
        } else {
            priceTag = "";
        }
    return (
        <li className="list-group-item">
          <div className="media">
            <a className="media-left" href={e.link}>
              <img src={e.image} alt="Event image" width="64px" />
            </a>
            <div className="media-body">
              <h4 className="media-heading"><a href={e.link}>[{e.location}] {e.title}</a></h4>
              <i>Začetek: <abbr className="timeago badge" title={e.time}>{e.time}</abbr></i>
              <br />
              {priceTag}
              <p><div dangerouslySetInnerHTML={{__html: e.description}} /></p>
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

$.get('/events').success(function(data) {
  React.render(<Events events={data.events} />, el);
}).fail(function() {
  el.innerHTML = "<p class='error'>Error with a request</p>";
});
