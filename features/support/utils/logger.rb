require 'logger'
module GeneralUtils

  #
  # Create logger with the default log level of Debug
  #
  # TODO improve the formatter so we can show progname or class::method that calls the logger
  def self.create_logger
    $logger = Logger.new(STDOUT)
    $logger.level = Logger::DEBUG
    $logger.formatter = proc do |severity, datetime, progname, msg|
      date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
      if severity == "INFO" or severity == "WARN"
        "[#{date_format}] #{severity}  (#{progname}): #{msg}\n"
      else
        "[#{date_format}] #{severity} (#{progname}): #{msg}\n"
      end
    end
  end

end