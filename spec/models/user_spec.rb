require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_secure_password }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }
  it { is_expected.to validate_length_of(:name).is_at_least(5).is_at_most(50) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }

  describe 'User methods' do
    let(:user) { create(:user) }
    context '#generate_token!' do
      it do
        user.generate_token!
        expect(user.token.present?).to be(true)
      end 
    end

    context '#generate_access_key!' do
      it do
        user.generate_access_key!
        expect(user.access_key.present?).to be(true)
      end 
    end

    context '#reset_token!' do
      it do
        user.reset_token!
        expect(user.token.present?).to be(false)
      end 
    end

    context '#locked!' do
      it do
        user.locked!
        expect(user.locked?).to be(true)
      end 
    end

    context '#unlock!' do
      it do
        user.locked!
        user.unlock!
        expect(user.locked?).to be(false)
      end 
    end
  end
end