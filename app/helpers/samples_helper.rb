module SamplesHelper
  # Returns an array of companies for a given sample
  # Limit results to first 10 for email display
  def companies_for_sample(sample, limit: 10)
    return [] unless sample

    companies_query = Opensearch::CompaniesToCsvQuery.new(
      countries: sample.countries,
      languages: sample.programming_languages,
      frameworks: sample.frameworks,
      other_tech: sample.other_tech_stack,
      remote: true
    )

    companies_query.build_result.first(limit)
  end 
end
