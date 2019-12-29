require 'student'

describe Student do 
  let(:subject) { described_class.new("tony") }
  let(:subject2) { described_class.new("tony", "december") }

  describe '#initialization' do 
    it 'automaticaly sets the cohort as november' do 
      expect(subject.name).to eq "Tony"
    end
    it 'allows cohort to be overwritten' do 
      expect(subject2.cohort).to eq 'December'
    end
  end
end
