#  figure            :float
#  name              :text
#  description       :text

class Statistics
  attr_accessor :figure
  attr_accessor :name
  attr_accessor :description

  def initialize(name, description)
    self.name = name
    self.description = description
  end

  # all the money currently being lent
  def calculate_money_outside
    # we take all the loans currently running

  end
end
