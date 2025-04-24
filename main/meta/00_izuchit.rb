Kernel.send(:define_method, :increase_var) do
  shared_variable += 1
end
