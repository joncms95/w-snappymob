require 'colorize'

class OutputExporter
  OUTPUT_SIZE = 10_000_000

  def initialize(object_generator: BaseRandomObjectGenerator, output_file: 'default.txt')
    @object_generator = object_generator
    @output_file = output_file
    @content = ''
  end

  def generate_and_write
    while @content.bytesize < OUTPUT_SIZE
      obj = @object_generator.random_object

      s_to_add = @content.empty? ? obj : ",#{obj}"

      bytes = s_to_add.bytesize
      break if (@content.bytesize + bytes) > OUTPUT_SIZE

      @content << s_to_add
    end

    File.open(@output_file, 'w') { |f| f.write(@content) }

    puts 'Object Generator: '.yellow + "#{@object_generator}".blue
    puts 'Output File     : '.yellow + "#{@output_file}".green
    puts 'File Size       : '.yellow + "#{@content.bytesize} bytes".red
  end
end

# Random Object Generator Classes
class BaseRandomObjectGenerator
  class << self
    def random_object
      send(random_methods.sample)
    end

    private

    def random_methods
      @random_methods ||= [
        :random_real_number,
        :random_integer,
      ]
    end

    def random_real_number
      format('%.2f', rand * 1000)
    end

    def random_integer
      rand(1000).to_s
    end
  end
end

class SnappymobRandomObjectGenerator < BaseRandomObjectGenerator
  LETTERS = (('a'..'z').to_a + ('A'..'Z').to_a).freeze
  NUMBERS = ('0'..'9').to_a.freeze
  ALPHANUMERIC = (LETTERS + NUMBERS).freeze

  class << self
    private

    def random_methods
      @random_methods ||= super + [
        :random_alphabetical_string,
        :random_alphanumeric,
      ]
    end

    def random_alphabetical_string
      LETTERS.sample(rand(5..10)).join
    end

    def random_alphanumeric
      alphanumeric = ALPHANUMERIC.sample(rand(5..10)).join
      "#{random_space}#{alphanumeric}#{random_space}"
    end

    def random_space
      ' ' * rand(1..10)
    end
  end
end

GENERATOR_MAPPING = {
  'base' => BaseRandomObjectGenerator,
  'snappymob' => SnappymobRandomObjectGenerator,
}.freeze

generator = ARGV[0] || 'base'
output_file = ARGV[1] || 'default.txt'

object_generator = GENERATOR_MAPPING[generator]
raise "Error: Invalid generator '#{generator}'. Use one of: #{GENERATOR_MAPPING.keys}, Usage: ruby challenge_a.rb <generator> <output_file>".red unless object_generator

exporter = OutputExporter.new(object_generator: object_generator, output_file: output_file)
exporter.generate_and_write
