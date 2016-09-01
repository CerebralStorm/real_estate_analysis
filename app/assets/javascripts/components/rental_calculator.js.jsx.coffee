@RentalCalculator = React.createClass

  getInitialState: ->
    this.props

  handleChange: (event) ->
    this.setState({"#{event.target.name}": event.target.value})

  projectCost: ->
    parseInt(this.state.purchase_price) + parseInt(this.state.closing_cost) + parseInt(this.state.repair_cost)

  monthlyPaymentWithInterest: ->
    term = 12 * 30
    r = parseFloat(this.state.interest_rate) / 1200
    n = r * parseInt(this.loanAmount())
    d = 1 - (1 + r)**-term
    n / d

  totalCashNeeded: ->
    parseInt(this.downPayment()) + parseInt(this.state.closing_cost) + parseInt(this.state.repair_cost)

  monthlyExpenses: ->
    this.totalOperatingExpenses() + this.monthlyPaymentWithInterest()

  totalOperatingExpenses: ->
    total = 0
    total += this.calculatePercentCost('vacancy')
    total += this.calculatePercentCost('repairs')
    total += this.calculatePercentCost('capital_expenditures')
    total += this.calculatePercentCost('property_management')
    total += this.propertyTaxCost()
    total += this.toCost(parseFloat(this.state.monthly_electricity))
    total += this.toCost(parseFloat(this.state.monthly_water_and_sewer))
    total += this.toCost(parseFloat(this.state.private_mortagage_insurance))
    total += this.toCost(parseFloat(this.state.garbage))
    total += this.toCost(parseFloat(this.state.monthly_hoa))
    total += this.toCost(parseFloat(this.state.other_monthly_costs))
    total

  cashOnCash: ->
    ((this.cashFlow() * 12) / this.totalCashNeeded()) * 100

  netOperatingIncome: ->
    this.cashFlow() * 12

  downPayment: ->
    if this.state.down_payment_percent
      (parseFloat(this.state.down_payment_percent)/100) * parseFloat(this.state.purchase_price)
    else
      0.2 * parseFloat(this.state.purchase_price)

  loanAmount: ->
    parseFloat(this.state.purchase_price) - parseFloat(this.downPayment())

  cashFlow: ->
    parseFloat(this.state.monthly_rent) - parseFloat(this.monthlyExpenses())

  propertyManagementCost: ->
    this.calculatePercentCost('property_management')

  calculatePercentCost: (field) ->
    return 0 unless this.state[field]
    this.toPercent(parseInt(this.state[field])) * parseInt(this.state.monthly_rent)

  propertyTaxCost: ->
    parseInt(this.state.annual_property_taxes)/12

  toCost: (value) ->
    return 0 unless !!value
    parseFloat(value)

  toPercent: (value) ->
    value/100

  toCurrency: (value) ->
    return 0 unless value
    #value.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,')
    value

  addDollarSign: (value) ->
    "$#{value}"

  addPercentSign: (value) ->
    "#{value}%"

  render: ->
    `<div>
      <div className='row'>
        <div className='col-md-6'>
          <RentalForm {...this.state} handleChange={this.handleChange} />
        </div>
        <div className='col-md-6'>
          <div className='row'>
            <div className="col-md-6">
              <table>
                <tbody>
                  <TableRow label={'Purchase Price:'} value={this.addDollarSign(this.toCurrency(this.state.purchase_price))} />
                  <TableRow label={'Closing Costs:'} value={this.addDollarSign(this.toCurrency(this.state.closing_cost))} />
                  <TableRow label={'Repairs:'} value={this.addDollarSign(this.toCurrency(this.state.repair_cost))} />
                  <TableRow label={'Project Cost:'} value={this.addDollarSign(this.toCurrency(this.projectCost()))} />
                  <TableRow label={'After Repair Value:'} value={this.addDollarSign(this.toCurrency(this.state.after_repair_value))} />
                  <tr>
                    <td colSpan="2"><hr /></td>
                  </tr>
                  <TableRow label={'Down Payment:'} value={this.addDollarSign(this.toCurrency(this.downPayment()))} />
                  <TableRow label={'Loan Amount:'} value={this.addDollarSign(this.toCurrency(this.loanAmount()))} />
                  <TableRow label={'Loan Points:'} value={this.state.lender_points} />
                  <TableRow label={'Loan Fees:'} value={"$0"} />
                  <TableRow label={'Amoratized Over:'} value={"30 Years"} />
                  <TableRow label={'Loan Interest Rate:'} value={this.addPercentSign(this.state.interest_rate)} />
                  <TableRow label={'Monthly P&I:'} value={this.addDollarSign(this.toCurrency(this.monthlyPaymentWithInterest()))} />
                  <tr>
                    <td colSpan="2"><hr /></td>
                  </tr>
                  <tr>
                    <td><strong>Total Cash Needed:</strong></td>
                    <td><strong>${this.toCurrency(this.totalCashNeeded())}</strong></td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div className="col-md-6">
              <table>
                <tbody>
                  <TableRow label={'Monthly Income:'} value={this.toCurrency(this.state.monthly_rent)} />
                  <TableRow label={'Monthly Expenses:'} value={this.toCurrency(this.monthlyExpenses())} />
                  <tr>
                    <td colSpan="2"><hr /></td>
                  </tr>
                  <TableRow label={'Vacancy:'} value={this.toCurrency(this.calculatePercentCost('vacancy'))} />
                  <TableRow label={'Repairs:'} value={this.toCurrency(this.calculatePercentCost('repairs'))} />
                  <TableRow label={'Cap Ex:'} value={this.toCurrency(this.calculatePercentCost('capital_expenditures'))} />
                  <TableRow label={'Management:'} value={this.toCurrency(this.calculatePercentCost('property_management'))} />
                  <TableRow label={'Electricty:'} value={this.toCurrency(this.toCost(parseFloat(this.state.monthly_electricity)))} />
                  <TableRow label={'Water & Sewer:'} value={this.toCurrency(this.toCost(parseFloat(this.state.monthly_water_and_sewer)))} />
                  <TableRow label={'Garbage:'} value={this.toCurrency(this.toCost(parseFloat(this.state.garbage)))} />
                  <TableRow label={'HOA:'} value={this.toCurrency(this.toCost(parseFloat(this.state.monthly_hoa)))} />
                  <tr>
                    <td colSpan="2"><hr /></td>
                  </tr>
                  <TableRow label={'Total Operating Expenses:'} value={this.toCurrency(this.totalOperatingExpenses())} />
                  <TableRow label={'Mortagage Expense:'} value={this.addDollarSign(this.toCurrency(this.monthlyPaymentWithInterest()))} />
                  <tr>
                    <td><strong>Cash Flow:</strong></td>
                    <td><strong>${this.toCurrency(this.cashFlow())}</strong></td>
                  </tr>
                  <tr>
                    <td><strong>Cash on Cash:</strong></td>
                    <td><strong>{this.cashOnCash()}%</strong></td>
                  </tr>
                  <tr>
                    <td><strong>NOI:</strong></td>
                    <td><strong>{this.netOperatingIncome()}%</strong></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
      <RentalSaveForm {...this.state} />
    </div>`
