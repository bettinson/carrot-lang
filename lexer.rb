# require 'byebug'

class Token
  attr_accessor :value, :type
  def initialize(value, type)
    @value = value
    @type = type
  end
end

class Lexer
  def self.lex(string)
    @reserved_words = Hash.new
    @reserved_words["photos"] = true
    @tokens = []
    @current_word = ""
    inQuotes = false
    inTag = false
    string.split('').select.each do |s|
      case s
      when /^[[:alpha:]]$/ # Is letters
        @current_word << s
      when '\''
        inQuotes ? inQuotes = false : inQuotes = true
        @current_word << s
      when ' '
        add_symbol(:word, :space, s)
      when '<'
        @current_word << s
        inTag = true
      when '/'
        @current_word << s
      when '>'
        if inTag
          @current_word << s
          @tokens << Token.new(@current_word, :html_tag) if self.word_is_valid
          @current_word = ""
        end
        inTag = false
      when '{'
        if @current_word[0] == '{'
          @current_word << s
          token = Token.new(@current_word, :begin_bracket) if self.word_is_valid
          @tokens << token
          @current_word = ""
        elsif @current_word[0] != '{'
          token = Token.new(@current_word, :word) unless @current_word == ""
          @tokens << token
          @current_word = ""
          @current_word << s
        end
      when '}'
        if @current_word[0] == '}'
          @current_word << s
          @tokens << Token.new(@current_word, :end_bracket) unless @current_word != ""
          @current_word = ""
        elsif @current_word[0] != '}' && @current_word.length != 0
          # Got to end of bracket, add word we've go
          token = Token.new(@current_word, :word) if self.word_is_valid
          @tokens << token
          @current_word = ""
          @current_word << s
        else
          @current_word << s
        end
      when '='
        add_symbol(:word, :equals, s) if self.word_is_valid
      when '.'
        add_symbol(:word, :dot, s)
      when '\n'
        add_symbol(:word, :new_line, s)
      when '"'
        add_symbol(:variable, :quote, s)
      when ','
        add_symbol(:word, :word, s)
      else 
        @tokens << Token.new(@current_word, :non_syntax) if self.word_is_valid
        @current_word = ""
      end
    end
    return @tokens
  end
  
  private
  def self.add_symbol(previousToken, nextToken, s)
    @tokens << Token.new(@current_word, previousToken) unless @current_word == ""
    @current_word = ""
    @tokens << Token.new(s, nextToken)
  end

  def self.word_is_valid
    if @reserved_words[@current_word] == true
      raise ArgumentError
    end
    @current_word == "" or @reserved_words.has_key?(@current_word) ? false : true
  end
end

# toks = Lexer.lex('{{title = "Matt\'s blog"}}')
#
# toks.each do |s|
#   puts s.value + "\t" + s.type.to_s unless s.class != Token
# end
