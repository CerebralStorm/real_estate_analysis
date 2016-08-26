class @RentalSaveForm extends React.Component
  id: ->
    if this.props.id
      "edit_rental_calculation"
    else
      "new_rental_calculation"

  action: ->
    if this.props.id
      "PATCH"
    else
      "POST"

  render: ->
    `<form class="new_rental_calculation" id={this.id()} action="/rental_calculations" accept-charset="UTF-8" method={this.action()}>
      <input type='hidden' name="listing_id" value={this.props.listing_id} />
      <HiddenInput name={"id"} value={this.props.id} />
      <HiddenInput name={"listing_id"} value={this.props.listing_id} />
      <HiddenInput name={"purchase_price"} value={this.props.purchase_price} />
      <HiddenInput name={"after_repair_value"} value={this.props.after_repair_value} />
      <HiddenInput name={"closing_cost"} value={this.props.closing_cost} />
      <HiddenInput name={"repair_cost"} value={this.props.repair_cost} />
      <HiddenInput name={"interest_rate"} value={this.props.interest_rate} />
      <HiddenInput name={"other_lender_charges"} value={this.props.other_lender_charges} />
      <HiddenInput name={"lender_points"} value={this.props.lender_points} />
      <HiddenInput name={"down_payment"} value={this.props.down_payment} />
      <HiddenInput name={"loan_amount"} value={this.props.loan_amount} />
      <HiddenInput name={"loan_duration"} value={this.props.loan_duration} />
      <HiddenInput name={"vacancy"} value={this.props.vacancy} />
      <HiddenInput name={"repairs"} value={this.props.repairs} />
      <HiddenInput name={"capital_expenditures"} value={this.props.capital_expenditures} />
      <HiddenInput name={"property_management"} value={this.props.property_management} />
      <HiddenInput name={"annual_income_growth"} value={this.props.annual_income_growth} />
      <HiddenInput name={"annual_expense_growth"} value={this.props.annual_expense_growth} />
      <HiddenInput name={"sales_expense"} value={this.props.sales_expense} />
      <HiddenInput name={"annual_property_taxes"} value={this.props.annual_property_taxes} />
      <HiddenInput name={"annual_property_value_growth"} value={this.props.annual_property_value_growth} />
      <HiddenInput name={"monthly_rent"} value={this.props.monthly_rent} />
      <HiddenInput name={"monthly_electricity"} value={this.props.monthly_electricity} />
      <HiddenInput name={"monthly_water_and_sewer"} value={this.props.monthly_water_and_sewer} />
      <HiddenInput name={"private_mortagage_insurance"} value={this.props.private_mortagage_insurance} />
      <HiddenInput name={"garbage"} value={this.props.garbage} />
      <HiddenInput name={"monthly_hoa"} value={this.props.monthly_hoa} />
      <HiddenInput name={"other_monthly_costs"} value={this.props.other_monthly_costs} />
      <input type="submit" name="commit" value="Create Rental calculation" data-disable-with="Create Rental calculation" />
    </form>`
