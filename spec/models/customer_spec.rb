require 'rails_helper'

describe Customer do
  context 'validation' do
    it { should validate_presence_of(:full_name) }

    it { should validate_presence_of(:cpf) }

    it { should validate_presence_of(:age) }
  end
end
