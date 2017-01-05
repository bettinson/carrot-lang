require 'byebug'

# TODO 
# Create string stream and lexer and lexerstream
#

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

    case @stream.front
    when '{'
      if @stream.front == '{'
        @stream.pop_front
        return Token.new('{{', :begin_bracket)
      end
    when '}'
      @stream.pop_front
      if @stream.front == '}'
        @stream.pop_front
        @stream.in_syntax = false
        return Token.new('}}', :end_bracket)
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

# Handles translation from .html.crt files to a string of tokens
#class Lexer
#  def self.lex(string)
#    @reserved_words = {}
#    @reserved_words['photos'] = true
#    @tokens = []
#    @current_word = ''
#    in_quotes = false
#    in_syntax = false
#    string.split('').select.each do |s|
#      case s
#      when '{'
#        if @current_word[0] == '{'
#          @current_word << s
#          token = Token.new(@current_word, :begin_bracket)
#          @tokens << token
#          @current_word = ''
#        elsif @current_word[0] != '{'
#          in_syntax = true
#          token = Token.new(@current_word, :string) unless @current_word == ''
#          @tokens << token
#          @current_word = ''
#          @current_word << s
#        end
#      when '}'
#        in_syntax = false
#        if @current_word[0] == '}'
#          @tokens << Token.new(@current_word, :end_bracket)
#          @current_word = ''
#        elsif @current_word[0] != '}'
#          # Got to end of bracket, add word we've go
#          token = Token.new(@current_word, :string)
#          @tokens << token
#          @current_word = ''
#          @current_word << s
#        else
#          @current_word << s
#        end
#      end
#      
#      if in_syntax
#        case s
#        when ' '
#          break
#        when /^[[:alpha:]]$/ # Is letters
#          @current_word << s
#        when "'"
#          @current_word << s
#        when '='
#          add_symbol(:variable, :equals, s) if word_is_valid
#        when '.'
#          add_symbol(:variable, :dot, s)
#        when '\n'
#          add_symbol(:word, :new_line, s)
#        when '"'
#          add_symbol(:word, :quote, s)
#        end
#      else
#        @current_word << s
#      end
#    end
#    @tokens.each do |s|
#       puts s.value + "\t" + s.type.to_s unless s.class != Token
#    end
#    @tokens
#  end
#  
#  def self.add_symbol(previousToken, nextToken, s)
#    @tokens << Token.new(@current_word, previousToken)
#    @current_word = ''
#    @tokens << Token.new(s, nextToken)
#  end
#
#  def self.word_is_valid
#    if @reserved_words[@current_word] == true
#      raise ArgumentError
#    end
#    @current_word == '' || @reserved_words.key?(@current_word) ? false : true
#  end
#end
#
# toks = Lexer.lex('{{title = "Matt\'s blog"}}')
#
