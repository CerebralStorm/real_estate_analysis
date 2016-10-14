@RentalCalculator = React.createClass

  getInitialState: ->
    this.props

  handleChange: (event) ->
    this.setState({"#{event.target.name}": event.target.value})

  projectCost: ->
    parseInt(this.state.purchase_price) + parseInt(this.state.closing_cost) + parseInt(this.state.repair_cost)

  monthlyPaymentWithInterest: ->
    term = 12 * this.state.loan_duration
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
    total += parseFloat(this.state.monthly_electricity) unless isNaN(parseFloat(this.state.monthly_electricity))
    total += parseFloat(this.state.monthly_water_and_sewer) unless isNaN(parseFloat(this.state.monthly_water_and_sewer))
    total += parseFloat(this.state.private_mortagage_insurance) unless isNaN(parseFloat(this.state.private_mortagage_insurance))
    total += parseFloat(this.state.garbage) unless isNaN(parseFloat(this.state.garbage))
    total += parseFloat(this.state.monthly_hoa) unless isNaN(parseFloat(this.state.monthly_hoa))
    total += parseFloat(this.state.other_monthly_costs) unless isNaN(parseFloat(this.state.other_monthly_costs))
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

  toPercent: (value) ->
    value/100

  expectedRent: ->
    this.loanAmount() * 0.008

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
                  <TableRow label={'Purchase Price:'} prefix={'$'} value={this.state.purchase_price} />
                  <TableRow label={'Closing Costs:'} prefix={'$'} value={this.state.closing_cost} />
                  <TableRow label={'Repairs:'} prefix={'$'} value={this.state.repair_cost} />
                  <TableRow label={'Project Cost:'} prefix={'$'} value={this.projectCost()} />
                  <TableRow label={'After Repair Value:'} prefix={'$'} value={this.state.after_repair_value || this.state.purchase_price} />
                  <tr>
                    <td colSpan="2"><hr /></td>
                  </tr>
                  <TableRow label={'Down Payment:'} prefix={'$'} value={this.downPayment()} />
                  <TableRow label={'Loan Amount:'} prefix={'$'} value={this.loanAmount()} />
                  <TableRow label={'Loan Points:'} value={this.state.lender_points} />
                  <TableRow label={'Loan Fees:'} prefix={'$'} value={"0"} />
                  <TableRow label={'Amoratized Over:'} value={this.state.loan_duration + " Years"} />
                  <TableRow label={'Loan Interest Rate:'} suffix={'%'} value={this.state.interest_rate} />
                  <TableRow label={'Monthly P&I:'} prefix={'$'} value={this.monthlyPaymentWithInterest()} />
                  <tr>
                    <td colSpan="2"><hr /></td>
                  </tr>
                  <tr>
                    <td><strong>Total Cash Needed:</strong></td>
                    <td><strong>${this.totalCashNeeded()}</strong></td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div className="col-md-6">
              <table>
                <tbody>
                  <TableRow label={'0.8% Rule:'} prefix={'$'} value={this.expectedRent()} />
                  <TableRow label={'Monthly Income:'} prefix={'$'} value={this.state.monthly_rent} />
                  <TableRow label={'Monthly Expenses:'} prefix={'$'} value={this.monthlyExpenses()} />
                  <tr>
                    <td colSpan="2"><hr /></td>
                  </tr>
                  <TableRow label={'Vacancy:'} prefix={'$'} value={this.calculatePercentCost('vacancy')} />
                  <TableRow label={'Repairs:'} prefix={'$'} value={this.calculatePercentCost('repairs')} />
                  <TableRow label={'Cap Ex:'} prefix={'$'} value={this.calculatePercentCost('capital_expenditures')} />
                  <TableRow label={'Management:'} value={this.calculatePercentCost('property_management')} />
                  <TableRow label={'Electricty:'} value={this.state.monthly_electricity} />
                  <TableRow label={'Water & Sewer:'} value={this.state.monthly_water_and_sewer} />
                  <TableRow label={'Garbage:'} value={this.state.garbage} />
                  <TableRow label={'HOA:'} value={this.state.monthly_hoa} />
                  <tr>
                    <td colSpan="2"><hr /></td>
                  </tr>
                  <TableRow label={'Total Operating Expense:'} addon={'$'} value={this.totalOperatingExpenses()} />
                  <TableRow label={'Mortagage Expense:'} addon={'$'} value={this.monthlyPaymentWithInterest()} />
                  <tr>
                    <td><strong>Cash Flow:</strong></td>
                    <td><strong>${this.cashFlow().toFixed(2)}</strong></td>
                  </tr>
                  <tr>
                    <td><strong>Cash on Cash:</strong></td>
                    <td><strong>{this.cashOnCash().toFixed(2)}%</strong></td>
                  </tr>
                  <tr>
                    <td><strong>NOI:</strong></td>
                    <td><strong>${this.netOperatingIncome().toFixed(2)}</strong></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>`
