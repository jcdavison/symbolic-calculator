class Stack
  def initialize
    @stack = []
  end

  def pop
    @stack.pop
  end

  def push(element)
    @stack.push(element)
  end

  def peek
    @stack[-1]
  end
end

