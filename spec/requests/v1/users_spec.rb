require 'rails_helper'

RSpec.describe 'V1::Users', type: :request do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let(:user_token) { JwtService.encode({ user_token: user.generate_token! }) }

  describe 'GET /v1/users/:id' do
    context 'with user' do
      it 'returns http success' do
        get "/v1/users/#{user.id}", headers: { 'Authentication': user_token }
        data = JSON.parse(response.body)['data']
        expect(response).to have_http_status(:success)
        expect(data['email']).to eq user.email
      end
    end
  end

  describe 'POST /v1/users' do
    context 'with user' do
      it 'returns http ok' do
        params = { name: 'test_name', email: 'test_email@gmail.com', password: '12345678'}
        post '/v1/users', headers: { 'Authentication': user_token }, params: params
        expect(response).to have_http_status(:success)
        expect(User.find_by(email: 'test_email@gmail.com')).to be_truthy
      end
    end
  end

  describe 'PATCH /v1/update' do
    context 'with user' do
      it 'returns http ok' do
        patch "/v1/users/#{user.id}", headers: { 'Authentication': user_token }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE /v1/users/:id' do
    context 'with user' do
      it 'returns http ok' do
        delete "/v1/users/#{user.id}", headers: { 'Authentication': user_token }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PATCH /v1/users/:id/lock' do
    context 'with user' do
      it 'returns http ok' do
        patch "/v1/users/#{user.id}/lock", headers: { 'Authentication': user_token }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PATCH /v1/users/:id/unlock' do
    context 'with user' do
      it 'returns http ok' do
        patch "/v1/users/#{user.id}/unlock", headers: { 'Authentication': user_token }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
