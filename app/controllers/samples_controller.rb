class SamplesController < ApplicationController
  before_action :load_countries, only: %i[new create]
    
  # GET /samples/new
  def new
    @sample = Sample.new
    # Dynamically set form action URL based on presence of search parameters
    @form_action_url = new_sample_path
  end

  # POST /samples or /samples.json
  def create
    @sample = Sample.new(sample_params)

    respond_to do |format|
      if @sample.save
        SampleMailer.download_sample_email(@sample).deliver_now

        format.html { redirect_to new_sample_path, notice: "Sample request successfully created." }
        format.json { render :new, status: :created, location: @sample }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Load countries for form selection
  def load_countries
    get_countries = Opensearch::GetCountriesQuery.new(
      countries: params[:countries],
      frameworks: params[:frameworks],
      languages: params[:programming_languages],
      other_tech: params[:other_tech_stack],
      remote: params[:remote],
      size: 10
    )

    @countries = get_countries.build_result
  end

  # Only allow a list of trusted parameters through.
  def sample_params
    params.expect(sample: [ :email, programming_languages: [], frameworks: [], other_tech_stack: [], countries: [] ])
  end
end