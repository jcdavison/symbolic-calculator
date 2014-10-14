class UndefinedVariableError < StandardError; end
require 'pry'

class Expression
  attr_accessor :expr, :left, :node, :right, :tokens
  def initialize(expr)
    @expr = expr
    @tokens = @expr.split(" ")
    set_tree
  end

  def set_tree
    @left = @tokens[0]
    @right = @tokens[1]
    @node = @tokens[2]
  end

  def evaluate(bindings = {})
    undefined_variables?(bindings)

  end
  
  def undefined_variables?(bindings)
    var_definitions = @tokens.inject({}) do |definitions, token|
      if is_variable? token
        definitions[token] = bindings.any? {|k,v| k.to_s == token}
      end
      definitions
    end
    raise_var_error? var_definitions, bindings
  end

  def is_variable? var
    var.to_s.match(/^:?[a-zA-Z]*$/)
  end

  def is_value? var
    var.to_s.match(/^\d*$/)
  end

  def raise_var_error? var_definitions, bindings
    if var_definitions.any? {|k,v| v == false} 
      raise UndefinedVariableError
    elsif bindings.empty? && has_variables?
      raise UndefinedVariableError
    end
  end

  def has_variables?
    container = @expr.split(" ").inject([]) do |container, element|
      containter.push true if is_variable? element
      container
    end
    container.length >= 1
  end
end
