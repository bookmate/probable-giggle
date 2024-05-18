class FakeMysqlConnection
  attr_reader :return_value

  def initialize(return_value: 1)
    @return_value = return_value
  end

  def execute(_query)
    [return_value, 0, "localhost"]
  end

  def quote(str)
    "'#{str}'"
  end
end
