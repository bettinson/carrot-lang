require 'byebug'

class Lexer
  def self.lex(string)
    tokens = []
    current_word = ""
    string.split('').select { |c| c!= ' ' }. each do |s|
      case s
      when /^[[:alpha:]]$/ # Is letters
        current_word << s
      when '{'
        if current_word[0] == '{'
          current_word << s
          tokens << current_word
          current_word = ""
        elsif current_word[0] != '}' && current_word.length != 0
          tokens << current_word
          current_word = ""
          current_word << s
        end
      when '}'
        if current_word[0] == '}'
          current_word << s
          tokens << current_word
          current_word = ""
        elsif current_word[0] != '}' && current_word.length != 0
          tokens << current_word
          current_word = ""
          current_word << s
        else
          current_word << s
        end
      when '='
        tokens << current_word
        current_word = ""
        tokens << s
      else
        puts s
        raise Exception.new("Invalid character")
      end
    end
    return tokens
  end
end

toks = Lexer.lex("Lol{{Hey = lol}}")

toks.each do |s|
  puts s
end
