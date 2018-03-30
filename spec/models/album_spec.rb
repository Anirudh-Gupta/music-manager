require 'rails_helper'

RSpec.describe Album, type: :model do
  # Association test
  # ensure an album record belongs to a single band record
  it { should belong_to(:band) }
  # Validation test
  # ensure column name and band_id is present before saving
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:band_id) }
end
