# frozen_string_literal: true

class Unit

  attr_reader :quantity

  def initialize(quantity)
    @quantity = quantity || 0
  end

end
