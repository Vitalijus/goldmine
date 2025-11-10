class Applicant < ApplicationRecord
  belongs_to :career

  validates :name, :surname, :email, :country, :city, :resume, presence: true
end
