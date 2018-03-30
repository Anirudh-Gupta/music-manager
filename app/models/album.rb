class Album < ApplicationRecord
  # model association
  belongs_to :band

  # validation
  validates_presence_of :title, :band_id

  def to_param
    title
  end

  def self.formatted_name(name)
    name.split(" ").map(&:downcase).join("-")
  end
end
