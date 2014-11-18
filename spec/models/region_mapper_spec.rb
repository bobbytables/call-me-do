require 'rails_helper'

RSpec.describe RegionMapper do
  describe '.region_from' do
    it 'returns the correct region for the digit' do
      expect(RegionMapper.region_from('1')).to eq('nyc2')
      expect(RegionMapper.region_from('2')).to eq('nyc3')
      expect(RegionMapper.region_from('3')).to eq('lon1')
      expect(RegionMapper.region_from('4')).to eq('ams1')
      expect(RegionMapper.region_from('5')).to eq('ams2')
      expect(RegionMapper.region_from('6')).to eq('ams3')
      expect(RegionMapper.region_from('7')).to eq('sgb1')
    end
  end
end