require 'byebug'
require './lexer.rb'

class PreProcessor
  def self.process_file(filepath)
    @all_tokens = Array.new
    @hash = Hash.new
    @processed_lines = Array.new

    input_file=File.open(filepath).read

    input_file.each_line do |line|
      process_line(line)
    end
    # @all_tokens.each do |s|
    #   puts s.value + "\t" + s.type.to_s unless s.class != Token
    # end
    return @hash
  end

  def self.create_html_from_crt(filepath)
    hash_table = process_file(filepath)
    name = File.basename(filepath, ".html.crt")
    # Uses stack to create HTML tags. 
    html_stack = Array.new

    File.open(name + ".html", 'w') do |f|
      @all_tokens.each_with_index do |t, index|
        next_token = @all_tokens[index+1] unless @all_tokens[index+1].nil?
        if t.type == :word
          if hash_table.has_key?(t.value)
            # Ignore if variable is an assignment, because we already have the values
            # Definetly not the best way to do this.
            if next_token.type != :equals
              f << " " << hash_table[t.value.to_s]
            end
          else
            if t.value == ',' or t.value == '\''
              f << t.value.to_s 
            else
              f << " " << t.value.to_s
            end
          end
        end
        if t.type == :html_tag 
          # f << "\n"
          if html_stack.last == t.value
            html_stack.pop 
            f <<  t.value.to_s
          else
            html_stack << t.value
            f <<  t.value.to_s
          end
        # else # TODO: Don't add variable declarations
        #   f << t.value.to_s 
        # end
        end
        if t.type == :non_syntax or t.type == :end_bracket
          f << "\n"
        end
      end
    end
  end

  private
  def self.process_line(line)
    tokens = Lexer.lex line
    tokens.select{|c| c.class == Token }.each do |s|
      @all_tokens << s
    end
    @processed_lines << create_hash_map_of_variables(tokens)
  end

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

PreProcessor.create_html_from_crt("test.html.crt")

# PreProcessor.process_line('{{var = "Matt", var, name = "mat", var = "Hey", var}}')


