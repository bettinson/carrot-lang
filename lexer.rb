# require 'byebug'

# Represents a symbol of values
class Token
  attr_accessor :value, :type
  def initialize(value, type)
    @value = value
    @type = type
  end
end

# Handles translation from .html.crt files to a string of tokens
class Lexer
  def self.lex(string)
    @reserved_words = {}
    @reserved_words['photos'] = true
    @tokens = []
    @current_word = ''
    in_quotes = false
    in_tag = false
    string.split('').select.each do |s|
      case s
      when /^[[:alpha:]]$/ # Is letters
        @current_word << s
      when '\''
        in_quotes ? in_quotes = false : in_quotes = true
        @current_word << s
      when ' '
        add_symbol(:word, :space, s)
      when '<'
        @current_word << s
        in_tag = true
      when '/'
        @current_word << s
      when '>'
        if in_tag
          @current_word << s
          @tokens << Token.new(@current_word, :html_tag) if word_is_valid
          @current_word = ''
        end
        in_tag = false
      when '{'
        if @current_word[0] == '{'
          @current_word << s
          token = Token.new(@current_word, :begin_bracket) if word_is_valid
          @tokens << token
          @current_word = ''
        elsif @current_word[0] != '{'
          token = Token.new(@current_word, :word) unless @current_word == ''
          @tokens << token
          @current_word = ''
          @current_word << s
        end
      when '}'
        if @current_word[0] == '}'
          @current_word << s
          @tokens << Token.new(@current_word, :end_bracket) if @current_word == ''
          @current_word = ''
        elsif @current_word[0] != '}' && @current_word.empty?
          # Got to end of bracket, add word we've go
          token = Token.new(@current_word, :word) if word_is_valid
          @tokens << token
          @current_word = ''
          @current_word << s
        else
          @current_word << s
        end
      when '='
        add_symbol(:word, :equals, s) if word_is_valid
      when '.'
        add_symbol(:word, :dot, s)
      when '\n'
        add_symbol(:word, :new_line, s)
      when '"'
        add_symbol(:variable, :quote, s)
      when ','
        add_symbol(:word, :word, s)
      else
        @tokens << Token.new(@current_word, :non_syntax) if word_is_valid
        @current_word = ''
      end
    end
    @tokens
  end
  
  def self.add_symbol(previousToken, nextToken, s)
    @tokens << Token.new(@current_word, previousToken) if @current_word.empty?
    @current_word = ''
    @tokens << Token.new(s, nextToken)
  end

  def self.word_is_valid
    if @reserved_words[@current_word] == true
      raise ArgumentError
    end
    @current_word == '' || @reserved_words.key?(@current_word) ? false : true
  end
end

# toks = Lexer.lex('{{title = "Matt\'s blog"}}')
#
# toks.each do |s|
#   puts s.value + "\t" + s.type.to_s unless s.class != Token
# end
