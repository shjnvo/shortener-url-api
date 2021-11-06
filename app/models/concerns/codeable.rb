module Codeable
  extend ActiveSupport::Concern

  # The length of the result string is about 4/3 of n
  def generate_code(column_name, n = 64)
    attribute = {}
    attribute[column_name] = SecureRandom.urlsafe_base64 n
    self.assign_attributes(attribute)
    generate_token if self.class.exists?(attribute)
    self
  end

  def generate_code!(column_name, n = 64)
    generate_code(column_name, n).save!
  end
end