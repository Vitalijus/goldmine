module CareersHelper
  def total_roles
    Career.all.count
  end
end
