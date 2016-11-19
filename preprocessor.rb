require './lexer.rb'

class PreProcessor

  def initialize
  end

  def self.process_file(filepath)
    @hash = Hash.new
    @processed_lines = Array.new
    file=File.open(filepath).read
    file.each_line do |line|
      process_line(line)
    end
    return @hash
  end

  def self.process_line(line)
    tokens = Lexer.lex line
    @processed_lines << create_hash_map_of_variables(tokens)
  end

  private
  def self.create_hash_map_of_variables(tokens)
    current_variable_name = nil
    current_variable_content = nil
    in_syntax = false
    processed_string = ""
    tokens.select{|c| c.class == Token }.each do |t|
      # If its a word (as in, name of a variable), then we check if the hash has that word in it.
      # If it does, we replace the occurence of that word with the variable
      if t.type == :begin_bracket
        in_syntax = true
      end
      if t.type == :end_bracket and !in_syntax 
        raise Exception.new("Invalid syntax. Check to see if there are any '}}' that don't belong.")
      end
      if t.type == :word and in_syntax
        if @hash.has_key?(t.value)
          processed_string << @hash[t.value].to_s << " "
        end
        current_variable_name = t.value
      end
      if t.type == :variable and in_syntax
        current_variable_content = t.value
        @hash[current_variable_name] = current_variable_content unless current_variable_name.nil?
      end
    end
    return processed_string
  end
end

puts PreProcessor.process_file("test.html.crt")

# PreProcessor.process_line('{{var = "Matt", var, name = "mat", var = "Hey", var}}')

# output.each do |s|
#   puts s.value + "\t" + s.type.to_s unless s.class != Token
# end
