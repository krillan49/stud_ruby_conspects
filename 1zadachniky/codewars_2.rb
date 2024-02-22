# Blaine is a pain
# https://www.codewars.com/kata/59b47ff18bcb77a4d1000076/train/ruby
class Train
  attr_reader :length, :position, :dir, :express

  def initialize(train, train_pos)
    @length = train.size
    @position = train_pos
    @dir = train[0] == train[0].upcase ? -1 : 1
    @express = train[0] == 'x' || train[0] == 'X'
  end
end

class Track
  attr_reader :track

  def initialize(track)
    @track = make_map(track)
  end

  private

  def make_map(track, res={}, n=0, dir='NE') # dir всегда такое тк может быть только / или S
    hh = track.split("\n")
              .map.with_index{|s, i| s.split('').map.with_index{|e, j| [[i, j], e] if e != ' '}.compact}
              .flatten(1)
              .to_h
    y, x = hh.min_by{|k, v| [k[0], k[1]]}[0]
    # hh.size.times do
      if hh[[y, x]] == '/'
        if %w[N NE E].include?(dir) # направление до этого
          dir = 'NE' # текущее направление
          [ # координаты следующей точки
            %w[+ |].include?(hh[[y-1, x]]) ? [y-1, x] : nil,
            %w[X /].include?(hh[[y-1, x+1]]) ? [y-1, x+1] : nil,
            %w[+ -].include?(hh[[y, x+1]]) ? [y, x+1] : nil
          ]
        elsif %w[S SW W].include?(dir)
          dir = 'SW'
          [
            %w[+ |].include?(hh[[y+1, x]]) ? [y+1, x] : nil,
            %w[X /].include?(hh[[y+1, x-1]]) ? [y+1, x-1] : nil,
            %w[+ -].include?(hh[[y, x-1]]) ? [y, x-1] : nil
          ]
        end
      elsif hh[[y, x]] == '\\'
        if %w[N NW W].include?(dir)
          dir = 'NW'
          [
            %w[+ |].include?(hh[[y-1, x]]) ? [y-1, x] : nil,
            %w[X \\].include?(hh[[y-1, x-1]]) ? [y-1, x-1] : nil,
            %w[+ -].include?(hh[[y, x-1]]) ? [y, x-1] : nil
          ]
        elsif %w[S SE E].include?(dir)
          dir = 'SE'
          [
            %w[+ |].include?(hh[[y+1, x]]) ? [y+1, x] : nil,
            %w[X \\].include?(hh[[y+1, x+1]]) ? [y+1, x+1] : nil,
            %w[+ -].include?(hh[[y, x+1]]) ? [y, x+1] : nil
          ]
        end
      elsif hh[[y, x]] == '|'
        if %w[].include?(dir)
          dir = ''
          [
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil
          ]
        elsif %w[].include?(dir)
          dir = ''
          [
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil
          ]
        end
      elsif hh[[y, x]] == '-'
        if %w[].include?(dir)
          dir = ''
          [
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil
          ]
        elsif %w[].include?(dir)
          dir = ''
          [
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil
          ]
        end
      elsif hh[[y, x]] == '+'
        if %w[].include?(dir)
          dir = ''
          [
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil
          ]
        elsif %w[].include?(dir)
          dir = ''
          [
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil
          ]
        end
      elsif hh[[y, x]] == 'X'
        if %w[].include?(dir)
          dir = ''
          [
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil
          ]
        elsif %w[].include?(dir)
          dir = ''
          [
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil
          ]
        end
      elsif hh[[y, x]] == 'S'
        if %w[].include?(dir)
          dir = ''
          [
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil
          ]
        elsif %w[].include?(dir)
          dir = ''
          [
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil,
            %w[].include?(hh[[y, x]]) ? [y, x] : nil
          ]
        end
      end#.compact[0]
      # n += 1
    # end
  end
end

def train_crash(track, a_train, a_train_pos, b_train, b_train_pos, limit)
  t1 = Train.new(a_train, a_train_pos)
  t2 = Train.new(b_train, b_train_pos)
  track = Track.new(track)
  track.track
end

TRACK_EX_ = """\
                                /------------\\
/-------------\\                /             |
|             |               /              S
|             |              /               |
|        /----+--------------+------\\        |
\\       /     |              |      |        |
 \\      |     \\              |      |        |
 |      |      \\-------------+------+--------+---\\
 |      |                    |      |        |   |
 \\------+--------------------+------/        /   |
        |                    |              /    |
        \\------S-------------+-------------/     |
                             |                   |
/-------------\\              |                   |
|             |              |             /-----+----\\
|             |              |             |     |     \\
\\-------------+--------------+-----S-------+-----/      \\
              |              |             |             \\
              |              |             |             |
              |              \\-------------+-------------/
              |                            |
              \\----------------------------/
"""

p train_crash(TRACK_EX_, "Aaaa", 147, "Bbbbbbbbbbb", 288, 1000) # 516
