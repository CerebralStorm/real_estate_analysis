class RentalCalculationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_listing, only: [:index, :new]

  def index
    @rental_calculations = @listing.rental_calculations
  end

  def show
    @rental_calculation = RentalCalculation.find(params[:id])
  end

  def new
    @rental_calculation = RentalCalculation.new(
      listing_id: @listing.id,
      purchase_price: @listing.listing_price,
      loan_amount: @listing.loan_amount,
      down_payment: @listing.down_payment,
      vacancy: 5,
      interest_rate: (@listing.thirty_year_fixed_interest_rate || 3.5),
      loan_duration: 30,
      capital_expenditures: 5,
      repair_cost: 5000,
      closing_cost: 2500,
      property_management: 10,
      monthly_rent: @listing.avg_rent,
      repairs: 10,
      annual_income_growth: 2,
      sales_expense: 7,
      annual_property_value_growth: 3,
      annual_expense_growth: 3,
      annual_property_taxes: 1600,
      monthly_electricity: 80,
      monthly_water_and_sewer: 30,
      private_mortagage_insurance: 0,
      garbage: 10,
      monthly_hoa: 0,
      other_monthly_costs: 40,
      )
  end

  def edit
    @rental_calculation = RentalCalculation.find(params[:id])
  end

  def create
    @rental_calculation = RentalCalculation.new(rental_calculation_params)

    respond_to do |format|
      if @rental_calculation.save
        format.html { redirect_to @rental_calculation, notice: 'RentalCalculation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @rental_calculation }
      else
        format.html { render action: 'new' }
        format.json { render json: @rental_calculation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @rental_calculation = RentalCalculation.find(params[:id])
    respond_to do |format|
      if @rental_calculation.update(rental_calculation_params)
        format.html { redirect_to @rental_calculation, notice: 'RentalCalculation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @rental_calculation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @rental_calculation = RentalCalculation.find(params[:id])
    @rental_calculation.destroy
    respond_to do |format|
      format.html { redirect_to listings_url }
      format.json { head :no_content }
    end
  end

  private

    def set_listing
      @listing = Listing.find(params[:listing_id])
    end

    def rental_calculation_params
      params.require(:rental_calculation).permit(
        :listing_id,
        :purchase_price,
        :after_repair_value,
        :closing_cost,
        :repair_cost,
        :interest_rate,
        :other_lender_charges,
        :lender_points,
        :down_payment,
        :loan_amount,
        :loan_duration,
        :vacancy,
        :repairs,
        :capital_expenditures,
        :property_management,
        :annual_income_growth,
        :appreciation,
        :annual_expense_growth,
        :sales_expense,
        :annual_property_taxes,
        :annual_property_value_growth,
        :monthly_rent,
        :monthly_electricity,
        :monthly_water_and_sewer,
        :private_mortagage_insurance,
        :garbage,
        :monthly_hoa,
        :other_monthly_costs
      )
    end
end




























