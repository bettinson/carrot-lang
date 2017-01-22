require 'byebug'
require_relative './lexer.rb'

# Processes the symbols into an html file

class Preprocessor
  def initialize(string)
    @token_stream = LexerStream.new(string)
    @tokens = []
    # Grabs all the tokens
    @variables = {}
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
            @variables[token] = @tokens[i]
          end
        end
      else
      end
    end
  end
end

pros = Preprocessor.new('hey {{mat = "cool";}} fdjskfjsdjk')


        