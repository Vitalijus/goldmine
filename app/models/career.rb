class Career < ApplicationRecord
  has_many :applicants, dependent: :destroy
end
