class CareersController < ApplicationController
  before_action :set_career, only: %i[ show edit update destroy ]
  before_action :check_secret_key, only: [:new, :create, :edit, :update]

  # GET /careers or /careers.json
  def index
    @careers = Career.all
  end

  # GET /careers/1 or /careers/1.json
  def show
  end

  # GET /careers/new
  def new
    @career = Career.new
  end

  # GET /careers/1/edit
  def edit
  end

  # POST /careers or /careers.json
  def create
    @career = Career.new(career_params)

    respond_to do |format|
      if @career.save
        format.html { redirect_to @career, notice: "Career was successfully created." }
        format.json { render :show, status: :created, location: @career }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @career.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /careers/1 or /careers/1.json
  def update
    respond_to do |format|
      if @career.update(career_params)
        format.html { redirect_to @career, notice: "Career was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @career }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @career.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /careers/1 or /careers/1.json
  def destroy
    @career.destroy!

    respond_to do |format|
      format.html { redirect_to careers_path, notice: "Career was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Protect some urls with a Secret Token, because auth like devise is not installed.
    def check_secret_key
      expected_key = Rails.application.credentials.admin_key! rescue ENV["ADMIN_KEY"]
      unless params[:key] == expected_key
        render plain: "Access denied", status: :unauthorized
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_career
      @career = Career.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def career_params
      params.expect(career: [ :title, :about_us, :about_role, :reqs, :our_culture, :how_to_apply, :location, :employment_type, :salary_range, :active ])
    end
end
