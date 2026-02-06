class PagesController < ApplicationController
  include PagesHelper

  ALLOWED_REDIRECT_HOSTS = %w[
    buy.stripe.com
  ].freeze

  def safe_redirect_url(url)
    uri = URI.parse(url)

    unless ALLOWED_REDIRECT_HOSTS.include?(uri.host)
      raise ActionController::BadRequest, "Invalid redirect host"
    end

    uri.to_s
  end

  # Actions
  def home
    get_countries = Opensearch::GetCountriesQuery.new(countries: params[:countries],
                                                      frameworks: params[:frameworks],
                                                      languages: params[:programming_languages],
                                                      other_tech: params[:other_tech_stack],
                                                      remote: params[:remote],
                                                      size: 10)
    @countries = get_countries.build_result
    @total_us_companies = @countries.find { |item| item[:country] == "United States" }&.dig(:total_companies)

    # Dynamically set form action URL based on presence of search parameters
    @form_action_url = home_path
  end

  def checkout
    if params[:country].present? && params[:stripe_payment_link].present?
      payment = Payment.create(countries: [ISO3166::Country.find_country_by_any_name(params[:country]).alpha2],
                               programming_languages: params[:programming_languages] || [],
                               frameworks: params[:frameworks] || [],
                               other_tech_stack: params[:other_tech_stack] || [],
                               remote: params[:remote] || nil )

      safe_url = safe_redirect_url(params[:stripe_payment_link])
      redirect_to("#{safe_url}?client_reference_id=#{payment.id}", allow_other_host: true) if payment
    else
      redirect_back(fallback_location: search_path, alert: "Redirect to checkout is unsuccessfull. Please contact support.")
    end
  end

  # export companies list
  def download
    begin
      # Ensure :id param exists
      return render plain: "Missing download ID.", status: :bad_request unless params[:id].present?

      payment_id = params[:id]
      @payment = Payment.find_by(id: payment_id)

      # Handle missing payment
      return render plain: "File not found. Please contact support.", status: :not_found unless @payment

      # Safely generate CSV (rescue inside block)
      csv_data = begin
        companies_export_file_helper(@payment)
      rescue => e
        Rails.logger.error "CSV generation failed: #{e.class} - #{e.message}"
        return render plain: "Unable to generate file. Please contact support.", status: :internal_server_error
      end

      # Send CSV normally
      respond_to do |format|
        format.csv do
          send_data csv_data,
            filename: "companies_list.csv",
            type: "text/csv",
            disposition: "attachment"
        end
      end

    rescue => e
      # Catch any unexpected errors
      Rails.logger.error "Download error: #{e.class} - #{e.message}"
      render plain: "An error occurred. Please try again or contact support.", status: :internal_server_error
    end
  end
end
