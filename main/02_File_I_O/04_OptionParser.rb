puts '                                            OptionParser'

# (!! Потом нормально изучить тему)

# https://docs.ruby-lang.org/en/master/OptionParser.html

# OptionParser - это класс для анализа параметров командной строки. Он гораздо более продвинутый, но и более простой в использовании, чем GetoptLong, и является более Ruby-ориентированным решением

# Минимальный пример
require 'optparse'

options = {}
OptionParser.new do |parser|
  parser.banner = "Usage: example.rb [options]"

  parser.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end.parse!

p options
p ARGV


# OptionParser может использоваться для автоматической генерации справки по написанным вами командам:
require 'optparse'

Options = Struct.new(:name)

class Parser
  def self.parse(options)
    args = Options.new("world")

    opt_parser = OptionParser.new do |parser|
      parser.banner = "Usage: example.rb [options]"

      parser.on("-nNAME", "--name=NAME", "Name to say hello to") do |n|
        args.name = n
      end

      parser.on("-h", "--help", "Prints this help") do
        puts parser
        exit
      end
    end

    opt_parser.parse!(options)
    return args
  end
end
options = Parser.parse %w[--help]

#=>
# Usage: example.rb [options]
#     -n, --name=NAME                  Name to say hello to
#     -h, --help                       Prints this help



# Для опций, требующих аргумента, строки спецификации опций могут включать имя опции заглавными буквами. Если опция используется без требуемого аргумента, будет вызвано исключение.
require 'optparse'

options = {}
OptionParser.new do |parser|
  parser.on("-r", "--require LIBRARY", "Require the LIBRARY before executing your script") do |lib|
    puts "You required #{lib}!"
  end
end.parse!

# $ ruby optparse-test.rb -r
# optparse-test.rb:9:in '<main>': missing argument: -r (OptionParser::MissingArgument)
# $ ruby optparse-test.rb -r my-library
# You required my-library!


# OptionParser поддерживает возможность преобразования аргументов командной строки в объекты. OptionParser поставляется с несколькими готовыми к использованию видами приведения типов:
# Date           – все, что принято Date.parse (нужно require optparse/date)
# DateTime       – все, что принято DateTime.parse (нужно require optparse/date)
# Time           – все, что принято Time.httpdate или Time.parse (нужно require optparse/time)
# URI            – все, что принято URI.parse (нужно require optparse/uri)
# Shellwords     – все, что принято Shellwords.shellwords (нужно require optparse/shellwords)
# String         – любая непустая строка
# Integer        – любое целое число. Преобразует восьмеричное. (например, 124, -3, 040)
# Float          – любое число с плавающей точкой. (например, 10, 3.14, -100E+13)
# Numeric        – любое целое, дробное или рациональное число (1, 3.4, 1/3)
# DecimalInteger – как Integer, но без восьмеричного формата.
# OctalInteger   – как Integer, но без десятичного формата.
# DecimalNumeric – десятичное целое число или число с плавающей точкой.
# TrueClass      – принимает «+, yes, true, -, no, false» и по умолчанию true
# FalseClass     – то же, что и TrueClass, но по умолчаниюfalse
# Array          – строки, разделенные символом «,» (например, 1,2,3)
# Regexp         – регулярные выражения. Также включает опции.


# В качестве примера используется встроенное Time преобразование. Другие встроенные преобразования ведут себя таким же образом. OptionParser попытается проанализировать аргумент как Time. Если это удастся, это время будет передано в блок обработчика. В противном случае будет вызвано исключение.
require 'optparse'
require 'optparse/time'
OptionParser.new do |parser|
  parser.on("-t", "--time [TIME]", Time, "Begin execution at given time") do |time|
    p time
  end
end.parse!
# $ ruby optparse-test.rb  -t nonsense        => ... invalid argument: -t nonsense (OptionParser::InvalidArgument)
# $ ruby optparse-test.rb  -t 10-11-12        => 2010-11-12 00:00:00 -0500
# $ ruby optparse-test.rb  -t 9:30            => 2014-08-13 09:30:00 -0400


# Создание пользовательских конверсий
# Метод accept OptionParser может использоваться для создания преобразователей. Он указывает, какой блок преобразования вызывать всякий раз, когда указан класс. В примере ниже он используется для извлечения User объекта до того, как onобработчик его получит.

require 'optparse'

User = Struct.new(:id, :name)

def find_user id
  not_found = ->{ raise "No User Found for id #{id}" }
  [ User.new(1, "Sam"), User.new(2, "Gandalf") ].find(not_found) do |u|
    u.id == id
  end
end

op = OptionParser.new
op.accept(User) do |user_id|
  find_user user_id.to_i
end

op.on("--user ID", User) do |user|
  puts user
end

op.parse!

# $ ruby optparse-test.rb --user 1   => #<struct User id=1, name="Sam">
# $ ruby optparse-test.rb --user 2   => #<struct User id=2, name="Gandalf">
# $ ruby optparse-test.rb --user 3   => optparse-test.rb:15:in 'block in find_user': No User Found for id 3 (RuntimeError)


# Сохраните параметры в Hash
require 'optparse'

options = {}
OptionParser.new do |parser|
  parser.on('-a')
  parser.on('-b NUM', Integer)
  parser.on('-v', '--verbose')
end.parse!(into: options)

p options

# $ ruby optparse-test.rb -a               => {:a=>true}
# $ ruby optparse-test.rb -a -v            => {:a=>true, :verbose=>true}
# $ ruby optparse-test.rb -a -b 100        => {:a=>true, :b=>100}


# Полный пример — чтобы увидеть эффект от указания различных опций
require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'

class OptparseExample
  Version = '1.0.0'

  CODES = %w[iso-2022-jp shift_jis euc-jp utf8 binary]
  CODE_ALIASES = { "jis" => "iso-2022-jp", "sjis" => "shift_jis" }

  class ScriptOptions
    attr_accessor :library, :inplace, :encoding, :transfer_type,
                  :verbose, :extension, :delay, :time, :record_separator,
                  :list

    def initialize
      self.library = []
      self.inplace = false
      self.encoding = "utf8"
      self.transfer_type = :auto
      self.verbose = false
    end

    def define_options(parser)
      parser.banner = "Usage: example.rb [options]"
      parser.separator ""
      parser.separator "Specific options:"

      # add additional options
      perform_inplace_option(parser)
      delay_execution_option(parser)
      execute_at_time_option(parser)
      specify_record_separator_option(parser)
      list_example_option(parser)
      specify_encoding_option(parser)
      optional_option_argument_with_keyword_completion_option(parser)
      boolean_verbose_option(parser)

      parser.separator ""
      parser.separator "Common options:"
      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      parser.on_tail("-h", "--help", "Show this message") do
        puts parser
        exit
      end
      # Another typical switch to print the version.
      parser.on_tail("--version", "Show version") do
        puts Version
        exit
      end
    end

    def perform_inplace_option(parser)
      # Specifies an optional option argument
      parser.on("-i", "--inplace [EXTENSION]",
                "Edit ARGV files in place",
                "(make backup if EXTENSION supplied)") do |ext|
        self.inplace = true
        self.extension = ext || ''
        self.extension.sub!(/\A\.?(?=.)/, ".")  # Ensure extension begins with dot.
      end
    end

    def delay_execution_option(parser)
      # Cast 'delay' argument to a Float.
      parser.on("--delay N", Float, "Delay N seconds before executing") do |n|
        self.delay = n
      end
    end

    def execute_at_time_option(parser)
      # Cast 'time' argument to a Time object.
      parser.on("-t", "--time [TIME]", Time, "Begin execution at given time") do |time|
        self.time = time
      end
    end

    def specify_record_separator_option(parser)
      # Cast to octal integer.
      parser.on("-F", "--irs [OCTAL]", OptionParser::OctalInteger,
                "Specify record separator (default \\0)") do |rs|
        self.record_separator = rs
      end
    end

    def list_example_option(parser)
      # List of arguments.
      parser.on("--list x,y,z", Array, "Example 'list' of arguments") do |list|
        self.list = list
      end
    end

    def specify_encoding_option(parser)
      # Keyword completion.  We are specifying a specific set of arguments (CODES
      # and CODE_ALIASES - notice the latter is a Hash), and the user may provide
      # the shortest unambiguous text.
      code_list = (CODE_ALIASES.keys + CODES).join(', ')
      parser.on("--code CODE", CODES, CODE_ALIASES, "Select encoding",
                "(#{code_list})") do |encoding|
        self.encoding = encoding
      end
    end

    def optional_option_argument_with_keyword_completion_option(parser)
      # Optional '--type' option argument with keyword completion.
      parser.on("--type [TYPE]", [:text, :binary, :auto],
                "Select transfer type (text, binary, auto)") do |t|
        self.transfer_type = t
      end
    end

    def boolean_verbose_option(parser)
      # Boolean switch.
      parser.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        self.verbose = v
      end
    end
  end

  #
  # Return a structure describing the options.
  #
  def parse(args)
    # The options specified on the command line will be collected in
    # *options*.

    @options = ScriptOptions.new
    @args = OptionParser.new do |parser|
      @options.define_options(parser)
      parser.parse!(args)
    end
    @options
  end

  attr_reader :parser, :options
end  # class OptparseExample

example = OptparseExample.new
options = example.parse(ARGV)
pp options # example.options
pp ARGV














#
