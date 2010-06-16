class UserSession < Authlogic::Session::Base
  attr_accessor :space_id
end
