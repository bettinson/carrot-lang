require 'byebug'
require './lexer.rb'

class PreProcessor
  def self.process_line(line)
    @hash = Hash.new
    tokens = Lexer.lex line
    @processed_line = create_hash_map_of_variables tokens
    return @hash
  end

  private
  def self.create_hash_map_of_variables(tokens)
    current_variable_name = nil
    current_variable_content = nil
    processed_string = ""
    tokens.select{|c| c.class == Token }.each do |t|
      # If its a word (as in, name of a variable), then we check if the hash has that word in it.
      # If it does, we replace the occurence of that word with the variable
      if t.type == :word
        if @hash.has_key?(t.value)
          processed_string << @hash[t.value].to_s << " "
        end
        current_variable_name = t.value
      end
      if t.type == :variable
        current_variable_content = t.value
        @hash[current_variable_name] = current_variable_content unless current_variable_name.nil?
      end
    end
    return processed_string
  end
end

PreProcessor.process_line('{{var = "Matt", var, name = "mat", var = "Hey", var}}')

# prepro.each do |s|
#   puts s.value + "\t" + s.type.to_s unless s.class != Token
# end
