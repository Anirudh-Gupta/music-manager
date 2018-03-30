require 'rails_helper'

RSpec.describe 'Albums API' do
  # Initialize the test data
  let!(:band) { create(:band) }
  let!(:albums) { create_list(:album, 20, band_id: band.id) }
  let(:band_name) { band.name}
  let(:id) { albums.first.id }
  let(:name) { albums.first.title }

  # Test suite for GET /bands/:band_id/albums
  describe 'GET /bands/:band_id/albums' do
    before { get "/bands/#{band_name}/albums" }

    context 'when album exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all albums' do
        expect(json.size).to eq(20)
      end
    end

    context 'when band does not exist' do
      let(:band_name) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Band/)
      end
    end
  end

  # Test suite for GET /bands/:band_id/albums/:id
  describe 'GET /bands/:band_id/albums/:id' do
    before { get "/bands/#{band_name}/albums/#{name}" }

    context 'when band exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the album' do
        expect(json['title']).to eq(name)
      end
    end

    context 'when album does not exist' do
      let(:name) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Album/)
      end
    end
  end

  # Test suite for PUT /bands/:band_id/albums
  describe 'POST /bands/:band_id/albums' do
    let(:valid_attributes) { { album: {title: 'Pulse' } } }

    context 'when request attributes are valid' do
      before { post "/bands/#{band_name}/albums", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

  end

  # Test suite for PUT /bands/:band_id/albums/:id
  describe 'PUT /bands/:band_id/albums/:id' do
    let(:valid_attributes) { { album: { title: 'Pulse' } } }

    before { put "/bands/#{band_name}/albums/#{name}", params: valid_attributes }

    context 'when album exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the album' do
        updated_album = Album.find(id)
        expect(updated_album.title).to match(/pulse/)
      end
    end

    context 'when the album does not exist' do
      let(:name) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Album/)
      end
    end
  end

  # Test suite for DELETE /bands/:id
  describe 'DELETE /bands/:id' do
    before { delete "/bands/#{band_name}/albums/#{name}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end