# rubocop:disable Style/For
# This is just enumerables methods
module Enumerable
  # Your code goes here
  def my_each
    return to_enum(:my_each) unless block_given?

    for el in self
      yield el
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    for el in self
      yield el, i
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    results = []
    my_each { |elemen| results.push(elemen) if yield elemen }
    results
  end

  def my_all?(pattern = nil)
   expr = block_given? ? ->(elem) { yield elem} : ->(elem) { pattern === elem}
   my_each { |elem| return false unless expr.call(elem) }
   false
  end

  def my_any?(pattern = nil)
    expr = block_given? ? ->(elem) { yield elem} : ->(elem) { pattern === elem}
    my_each { |elem| return true if expr.call(elem)}
    false
  end

  def my_none?(pattern = nil)
    expr = ->(elem) { yield elem } if block_given?
    expr = pattern ?
    ->(elem) { pattern === elem } :
    ->(elem) { false ^ elem } unless block_given?
    my_each { |elem| return false if expr.call(elem) }
    true
  end

  def my_count(item = nil)
    return length if item.nil? && !block_given?

    count = 0
    expr = block_given? ?
    ->(elem) { count += 1 if yield elem } :
    ->(elem) { count += 1 if item === elem }
    my_each { |elem| expr.call(elem) }
    count
  end

  def my_map(block = nil)
    return to_enum(:my_map) if !block_given? && block.nil?

    result = []
    expr = block_given? ? ->(elem) { yield(elem) } : ->(elem) { block.call(elemen) }
    my_each{ |elem| result << expr.call(elem) }
    result
  end

  def my_inject(*args)
    case args
    in[a] if a.is_a? Symbol
      sym = a
    in[a] if a.is_a? Object
      initial = a
    in[a,b]
      initial = a
      sym = b
    else
      initial = b
      sym = nil
    end

    memo = initial || first

    if block_given?
      my_each_with_index do |ele, i|
        next if initial.nil? && i.zero?

        memo = yield(memo, ele)
      end
    elsif sym
      my_each_with_index do |ele, i|
        next if initial.nil? && i.zero?

        memo = memo.send(sym, ele)
      end
    end
    memo
  end

  # You will first have to define my_each
  # on the Array class. Methods defined in
  # your enumerable module will have access
  # to this method
  class Array
    # Define my_each here
  end
end

# rubocop:enable Style/For
