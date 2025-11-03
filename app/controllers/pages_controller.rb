class PagesController < ApplicationController
  include PagesHelper

  # Only files allowed to download.
  # Each file corresponds to stripe product id.
  ALLOWED_FILES = {
      "usa" => {
        path: Rails.root.join("private/usa_rails.pdf"),
        stripe_product_id: ENV.fetch("STRIPE_PRODUCT_ID_USA")
      },
      "united_kingdom" => {
        path: Rails.root.join("private/united_kingdom_rails.pdf"),
        stripe_product_id: ENV.fetch("STRIPE_PRODUCT_ID_UK")
      },
      "canada" => {
        path: Rails.root.join("private/canada_rails.pdf"),
        stripe_product_id: ENV.fetch("STRIPE_PRODUCT_ID_CANADA")
      }
    }.freeze

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
    payment_id = params[:id]
    @payment = Payment.find_by(id: payment_id)
    stripe_product_id = @payment&.stripe_product_id

    file_entry = ALLOWED_FILES.values.find do |entry|
      entry[:stripe_product_id] == stripe_product_id
    end

    if file_entry
      file_path = file_entry[:path]

      send_file file_path, filename: "railslist.pdf", type: "application/pdf", disposition: "inline"
    else
      render plain: "File not found for the given product ID. Please contact support.", status: :not_found
    end
  end
end
