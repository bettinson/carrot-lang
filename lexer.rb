require 'byebug'

class Token
  attr_accessor :value, :type
  def initialize(value, type)
    @value = value
    @type = type
  end
end

class Lexer
  def self.lex(string)
    tokens = []
    current_word = ""
    inQuotes = false
    string.split('').select.each do |s|
      case s
      when /^[[:alpha:]]$/ # Is letters
        current_word << s
      when '\''
        inQuotes ? inQuotes = false : inQuotes = true
        current_word << s
      when ' '
        current_word << s unless !inQuotes
      when '{'
        if current_word[0] == '{'
          current_word << s
          token = Token.new(current_word, :begin_bracket) unless current_word == ""
          tokens << token
          current_word = ""
        elsif current_word[0] != '{'
          token = Token.new(current_word, :word) unless current_word == ""
          tokens << token
          current_word = ""
          current_word << s
        end
      when '}'
        if current_word[0] == '}'
          current_word << s
          tokens << Token.new(current_word, :end_bracket) unless current_word == ""
          current_word = ""
        elsif current_word[0] != '}' && current_word.length != 0
          # Got to end of bracket, add word we've go
          token = Token.new(current_word, :word) unless current_word == ""
          tokens << token
          current_word = ""
          current_word << s
        else
          current_word << s
        end
      when '='
        tokens << Token.new(current_word, :word) unless current_word == ""
        current_word = ""
        tokens << Token.new(s, :equals)
      when '.'
        tokens << Token.new(current_word, :word) unless current_word == ""
        current_word = ""
        tokens << Token.new(s, :dot)
      when '"'
        tokens << Token.new(current_word, :word) unless current_word == ""
        current_word = ""
        tokens << Token.new(s, :quote)
      else
        puts s
        raise Exception.new("Invalid character")
      end
    end
    return tokens
  end
end

toks = Lexer.lex('{{title = "Matt\'s blog"}}')

toks.each do |s|
  puts s.value + "\t" + s.type.to_s unless s.class != Token
end
