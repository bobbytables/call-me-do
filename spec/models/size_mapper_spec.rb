require 'rails_helper'

RSpec.describe SizeMapper do
  describe '.size_from' do
    it 'returns the correct size slug for the digit' do
      expect(SizeMapper.size_from('1')).to eq('512mb')
      expect(SizeMapper.size_from('2')).to eq('1gb')
      expect(SizeMapper.size_from('3')).to eq('2gb')
      expect(SizeMapper.size_from('4')).to eq('4gb')
      expect(SizeMapper.size_from('5')).to eq('8gb')
      expect(SizeMapper.size_from('6')).to eq('16gb')
      expect(SizeMapper.size_from('7')).to eq('32gb')
      expect(SizeMapper.size_from('8')).to eq('48gb')
      expect(SizeMapper.size_from('9')).to eq('64gb')
    end
  end
end