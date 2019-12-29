require 'database'

describe DataBase do 
  let(:subject) { described_class.new }
  let(:student) { double(['Tony', 'December']) }
  let(:student2) { double(['Ferguson', 'January']) }
  let(:expected_output) { ("1. Tony (December cohort)") }

  
  describe '#initialization' do
    it 'defaults with an empty array' do
      expect(subject.students).to be_empty
    end
    it 'loads an array if given one' do
      expect(described_class.new(student).students).to eq student
    end
  end

  describe '#add_student' do
    before do
      allow(subject).to receive(:add_student).with("Tony", :december).and_return(subject.students << student)
    end
    it 'adds a student to the array' do
      subject.add_student('Tony', :december)
      expect(subject.students).to include student
    end
  end

  describe '#print' do 
    before do 
      
      allow(student).to receive(:name).and_return("Tony")
      allow(student2).to receive(:name).and_return("Ferguson")
      allow(student).to receive(:cohort).and_return("December")
      allow(student2).to receive(:cohort).and_return("January")
      allow(subject).to receive(:add_student).with("tony", 'december').and_return(subject.students << student)
      allow(subject).to receive(:add_student).with('ferguson', 'january').and_return(subject.students << student2)
      subject.add_student('tony', 'december')
      subject.add_student('ferguson', 'january')
    end
    it '#print_by_cohort' do 
      expect{ subject.print_by_cohort('december') }.to output(/#{Regexp.quote(expected_output)}/).to_stdout
    end
    it 'raises an error when no matching cohort' do 
      expect{ subject.print_by_cohort('jan') }.to raise_error "No matches found"
    end
    it '#print_by_name' do 
      expect{ subject.print_by_name('t') }.to output(/#{Regexp.quote(expected_output)}/).to_stdout
    end
    it 'raises an error when no matching name' do 
      expect{ subject.print_by_name('g') }.to raise_error "No matches found"
    end
    # it '#print_all' do 
    #   subject.print_all
    #   expect{ subject.print_all }.to output(/#{Regexp.quote(expected_output)}/).to_stdout
    # end
  end

end
