require 'byebug'
require_relative './lexer.rb'

# Processes the symbols into an html file

class Preprocessor
  attr_reader :variables

  def initialize()
    @tokens = []
    @variables = {}
  end

  def create_crt_file(html_file)
    f = File.open(html_file).read
    f.each_line do |line|
      process(line)
    end
    crt = File.basename(html_file, '.html.crt')
  end

  private
  def process(line)
    @token_stream = LexerStream.new(line)
    while @token_stream.stream.front != nil
      @tokens << @token_stream.next_token
    end

    @tokens.each_index do |i|
      token = @tokens[i]
      case token.type
      when :variable
        i += 1
        if @tokens[i] != nil && @tokens[i].type == :equals
          i += 1
          if @tokens[i] != nil && @tokens[i].type == :variable
            @variables[token.value] = @tokens[i].value
          end
        end
      end
    end
  end
end


processer = Preprocessor.new()
processer.create_crt_file('./hey.html.crt')
puts processer.variables