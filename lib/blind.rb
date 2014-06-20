require_relative './init'


class Blind < User

  key :role, String
  
  before_create :set_role
  
  def set_role()
    self.role = "blind"
  end

end