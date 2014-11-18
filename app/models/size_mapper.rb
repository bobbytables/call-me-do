class SizeMapper
  MAPPING = {
    '1' => '512mb',
    '2' => '1gb',
    '3' => '2gb',
    '4' => '4gb',
    '5' => '8gb',
    '6' => '16gb',
    '7' => '32gb',
    '8' => '48gb',
    '9' => '64gb',
  }

  def self.size_from(digit)
    digit = digit.to_s
    MAPPING[digit]
  end
end