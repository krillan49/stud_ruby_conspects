# Расширенное задание - написать программу, которая ищет нужный файл на диске C:\

# Вариант 1 при помощи метода
#p Dir.glob('E:/**/*/Heather Locklear.jpeg')

# Вариант 2 "в ручную" при помощи рекурсии
@dir=nil
def filefinder_e(failname, dir)
  return @dir if @dir # возвращаемся если фаил найден
  Dir.chdir(dir) # меняем директорию на заданную
  start_dir=Dir.pwd # начальная директория данного этапа рекурсии
  fold=Dir.children(Dir.pwd) # массив элементов директории
  if fold.find{|e| e==failname} # проверяем есть ли в ней искомый фаил
    @dir=Dir.pwd # если есть присваиваем путь в переменную
    return @dir
  end
  dirs=fold.select{|e| File::directory?(e)} # выбираем среди элементов директории
  dirs.each do |d|
    filefinder_e(failname, Dir.pwd+"/#{d}") # рекурсия - применяем метод к поддиректориям
    Dir.chdir(start_dir) # если не найдено меняем директорию на изначальную для этого этапа рекурсии
  end
  @dir ? @dir : 'не найдено'
end

p filefinder_e('Heather Locklear.jpeg', 'E:/doc/pic') #=> "E:/doc/pic/pictures/неон"
