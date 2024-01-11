# Cut the cake
# https://www.codewars.com/kata/586214e1ef065414220000a8/train/ruby

class CakeCutter
  def initialize(cake, area, count)
    @cake = cake.split("\n").map{|s| s.split('')}
    @areas = all_possible_cuts_areas(area) #=> [[2, 8], [4, 4]]
    @count = count
    @cuts = []
  end

  def main
    make_cut
  end

  def make_cut
    @areas.each do |area|
      cut_checker(area)
    end
  end

  def cut_checker(area)
    p area
    y, x = area
    cut = @area[0..y][0..x]
  end

  private

  def all_possible_cuts_areas(area) # не шире ширины не длиннее длинны
    2.step(area/2, 2).map{|e| [e, area/e] if area % e == 0 && e <= @cake.size && area/e <= @cake[0].size}.compact
  end
end

def cut(cake)
  check = cake.gsub(/\s/, '')
  count = check.count('o')
  area = check.size / count
  return [] if check.size % count > 0 || area % 2 > 0
  obj = CakeCutter.new(cake, area, count)
  obj.main
end

cake = "
........
..o.....
...o....
........
".strip
result = [
"
........
..o.....
".strip,
"
...o....
........
".strip
]
p cut(cake) # result
