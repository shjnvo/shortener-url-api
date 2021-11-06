require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
  it { is_expected.to validate_presence_of(:url) }
  it { is_expected.to belong_to(:user) }

  describe 'Blog methods' do
    let!(:user) { create(:user) }

    context 'validation url format' do
      let!(:short_url_unvalid_1) { build(:short_url, url: 'abc', user: user) }
      let!(:short_url_unvalid_2) { build(:short_url, url: 'abc.com', user: user) }
      let!(:short_url_unvalid_3) { build(:short_url, url: 'ftp:abc.com', user: user) }
      let!(:short_url_valid_1) { build(:short_url, url: 'http://abc.com', user: user) }
      let!(:short_url_valid_2) { build(:short_url, url: 'https://abc.com', user: user) }
      let!(:short_url_valid_3) { build(:short_url, url: 'https://www.abc.com', user: user) }

      it do
        expect(short_url_unvalid_1.valid?).to eq false
        expect(short_url_unvalid_2.valid?).to eq false
        expect(short_url_unvalid_3.valid?).to eq false
        expect(short_url_valid_1.valid?).to eq true
        expect(short_url_valid_2.valid?).to eq true
        expect(short_url_valid_3.valid?).to eq true
      end
    end

    context 'validation code presence' do
      let!(:short_url) { build(:short_url, user: user) }

      it do
        expect(short_url.valid?).to eq true
      end
    end
  end
end
