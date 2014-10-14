class UndefinedVariableError < StandardError; end
require 'pry'

# this feels like there a significant error with the way I'm tokenizing that subsequently impacts the entire program.

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
    if @node == "+" 
      x = substitute(@left, bindings)
      y = substitute(@right, bindings)
      x.to_i + y.to_i
    end
  end

  def substitute variable, bindings
    if bindings[variable.to_sym]
      bindings[variable.to_sym]
    else
      variable
    end
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
