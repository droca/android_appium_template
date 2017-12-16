module GeneralUtils

  #
  # Reads the content of a yaml file and stores values in instance variables
  #
  class ConfigReader

    def initialize(file, key)
      extract_key_values(file, key)
    end

    def extract_key_values(file, key)
      data = read_config(file)

      begin
        data.fetch(key).each do |key, value|
          instance_variable_set("@#{key}", value)
          self.class.send(:attr_accessor, key)
        end
      rescue => e
        raise e, "Problems with key '#{key}' from file #{file}"
      end

    end

    private

    def read_config(file)
      YAML.load_file(file)
    end

  end

end
