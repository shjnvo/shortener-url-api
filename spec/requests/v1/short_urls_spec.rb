require 'rails_helper'

RSpec.describe "V1::ShortUrls", type: :request do
  let!(:user) { create(:user) }
  let!(:user_token) { JwtService.encode({ user_token: user.generate_token! }) }
  let!(:user_access_key) { user.generate_access_key! }
  let!(:list_short_url) { create_list(:short_url, 25, user: user) }
  let!(:short_url_id) { ShortUrl.last.id }
  let!(:short_url) { ShortUrl.last }


  describe "GET /v1/short_urls" do
    it "returns http unauthorized" do
      get "/v1/short_urls"
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success with user" do
      get "/v1/short_urls", headers: { 'Authentication': user_token }
      expect(response).to have_http_status(:success)
    end

    it "returns http success with access_key" do
      get "/v1/short_urls", headers: { 'X-AccessKey': user_access_key }
      expect(response).to have_http_status(:success)
    end

    it "returns http success" do
      get "/v1/short_urls?page=2", headers: { 'Authentication': user_token }
      body = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(body['data'].size).to eq 10
      expect(body['current_page']).to eq 2
    end
  end

  describe "PATCH /v1/short_urls/:id" do
    it "returns http unauthorized" do
      patch "/v1/short_urls/#{short_url_id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http unauthorized with access_key" do
      patch "/v1/short_urls/#{short_url_id}", headers: { 'X-AccessKey': user_access_key }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success update [url] valid " do
      params = { url: 'https://google.com' }
      patch "/v1/short_urls/#{short_url_id}", headers: { 'Authentication': user_token }, params: params

      short_url = ShortUrl.find(short_url_id)
      expect(response).to have_http_status(:success)
      expect(short_url.url).to eq params[:url]
    end

    it "returns http bad_request update [url] invalid" do
      params = { url: 'google.com' }
      patch "/v1/short_urls/#{short_url_id}", headers: { 'Authentication': user_token }, params: params

      short_url = ShortUrl.find(short_url_id)
      expect(response).to have_http_status(:bad_request)
      expect(short_url.url).to_not eq params[:url]
    end
  end

  describe "POST /v1/short_urls" do
    it "returns http unauthorized" do
      post "/v1/short_urls"
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success with access_key [url] valid" do
      params = { url: 'https://google.com' }
      post "/v1/short_urls", headers: { 'X-AccessKey': user_access_key }, params: params
      expect(response).to have_http_status(:success)
      expect(ShortUrl.find_by(url: params[:url])).to be_truthy
    end

    it "returns http bad_request with access_key [url] invalid" do
      params = { url: 'google.com' }
      post "/v1/short_urls", headers: { 'X-AccessKey': user_access_key }, params: params

      expect(response).to have_http_status(:bad_request)
    end

    it "returns http success with user_token [url] valid" do
      params = { url: 'https://google.com' }
      post "/v1/short_urls", headers: { 'Authentication': user_token }, params: params
      expect(response).to have_http_status(:success)
      expect(ShortUrl.find_by(url: params[:url])).to be_truthy
    end

    it "returns http bad_request with user_token [url] invalid" do
      params = { url: 'google.com' }
      post "/v1/short_urls", headers: { 'Authentication': user_token }, params: params
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "DESTROY /v1/short_urls" do
    it "returns http unauthorized" do
      delete "/v1/short_urls/#{short_url_id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http unauthorized with access_key" do
      delete "/v1/short_urls/#{short_url_id}", headers: { 'X-AccessKey': user_access_key }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success with user_token" do
      delete "/v1/short_urls/#{short_url_id}", headers: { 'Authentication': user_token }
      expect(response).to have_http_status(:success)
      expect(ShortUrl.find_by(id: short_url_id)).to be_falsy
    end
  end

  describe "GET /:code" do
    it "returns http bad_request code invalid" do
      get "/xxxxxxxx"
      expect(response).to have_http_status(:bad_request)
    end

    it "returns http success code invalid" do
      get "/#{short_url.code}"
      short_url.reload

      expect(response).to have_http_status(:moved_permanently)
      expect(short_url.clicked_count).to eq 1
    end
  end
end
