class ApplicantsController < ApplicationController
  before_action :set_career
  before_action :set_applicant, only: %i[ show edit update destroy ]

  # GET /applicants or /applicants.json
  def index
    @applicants = Applicant.all
  end

  # GET /applicants/1 or /applicants/1.json
  def show
  end

  # GET /applicants/new
  def new
    @applicant = @career.applicants.new
    # @applicant = Applicant.new
  end

  # GET /applicants/1/edit
  def edit
  end

  # POST /applicants or /applicants.json
  def create
    @applicant = @career.applicants.new(applicant_params)

    respond_to do |format|
      if @applicant.save
        format.html { redirect_to @career, notice: "Application submitted successfully." }
        format.json { render :show, status: :created, location: @career }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @applicant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /applicants/1 or /applicants/1.json
  def update
    respond_to do |format|
      if @applicant.update(applicant_params)
        format.html { redirect_to @applicant, notice: "Application updated successfully.", status: :see_other }
        format.json { render :show, status: :ok, location: @applicant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @applicant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applicants/1 or /applicants/1.json
  def destroy
    @applicant.destroy!

    respond_to do |format|
      format.html { redirect_to applicants_path, notice: "Applicant was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_career
      @career = Career.find(params[:career_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_applicant
      @applicant = @career.applicants.find(params[:id])
      # @applicant = Applicant.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def applicant_params
      params.expect(applicant: [ :name, :surname, :email, :phone, :country, :city, :linkedin_url, :github_url, :cover_letter, :expected_salary, :availability, :resume ])
    end
end
