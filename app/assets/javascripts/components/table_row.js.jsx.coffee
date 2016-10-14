class @TableRow extends React.Component
  value: ->
    try
      this.props.value.toFixed(2)
    catch error
      this.props.value


  render: ->
    `<tr>
      <td>
        {this.props.label}
      </td>
      <td>
        {this.props.prefix} {this.value()} {this.props.suffix}
      </td>
    </tr>`
