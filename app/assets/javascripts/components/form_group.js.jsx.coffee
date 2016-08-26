class @FormGroup extends React.Component

  render: ->
    `<div className='form-group'>
      <label>{this.props.label}</label>
      <input name={this.props.name} className='form-control' defaultValue={this.props.defaultValue} onChange={this.props.handleChange} />
    </div>`
