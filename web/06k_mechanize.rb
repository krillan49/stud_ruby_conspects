puts '                                           mechanize'

# https://github.com/sparklemotion/mechanize

# Mechanize - используется для автоматизации взаимодействия с веб-сайтами. Mechanize автоматически сохраняет и отправляет файлы cookie, следует перенаправлениям и может следовать ссылкам и отправлять формы. Поля форм можно заполнять и отправлять. Mechanize также отслеживает сайты, которые вы посетили, как историю.

# Mechanize - позволяет использовать нашу программу как браузер ?? поpволяет получать доступ к HTML-документу как к полноценному XML-дереву, что позволяет удобно применять и методы гема REXML, например attributes


# gem install mechanize

require 'mechanize'

# Создаем экземпляр нашего "браузера"
agent = Mechanize.new #=> #<Mechanize:0x000001e7b687fee8 ...

# get - метод чтобы послать запрос и скачать страницу, вернет всю страницу
page = agent.get("https://fighttime.ru/fighters/1500/Fedor-Emelianenko.html")
#=>
# #<Mechanize::Page
#  {url #<URI::HTTPS https://fighttime.ru/fighters/1500/Fedor-Emelianenko.html>}
#  {meta_refresh}
#  {title
#   "Федор Емельяненко | Fedor Emelianenko (Последний Император) статистика, видео, фото, биография, бои без правил, боец MMA"}
# ...

# search - метод ищет элементы XML-дерева, принимает параметры на языке XPath который позволяет искать по дереву. ?? Это метод mechanize или Нокогири ??
tag = page.search("//div[starts-with(@id, 'tab2')]").to_a[0] #=> #<Nokogiri::XML::Element:0x4420 name="div" ...
# // - значит что ищем на любом уровне вложености
# div - ищем тег с этим названием
# [starts-with(@id, 'tab2')] - свойства тега, который ищем
# starts-with(@id, 'tab2') - функция вернет все теги у которых id начинается с 'tr_'

# Так же можно искать и от полученного тега вложенное внутри него
form = tag.search("form[@class='horizontal fb_form_fighter']").to_a[0] #=> #<Nokogiri::XML::Element:0x62c name="form" ...
# form[@class='horizontal fb_form_fighter'] - ищем тег "form" c атрибутом @class='horizontal fb_form_fighter' (нужно записывать значение атрибута полностью тк ищет не по классам а как по тексту)

# text - метод возвращает содержимое тела тега в формате строки
title = form.search("title").text #=> "поиск"

















#
