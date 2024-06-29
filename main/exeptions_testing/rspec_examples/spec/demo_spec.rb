require_relative '../demo'

# RSpec.describe 'this is a testing suite' do
# end
#
# RSpec.describe 'this is a testing suite' do
#   it 'self.run' do
#     result = Demo.run
#     p result == 43
#   end
# end

# RSpec.describe 'this is a testing suite' do
#   it 'self.run' do
#     result = Demo.run
#     if result == 43
#       puts 'ok'
#     else
#       raise 'not ok, value should be 42'
#     end
#   end
# end
#
# RSpec.describe 'this is a testing suite' do
#   it 'self.run' do
#     result = Demo.run
#     expect(result).to(eq(43))
#   end
# end
#
# RSpec.describe Demo do
#   specify '.run' do
#     p "My class is #{described_class.inspect}"
#     result = described_class.run
#     expect(result).to eq(42)
#   end
#   specify '#calc' do
#     obj = described_class.new
#     expect(obj.calc(2, 3)).to eq(6)
#     expect(obj).to be_an_instance_of(described_class)
#   end
#   specify '#my_arr' do
#     obj = described_class.new
#     expect(obj.my_arr).to include(2)
#   end
# end

# RSpec.describe Demo do
#   def obj
#     described_class.new # возвращаем объект
#   end
#
#   specify '#calc' do
#     expect(obj().calc(2, 3)).to eq(6) # вызываем наш метод чтобы использовать возвращенный объект
#   end
#
#   specify '#my_arr' do
#     expect(obj().my_arr).to include(2)
#   end
# end

RSpec.describe Demo do
  let(:obj) { puts 'obj created!' ; described_class.new }

  specify '.run' do
    result = described_class.run
    expect(result).to eq(42)
  end

  specify '#calc' do
    p obj
    expect(obj.calc(2, 3)).to eq(6)
  end

  specify '#my_arr' do
    p obj
    expect(obj.my_arr).to include(2)
    obj.val = 1
  end
end













#
