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

end
