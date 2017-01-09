require 'byebug'

# Encapsulates dealing with a chunk of syntax
class StringStream
  attr_accessor :in_syntax

  def initialize(string)
    @string = string
    @in_syntax = false
  end

  def front
    @string[0]
  end

  def pop_front
    @string = @string[1, @string.size]
  end

  def in_syntax?
    @in_syntax
  end

  def string
    return @string
  end
end

# Represents a symbol of values
class Token
  attr_accessor :value, :type
  def initialize(value, type)
    @value = value
    @type = type
  end
end

class Lexer
  def initialize(string)
    @stream = StringStream.new(string)
    @tokens = []
  end

  def next_token()
    # byebug
    case @stream.front
    when '{'
      @stream.pop_front
      if @stream.front == '{'
        @stream.pop_front
        @stream.in_syntax = true
        return Token.new('{{', :begin_bracket)
      end
    when '}'
      @stream.pop_front
      if @stream.front == '}'
        @stream.pop_front
        @stream.in_syntax = false
        return Token.new('}}', :end_bracket)
      end
    when '='
      @stream.pop_front
      return Token.new('=', :equals)
    else
      if @stream.in_syntax?
        # EG: {{ variable = "foo"; }}
        # Where ';' denotes the end of variable assignment.
        variable_string = ''

        while @stream.front != nil || @stream.front != ';' || @stream.front != '='
          variable_string << @stream.front unless @stream.front == ' '
          @stream.pop_front
        end

        return Token.new(variable_string, :variable)
      end
    end

    if !@stream.in_syntax?
      non_syntax_string = ''
      until @stream.front == '{' || @stream.front == nil
        non_syntax_string << @stream.front
        @stream.pop_front
      end
      @stream.in_syntax = true
      return Token.new(non_syntax_string, :non_syntax)
    end
  end
end
