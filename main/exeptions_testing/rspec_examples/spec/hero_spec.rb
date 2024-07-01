# require_relative '../hero'

describe 'types of it' do
  it "has a capitalized name" do
    hero = Hero.new 'foo'
    expect(hero.name).to eq 'Foo'
  end
  it do
    hero = Hero.new 'foo'
    expect(hero.power_up).to eq 110
  end
  it { expect(Hero.new('foo').power_up).to eq 110 }
  it("displays full hero info") { expect(Hero.new('foo').hero_info).to eq "Foo has 100 health" }
end

describe 'strucure of it' do
  it "displays full hero info after power up" do
    hero = Hero.new 'foo'
    hero.power_up
    expect(hero.hero_info).to eq "Foo has 110 health"
  end
end

describe Hero do
  before do
    @hero = Hero.new('foo')
  end

  it "has a capitalized name" do
    expect(@hero.name).to eq 'Foo'
  end

  it "can power up" do
    expect(@hero.power_up).to eq 110
  end
end

describe Hero do
  before do
    @hero = Hero.new 'foo'
  end

  describe "start variables is correct" do
    it "has a capitalized name" do
      expect(@hero.name).to eq 'Foo'
    end
    it "has a standart health points" do
      expect(@hero.health).to eq 100
    end
  end

  describe "#power_up" do
    it "can power up 1 time" do
      expect(@hero.power_up).to eq 110
    end
    it "can power up 2 times" do
      @hero.power_up
      expect(@hero.power_up).to eq 120
    end
  end
end
