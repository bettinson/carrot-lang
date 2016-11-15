require 'byebug'
require './lexer.rb'

class Node
  attr_accessor :left
  attr_accessor :right
  attr_accessor :token

  def initialize(left, right, token)
    @left = left
    @right = right
    @token = token
  end
end

class Preprocessor
  def self.process_line(line)
    @hash = Hash.new
    tokens = Lexer.lex(line)

    createHashMapOfVariables(tokens)
    puts @hash
    return tokens
  end

  private
  def self.createHashMapOfVariables(tokens)
    current_variable_name = nil
    current_variable_content = nil
    tokens.select{|c|  c.class == Token }.each do |t|
      # If its a word (as in, name of a variable), then we check if the hash has that word in it.
      # If it does, we replace the occurence of that word with the variable

      # TODO: Check if next token is '=', so if I already have a value for a variable name I can overwrite it
      if t.type == :word
        if @hash.has_key?(t.value)
          # Replace word with variable
        else
          current_variable_name = t.value
        end
      end
      if t.type == :variable
        current_variable_content = t.value
        @hash[current_variable_name] = current_variable_content unless current_variable_name.nil?
      end
    end
  end

  public
end

Preprocessor.process_line('{{var = "Matt"}}')

# prepro.each do |s|
#   puts s.value + "\t" + s.type.to_s unless s.class != Token
# end
