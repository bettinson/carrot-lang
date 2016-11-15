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

class AST

end
