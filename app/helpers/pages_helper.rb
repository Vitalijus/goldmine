module PagesHelper
    def companies_amount_helper(countries)
        Company.where(countries: countries).count
    end
end
