# =======================================================================
# 3 kyu Help the general decode secret enemy messages
# =======================================================================

# Задача сломана похоже, проходит простые тесты и последний блок, но не проходит средние

# Кодировщик полученный опытным путем(чисто поиграться, декодировать через обратное ему хз как)
SYM = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,? '
L = SYM.size + 1
def encode(s)
  s.chars.map.with_index do |c, i|
    if SYM.include?(c)
      j = SYM.index(c) + 1
      k = (j + (0..i).map{|n| j * 2**n}.sum) % L - 1
      SYM[k]
    else
      c
    end
  end.join
end
p encode("Hello World!")
p encode("The quick brown fox jumped over the lazy developer.")

# РЕШЕНИЕ:
# 'abdhpF,82QsLirJejtNmzZKgnB3SwTyXG ?.6YIcflxVC5WE94UA1OoD70MkvRuPqHa'.reverse  cycle(from encode('aaaaaa...)
DEC = "aHqPuRvkM07DoO1AU49EW5CVxlfcIY6.? GXyTwS3BngKZzmNtjeJriLsQ28,Fphdba"
def decode(s)
  counter = 1
  s.each_char.with_index do |e,i|
    if DEC.include?(e)
      ind = DEC.index(e) + counter
      ind %= DEC.size - 1 if ind > DEC.size - 1
      s[i] = DEC[ind]
    end
    counter += 1
  end
end
p decode("atC5kcOuKAr!") # "Hello World!"
p decode("yFNYhdmEdViBbxc40,ROYNxwfwvjg5CHUYUhiIkp2CMIvZ.1qPz") # "The quick brown fox jumped over the lazy developer."
