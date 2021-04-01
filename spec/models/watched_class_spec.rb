require 'rails_helper'

describe WatchedClass do
  context 'validation' do
    it { should belong_to(:customer) }
    it { should belong_to(:video_class) }
  end
end
