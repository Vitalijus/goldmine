class SamplesController < ApplicationController
  def new
    @sample = Sample.new
    get_countries = Opensearch::GetCountriesQuery.new(countries: params[:countries],
                                                      frameworks: params[:frameworks],
                                                      languages: params[:programming_languages],
                                                      other_tech: params[:other_tech_stack],
                                                      remote: params[:remote],
                                                      size: 10)
    @countries = get_countries.build_result
  end

  def create
    @sample = Sample.new(sample_params)

    respond_to do |format|
      if @sample.save
        format.html { redirect_to new_sample_path, notice: "Sample request successfully created." }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end
end
