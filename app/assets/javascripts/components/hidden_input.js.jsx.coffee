class @HiddenInput extends React.Component

  name: ->
    "rental_calculation[#{this.props.name}]"

  id: ->
    "rental_calculation_#{this.props.name}"

  render: ->
    `<input type="hidden" value={this.props.value} name={this.name()} id={this.id()} />`
