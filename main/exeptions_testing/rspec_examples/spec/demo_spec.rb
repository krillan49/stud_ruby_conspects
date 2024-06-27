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

RSpec.describe 'this is a testing suite' do
  it 'self.run' do
    result = Demo.run
    expect(result).to(eq(43))
  end
end













#
