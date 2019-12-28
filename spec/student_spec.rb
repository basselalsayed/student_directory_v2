require 'student'

describe Student do 
  let(:subject) { described_class.new("tony") }
  let(:subject2) { described_class.new("tony", "december") }

  describe '#initialization' do 
    it 'automaticaly sets the cohort as november' do 
      expect(subject.details).to eq(["Tony", :november])
    end
    it 'allows cohort to be overwritten' do 
      expect(subject2.details).to eq(["Tony", :december])
    end
  end
end
