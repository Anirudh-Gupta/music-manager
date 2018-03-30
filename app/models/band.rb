class Band < ApplicationRecord
  # model association
  has_many :albums, dependent: :destroy

  # validations
  validates_presence_of :name, :members

  serialize :members

  def to_param
    name
  end

end
