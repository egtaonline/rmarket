describe "outer" do 
  before(:each) { puts "first" } 
  describe "inner" do
    before(:each) { puts "second" } 
    it { puts "third"}
    after(:each) { puts "fourth" }
  end
  after(:each) { puts "fifth" }
end