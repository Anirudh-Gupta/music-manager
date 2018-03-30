# spec/requests/todos_spec.rb
require 'rails_helper'
require 'pry'
RSpec.describe 'Bands API', type: :request do
  # initialize test data
  let!(:bands) { create_list(:band, 10) }
  let(:band_name) { bands.first.name }

  # Test suite for GET /bands
  describe 'GET /bands' do
    # make HTTP get request before each example
    before { get '/bands' }

    it 'returns bands' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /bands/:id
  describe 'GET /bands/:id' do
    before { get "/bands/#{band_name}" }

    context 'when the record exists' do
      it 'returns the band' do
        expect(json).not_to be_empty
        expect(json['name']).to eq(band_name)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:band_name) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Band/)
      end
    end
  end

  # Test suite for POST /bands
  describe 'POST /bands' do
    # valid payload
    let(:valid_attributes) { { band: {
        name: 'Pink Floyd',
        members: ['Nick Mason', 'Roger Waters',
                  'Richard Wright', 'Syd Barrett', 'David Gilmour'],
        origin: 1920} } }

    context 'when the request is valid' do
      before { post '/bands', params: valid_attributes }

      it 'creates a band' do
        expect(json['name']).to eq('pink-floyd')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/bands', params: { band: {name: 'Foobar'} } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['message'])
            .to match(/Validation failed: Members can't be blank/)
      end
    end
  end

  # Test suite for PUT /bands/:id
  describe 'PUT /bands/:id' do
    let(:valid_attributes) { { band: { name: 'Pink Floyd', members: ["David"] } } }

    context 'when the record exists' do
      before { put "/bands/#{band_name}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /bands/:id
  describe 'DELETE /bands/:id' do
    before { delete "/bands/#{band_name}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end