class @Panel extends React.Component
  render: ->
    `<div className="panel panel-default">
      <div className="panel-heading">
        <h3 className="panel-title">{this.props.header}</h3>
      </div>
      <div className="panel-body">
        {this.props.children}
      </div>
    </div>`
