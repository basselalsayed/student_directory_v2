require 'database'

describe DataBase do 
  let(:subject) { described_class.new }
  let(:students_list) { ["Tony", :december] }
  
  describe '#initialization' do 
    it 'defaults with an empty array' do 
      expect(subject.students).to be_empty
    end
    it 'loads an array if given one' do 
      expect(described_class.new(students_list).students).to eq students_list
    end
  end
end