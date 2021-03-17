require 'rails_helper'

describe User do
  context 'validation' do
    it 'attributes cannot be blank' do
      user = User.new

      expect(user.valid?).to eq false
      expect(user.errors.count).to eq 4
    end

    it 'domain must be @smartflix.com.br' do
      user = build(:user, email: 'carlos@mail.com.br')

      expect(user.valid?).to eq false
      expect(user.errors.count).to eq 1
    end
  end
end