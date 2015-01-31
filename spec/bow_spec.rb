# Your code here
require 'weapons/bow'
describe Bow do

  let (:b) {Bow.new}

  describe '#arrows' do
    it 'initializes with 10 arrows' do
      expect(b.arrows).to eq(10)
    end

    it 'can initialize with other numbers of arrows' do
      expect(Bow.new(3).arrows).to eq(3)
    end

  end

  describe '#use' do
    before {b.use}
    it 'reduces arrow count with use' do
      expect(b.arrows).to eq(9)
    end

    it 'errors if out of errors' do
      expect do
        Bow.new(0).use
      end.to raise_error(RuntimeError)
    end
  end
end