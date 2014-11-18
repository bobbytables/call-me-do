class RegionMapper
  MAPPING = {
    '1' => 'nyc2',
    '2' => 'nyc3',
    '3' => 'lon1',
    '4' => 'ams1',
    '5' => 'ams2',
    '6' => 'ams3',
    '7' => 'sgb1',
  }

  def self.region_from(digit)
    digit = digit.to_s
    MAPPING[digit]
  end
end