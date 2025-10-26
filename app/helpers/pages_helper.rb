module PagesHelper
    def companies_amount_helper(country)
        Company.where(country: country).count
    end
end
