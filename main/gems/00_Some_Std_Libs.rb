puts '                                              Разные Std-lib'

# 1. ipaddr
require 'ipaddr'

# Проверка корректности айпи ipv4(от 0.0.0.0 до 255.255.255.255)
IPAddr.new('0.0.0.0').ipv4?         #=> true
IPAddr.new('255.255.255.255').ipv4? #=> true
IPAddr.new('0.0.0.1000').ipv4?      #=> invalid address:  (IPAddr::InvalidAddressError)

# Пересчет айпи адреса в число int32 ??
IPAddr.new("128.114.17.104").to_i   #=> 2154959208


# 2. digest
require 'digest'

# Хэширование MD%5(https://ruby-doc.org/stdlib-3.0.0/libdoc/digest/rdoc/Digest/MD5.html)
Digest::MD5.hexdigest('12345') #=> "827ccb0eea8a706c4c34a16891f84e7b"   # хэширование
# Взлом MD5 перебором для 5значных пинкодов состоящих только из цифр
hashmd5 = "827ccb0eea8a706c4c34a16891f84e7b"
('00000'..'99999').find{|pin| Digest::MD5.hexdigest(pin) == hashmd5} #=> "12345"

# Хэширование SHA2 https://ruby-doc.org/stdlib-2.4.0/libdoc/digest/rdoc/Digest/SHA2.html
hashsha2 = Digest::SHA2.hexdigest('code') #=> '5694d08a2e53ffcae0c3103e5ad6f6076abd960eb1f8a56577040bc1028f702b'
# Взлом SHA2 перебором
('a'..'zzzzz').find{|code| Digest::SHA2.hexdigest(code) == hashsha2} #=> "code"















# 
