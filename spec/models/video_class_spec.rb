require 'rails_helper'

RSpec.describe VideoClass, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:video_url) }
  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:end_at) }
  it { should belong_to(:user) }

  it 'end date cannot be after start date' do
    video_class = VideoClass.new(end_at: '17-03-2021 20:00:00', start_at: '27-03-2021 20:00:00')
    video_class.valid?
    expect(video_class.errors[:end_at]).to include('não pode ser anterior a data de início!')
  end

  it 'end date be after start date' do
    video_class = VideoClass.new(end_at: '27-03-2021 20:00:00', start_at: '17-03-2021 20:00:00')
    video_class.valid?
    expect(video_class.errors[:end_at]).not_to include('não pode ser anterior a data de início!')
  end
end
