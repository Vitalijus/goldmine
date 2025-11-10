json.extract! applicant, :id, :name, :surname, :email, :phone, :location, :linkedin_url, :github_url, :cover_letter, :expected_salary, :availability, :resume, :created_at, :updated_at
json.url applicant_url(applicant, format: :json)
