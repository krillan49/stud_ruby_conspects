# стр 110 Массивы (24.04.2022)


@arr1 = Array.new(10, 100)
@arr2 = Array.new(10, 100)

# Methods -------------------------------------------------------------------

def team1_shoot
  puts '-'*40
  robots_left1 = @arr1.count { |x| x != 'X' }
  puts "Team1 is shooting #{robots_left1} times."
  @arr02 = @arr2.clone # для одновременного хода
  n = 0
  m = 0
  for i in 0...@arr1.size
    if @arr1[i] != 'X'
      target = rand(0..9)
      damage = rand(1..100)
      if @arr02[target] != 'X'
        n += 1
        @arr02[target] -= damage
        if @arr02[target] <= 0
          @arr02[target] = 'X'
          m += 1
        end
      end
    end
  end
  puts "In team2 damaged #{n} and destroed #{m} robots"
end

def team2_shoot
  puts '-'*40
  robots_left2 = @arr2.count { |x| x != 'X' }
  puts "Team2 is shooting #{robots_left2} times."
  @arr01 = @arr1.clone # для одновременного хода
  n = 0
  m = 0
  for i in 0...@arr2.size
    if @arr2[i] != 'X'
      target = rand(0..9)
      damage = rand(1..100)
      if @arr01[target] != 'X'
        n += 1
        @arr01[target] -= damage
        if @arr01[target] <= 0
          @arr01[target] = 'X'
          m += 1
        end
      end
    end
  end
  puts "In team1 damaged #{n} and destroed #{m} robots"
end

def shot_result # для одновременного хода
  @arr1 = @arr01
  @arr2 = @arr02
  puts '-'*40
  robots_left1 = @arr1.count { |x| x != 'X' }
  robots_left2 = @arr2.count { |x| x != 'X' }
  puts "In team1 left #{robots_left1} robots. In team2 left #{robots_left2} robots"
end

def who_win
  puts '-'*40
  if @arr1.all?('X')
    puts 'Team2 win'
  elsif @arr2.all?('X')
    puts 'Team1 win'
  end
  puts '-'*40
end
#------------------------------------------------------------------------------------------

# Main program ----------------------------------------------------------------------------
n = 0
while !@arr1.all?('X') and !@arr2.all?('X')
  n += 1
  puts '-'*40
  puts "Team1 is #{@arr1}"
  puts "Team2 is #{@arr2}"
  print "Push enter to start round #{n} "
  gets

  team1_shoot
  sleep 1
  team2_shoot
  sleep 1

  shot_result
end

who_win
