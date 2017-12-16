module Entities

  class Client

    def initialize(file, key)
      client_data = GeneralUtils::ConfigReader.new(file, key)
      @email = client_data.email
      @password = client_data.password
    end

    attr_accessor :email, :password

  end
end
