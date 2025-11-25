class PagesController < ApplicationController
  include PagesHelper

  # Only files allowed to download.
  # Each file corresponds to stripe product id.
  ALLOWED_FILES = [
      {
        country: "US",
        stripe_product_id: ENV.fetch("STRIPE_PRODUCT_ID_USA")
      },
      {
        country: "GB",
        stripe_product_id: ENV.fetch("STRIPE_PRODUCT_ID_UK")
      },
      {
        country: "CA",
        stripe_product_id: ENV.fetch("STRIPE_PRODUCT_ID_CANADA")
      },
      {
        country: "AU",
        stripe_product_id: ENV.fetch("STRIPE_PRODUCT_ID_AUSTRALIA")
      }
    ].freeze

  def home
    @companies = Company.all
  end

  def search
    # binding.pry
    params[:countries]
    params[:frameworks]
    params[:programming_languages]
    params[:other_tech_stack]
    redirect_to root_path, notice: "Search submitted!"
  end

  # export sample CSV
  def export
    return unless params[:countries]

    countries = params[:countries].map{ |country| country.downcase }
    csv_data = companies_sample_file_helper(params[:countries])

    respond_to do |format|
      format.csv do
        send_data csv_data,
          filename: "ror_sample.csv",
          type: "text/csv",
          disposition: "attachment"  # forces download
      end
    end
  end

  # export companies list
  def download
    return unless params[:id]

    payment_id = params[:id]
    @payment = Payment.find_by(id: payment_id)
    stripe_product_id = @payment&.stripe_product_id
    file_entry = ALLOWED_FILES.find do |entry|
      entry[:stripe_product_id] == stripe_product_id
    end

    if file_entry
      country = file_entry[:country]
      languages = ["Ruby"]
      frameworks = ["Ruby on Rails"]
      csv_data = companies_export_file_helper(country, languages, frameworks)

      respond_to do |format|
        format.csv do
          send_data csv_data,
            filename: "#{country.downcase}_list.csv",
            type: "text/csv",
            disposition: "attachment"  # forces download
        end
      end
    else
      render plain: "File not found for the given product ID. Please contact support.", status: :not_found
    end
  end
end
