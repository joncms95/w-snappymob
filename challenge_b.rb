require 'colorize'

class FileParser
  class << self
    def parse_file(input_file = 'default.txt')
      raise "Error: Invalid input file '#{input_file}'. Please run `ruby challenger_a.rb` to generate a file first!".red unless File.exist?(input_file)

      content = File.read(input_file)
      objects = content.split(',').map(&:strip)

      objects.each do |object|
        puts "#{object}: #{check_type(object)}"
      end
    end

    private

    def check_type(object)
      if object.match?(/\A\d+\z/)
        'integer'
      elsif object.match?(/\A\d+\.\d+\z/)
        'real number'
      elsif object.match?(/\A[a-zA-Z]+\z/)
        'alphabetical string'
      elsif object.match?(/\A[a-zA-Z0-9]+\z/)
        'alphanumeric'
      else
        'unknown'
      end
    end
  end
end

input_file = ARGV[0] || 'default.txt'

FileParser.parse_file(input_file)
