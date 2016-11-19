# require 'byebug'
require 'test/unit'
require 'test/unit/ui/console/testrunner'
require './lexer.rb'
require './preprocessor.rb'

class LexerTest < Test::Unit::TestCase
  def test_simple_token_array
    toks = Lexer.lex('{{title = "Matt\'s blog"}}')
    test_array = ["{{", "title", "=", '"', "Matt's blog", '"', "}}"]
    index = 0
    toks.select{|c| c.class == Token }.each do |s|
      assert_equal s.value, test_array[index]
      index = index + 1
    end
  end
end

class PreProcessorTest < Test::Unit::TestCase
  def test_basic_var_assignment
    test_hash = Hash.new
    test_hash["var"] = "Matt"
    assert_equal PreProcessor.process_line('{{var = "Matt"}}'), test_hash
  end

  def test_var_assignment_then_overwrite
    test_hash = Hash.new
    test_hash["var"] = "Hat"
    assert_equal PreProcessor.process_line('{{var = "Matt", var = "Hat"}}'), test_hash
  end
end
