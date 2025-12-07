class PagesController < ApplicationController
  include PagesHelper

  def home
    @top_countries = Opensearch::TopCountriesQuery.new.build_result
  end

  def search
    get_countries = Opensearch::GetCountriesQuery.new(countries: params[:countries],
                                                      frameworks: params[:frameworks],
                                                      languages: params[:programming_languages],
                                                      other_tech: params[:other_tech_stack],
                                                      remote: params[:remote])
    @countries = get_countries.build_result
  end

  def checkout
    if params[:country].present? && params[:stripe_payment_link].present?
      payment = Payment.create(countries: [params[:country]],
                               programming_languages: params[:programming_languages] || [],
                               frameworks: params[:frameworks] || [],
                               other_tech_stack: params[:other_tech_stack] || [],
                               remote: nil) # TO DO

      redirect_to params[:stripe_payment_link] + "?client_reference_id=#{payment.id}", allow_other_host: true if payment
    else
      redirect_back(fallback_location: search_path, alert: "Redirect to checkout is unsuccessfull.")
    end
  end

  # export sample CSV
  def export
    return unless params[:countries]

    countries = params[:countries].map{ |country| country.downcase }
    csv_data = companies_sample_file_helper(params[:countries])

    respond_to do |format|
      format.csv do
        send_data csv_data,
          filename: "sample.csv",
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

    if @payment
      csv_data = companies_export_file_helper(@payment)

      respond_to do |format|
        format.csv do
          send_data csv_data,
            filename: "companies_list.csv",
            type: "text/csv",
            disposition: "attachment"  # forces download
        end
      end
    else
      render plain: "File not found. Please contact support.", status: :not_found
    end
  end
end
