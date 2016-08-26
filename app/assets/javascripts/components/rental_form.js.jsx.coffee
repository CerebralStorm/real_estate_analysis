class @RentalForm extends React.Component
  render: ->
    `<div>
      <div className='row'>
        <div className='col-md-4'>
          <Panel header={'Property Information'}>
            <FormGroup label={'Purchase Price'} defaultValue={this.props.purchase_price} handleChange={this.props.handleChange} name={'purchase_price'} />
            <FormGroup label={'After Repair Value'} defaultValue={this.props.after_repair_value} handleChange={this.props.handleChange} name={'after_repair_value'} />
            <FormGroup label={'Annual Property Taxes'} defaultValue={this.props.annual_property_taxes} handleChange={this.props.handleChange} name={'annual_property_taxes'} />
            <FormGroup label={'Monthly Rent'} defaultValue={this.props.monthly_rent} handleChange={this.props.handleChange} name={'monthly_rent'} />
          </Panel>
        </div>

        <div className='col-md-4'>
          <Panel header={'Loan Information'}>
            <FormGroup label={'Loan Amount'} defaultValue={this.props.loan_amount} handleChange={this.props.handleChange} name={'loan_amount'} />
            <FormGroup label={'Loan Duration'} defaultValue={this.props.loan_duration} handleChange={this.props.handleChange} name={'loan_duration'} />
            <FormGroup label={'Interest Rate'} defaultValue={this.props.interest_rate} handleChange={this.props.handleChange} name={'interest_rate'} />
            <FormGroup label={'Down Payment'} defaultValue={this.props.down_payment} handleChange={this.props.handleChange} name={'down_payment'} />
          </Panel>
        </div>

        <div className='col-md-4'>
          <Panel header={'Fees'}>
            <FormGroup label={'Closing Cost'} defaultValue={this.props.closing_cost} handleChange={this.props.handleChange} name={'closing_cost'} />
            <FormGroup label={'Repair Cost'} defaultValue={this.props.repair_cost} handleChange={this.props.handleChange} name={'repair_cost'} />
            <FormGroup label={'Lender Points'} defaultValue={this.props.lender_points} handleChange={this.props.handleChange} name={'lender_points'} />
            <FormGroup label={'Other Lender Charges'} defaultValue={this.props.other_lender_charges} handleChange={this.props.handleChange} name={'other_lender_charges'} />
          </Panel>
        </div>
      </div>

      <div className='row'>
        <div className='col-md-4'>
          <Panel header={'Maintanence Costs'}>
            <FormGroup label={'Vacancy (%)'} defaultValue={this.props.vacancy} handleChange={this.props.handleChange} name={'vacancy'} />
            <FormGroup label={'Repairs (%)'} defaultValue={this.props.repairs} handleChange={this.props.handleChange} name={'repairs'} />
            <FormGroup label={'Capital Expenditures (%)'} defaultValue={this.props.capital_expenditures} handleChange={this.props.handleChange} name={'capital_expenditures'} />
            <FormGroup label={'Property Management (%)'} defaultValue={this.props.property_management} handleChange={this.props.handleChange} name={'property_management'} />
          </Panel>
        </div>

        <div className='col-md-4'>
          <Panel header={'Fixed Landlord-Paid Expenses'}>
            <FormGroup label={'Monthly Electricity'} defaultValue={this.props.monthly_electricity} handleChange={this.props.handleChange} name={'monthly_electricity'} />
            <FormGroup label={'Monthly Water & Sewer'} defaultValue={this.props.monthly_water_and_sewer} handleChange={this.props.handleChange} name={'monthly_water_and_sewer'} />
            <FormGroup label={'PMI'} defaultValue={this.props.private_mortagage_insurance} handleChange={this.props.handleChange} name={'private_mortagage_insurance'} />
            <FormGroup label={'Garbage'} defaultValue={this.props.garbage} handleChange={this.props.handleChange} name={'garbage'} />
            <FormGroup label={'HOA'} defaultValue={this.props.monthly_hoa} handleChange={this.props.handleChange} name={'monthly_hoa'} />
            <FormGroup label={'Other Monthly Costs'} defaultValue={this.props.other_monthly_costs} handleChange={this.props.handleChange} name={'other_monthly_costs'} />
          </Panel>
        </div>

        <div className='col-md-4'>
          <Panel header={'Future Projections'}>
            <FormGroup label={'Annual Income Growth (%)'} defaultValue={this.props.annual_income_growth} handleChange={this.props.handleChange} name={'annual_income_growth'} />
            <FormGroup label={'Annual Property Value Growth (%)'} defaultValue={this.props.annual_property_value_growth} handleChange={this.props.handleChange} name={'annual_property_value_growth'} />
            <FormGroup label={'Annual Expense Growth'} defaultValue={this.props.annual_expense_growth} handleChange={this.props.handleChange} name={'annual_expense_growth'} />
            <FormGroup label={'Sales Expense'} defaultValue={this.props.sales_expense} handleChange={this.props.handleChange} name={'sales_expense'} />
          </Panel>
        </div>
      </div>
    </div>`
