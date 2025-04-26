Kernel.send(:define_method, :increase_var) do
  shared_variable += 1
end


# Отмена определения констант, соотв и модулей и классов через удаление константы их имени. Тк метод remove_const приватный и иначе его не вызвать извне
Object.send(:remove_const, :SomeClassOrModuleName)
