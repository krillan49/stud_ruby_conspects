# Задача: посчитать все слова в файле(полезно например для изучения самых популярных слов в языке):
# Для этого используем хеш

f = File.open 'text/simple.txt', 'r'

@hh = {}

def add_to_hash(word)
  if !word.empty?
    word.downcase!

    cnt = @hh[word].to_i # либо значение либо 0
    cnt += 1

    @hh[word] = cnt
  end
end

f.each_line do |line|
  arr = line.split(/\s|\n|\.|,|:|;/)
  arr.each { |word| add_to_hash(word) }
end

f.close

@hh.each do |k, v|
  puts "#{v} - #{k}"
end
