require 'rails_helper'

RSpec.describe Band, type: :model do

  # Association test
  # ensure Band model has a 1:m relationship with the  Album model
  it { should have_many(:albums).dependent(:destroy) }

  # Validation tests
  # ensure columns name and members are present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:members) }
end
