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
        country: "UK",
        stripe_product_id: ENV.fetch("STRIPE_PRODUCT_ID_UK")
      },
      {
        country: "CA",
        stripe_product_id: ENV.fetch("STRIPE_PRODUCT_ID_CANADA")
      }
    ].freeze

  def home
  end

  def careers
  end

  # export sample CSV
  def export
    return unless params[:countries]

    countries = params[:countries].map{ |country| country.downcase }
    csv_data = companies_sample_file_helper(params[:countries])

    respond_to do |format|
      format.csv do
        send_data csv_data,
          filename: "#{countries.join("_")}_sample.csv",
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
    country = file_entry[:country]
    csv_data = companies_export_file_helper(country)

    if file_entry
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
