require_relative './init'


class HelperRequest
  include MongoMapper::Document

  belongs_to :request, :class_name => "Request"
  belongs_to :helper, :class_name => "Helper"

  timestamps!

end
