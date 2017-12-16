$LOAD_PATH << '.'
require 'rspec/expectations'
require 'appium_lib'
require 'cucumber/ast'

require 'features/support/entities/client'
require 'features/support/entities/device'
require 'features/support/utils/android_utils'
require 'features/support/utils/read_config'
require 'features/support/utils/logger'
require 'byebug'

APK_DIR = '/sdcard/automated_testing'
APK_NAME = 'app_under_test.apk'
APP_PATH = "./builds/#{APK_NAME}"
APP_PACKAGE_NAME = 'here_goes_the_package_name'

GeneralUtils.create_logger
AndroidUtils.log_device_info

$client = Entities::Client.new('./data/client.yml', 'test_client')

caps_path = "./config/appium_capabilities/appium.txt"
caps = Appium.load_appium_txt file: File.expand_path(caps_path), verbose: true
caps[:caps].merge!(app: File.expand_path(APP_PATH))

AndroidUtils.create_appium_driver(caps)

if `adb devices -l | grep "model"`.empty?
  begin
    raise StandardError
  rescue => e
    message = "No device connected / emulator not running\r\n"+ e.backtrace.join("\r\n")
    $logger.error message
    exit
  end
end

`adb push #{File.expand_path(APP_PATH)} #{APK_DIR}/#{APK_NAME}.apk`
`adb shell pm install -r #{APK_DIR}/#{APK_NAME}`

Before {
  `adb shell pm clear #{APP_PACKAGE_NAME}`
}

After {
}

# Clean the apk files and uninstall the apps
at_exit {
  $logger.info('Stopping Appium process')
  $logger.info('Deleting apk files and installed apps')
  `adb shell rm #{APK_DIR}/#{APK_NAME}`

  if Open3.capture3("adb uninstall #{APP_PACKAGE_NAME}") == 'Success'
    $logger.debug "Uninstalled #{APP_PACKAGE_NAME} correctly"
  else
    $logger.debug "#{APP_PACKAGE_NAME} not present on the device, not trying to uninstall"
  end

  AndroidUtils.stop_appium
}
