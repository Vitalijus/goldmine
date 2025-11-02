require 'set'
require 'csv'
require 'json'
require 'uri'
require_relative '../utils/tech_stack.rb'

# --- Run the crawler ---
# Scrapers::RubyOnRemote.new("https://rubyonremote.com/").start

module Scrapers
  class RubyOnRemote
    MAX_PAGES = 1

    def initialize(base_url)
      @base_url = base_url
      @visited = Set.new
      @matched_links = []
      @queue = [] # for breadth-first crawl
    end

    def start
      @queue << @base_url
      crawl_queue
      create_or_update_company
    end

    private

    # --- Queue-based crawler ---
    def crawl_queue
      binding.pry
      until @queue.empty? || @visited.size >= MAX_PAGES
        url = @queue.shift
        next if @visited.include?(url)
        next unless url.start_with?('https://rubyonremote.com') # internal links only

        puts "🔍 Crawling: #{url}"
        @visited << url

        begin
          response = HTTParty.get(url, timeout: 10)
          next unless response.code == 200

          doc = Nokogiri::HTML(response.body)

          # --- Extract and queue links ---
          doc.css('a[href]').each do |link|
            href = link['href']
            next unless href
            next if href.start_with?('#') # skip anchors

            full_url = make_job_url(href, url)
            next unless full_url.start_with?('https://rubyonremote.com')

            @queue << full_url unless @visited.include?(full_url)

            # --- Save job data if this is a job page ---
            if full_url.start_with?('https://rubyonremote.com/jobs/')
              extract_job_data(full_url)
            end
          end

        rescue StandardError => e
          puts "⚠️ Error on #{url}: #{e.message}"
        end
      end
    end

    # --- Extract job data from job page ---
    def extract_job_data(job_url)
      return if @matched_links.any? { |job| job[:job_url] == job_url } # avoid duplicates

      response = HTTParty.get(job_url, timeout: 10)
      return unless response.code == 200

      doc = Nokogiri::HTML(response.body)
      script_tag = doc.at('script[type="application/ld+json"]')
      return unless script_tag

      json_text = script_tag.text.strip
      json_data = JSON.parse(json_text) rescue nil
      return unless json_data

      @matched_links << build_results(json_data, job_url)
    end

    def build_results(json_data, job_url)
      description = json_data.dig("description") || ""
      {
        company_name: json_data.dig("hiringOrganization", "name"),
        company_url: json_data.dig("hiringOrganization", "sameAs"),
        countries: json_data.dig("applicantLocationRequirements")&.map{|country| country["name"]} || [],
        programming_languages: related_keywords(description, Utils::TechStack::TECH_STACK[:programming_languages]),
        frameworks: related_keywords(description, Utils::TechStack::TECH_STACK[:frameworks]),
        other_tech_stack: related_keywords(description, Utils::TechStack::TECH_STACK[:other_tech_stack]),
      }
    end

    def related_keywords(text, keywords)
      keywords.select { |word| text =~ /\b#{Regexp.escape(word)}\b/i }
    end

    def make_job_url(href, base)
      URI.join(base, href).to_s rescue href
    end

    def create_or_update_company
      puts "\n✅ Found #{@matched_links.size} job postings."
      return if @matched_links.empty?

      @matched_links.each do |job|
         company = Company.find_by(url: job[:company_url])

         if company.present?
           company.update(update_company(company, job))
         else
           Company.create!(create_company(job))
         end
      end

      def update_company(company, job)
        {
          programming_languages: (company.programming_languages + job[:programming_languages]).uniq,
          frameworks: (company.frameworks + job[:frameworks]).uniq,
          other_tech_stack: (company.other_tech_stack + job[:other_tech_stack]).uniq,
          countries: (company.countries + job[:countries]).uniq
        }
      end

      def create_company(job)
        {
          name: job[:company_name],
          url: job[:company_url],
          programming_languages: job[:programming_languages],
          frameworks: job[:frameworks],
          other_tech_stack: job[:other_tech_stack],
          countries: job[:countries]
        }
      end
    end
  end
end
