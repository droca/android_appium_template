#########
# GIVEN #
#########

#This step might be kind of confusing because it's actually uninstalling the app
Given(/^I don't have the app installed$/) do
  if Open3.capture3("adb uninstall #{APP_PACKAGE_NAME}")[0].strip == 'Success'
    $logger.debug "#{APP_PACKAGE_NAME} uninstalled correctly"
  else
    $logger.debug "#{APP_PACKAGE_NAME} not present on the device, not trying to uninstall"
  end
end

Given(/^I have the app installed$/) do
  if Open3.capture3("adb shell pm list packages | grep #{APP_PACKAGE_NAME}")[0].strip == "package:#{APP_PACKAGE_NAME}"
    $logger.debug "#{APP_PACKAGE_NAME} app already installed"
  else
    $logger.debug "#{APP_PACKAGE_NAME} not present on the device, trying to install"
    `adb shell pm install -r #{APK_DIR}/#{APK_NAME}`
    if Open3.capture3("adb shell pm list packages | grep #{APP_PACKAGE_NAME}")[0].strip == "package:#{APP_PACKAGE_NAME}"
      $logger.debug "#{APP_PACKAGE_NAME} installed correctly"
    else
      raise "#{APP_PACKAGE_NAME} not installed correctly. Stopping text execution."
    end
  end
end

########
# WHEN #
########

When(/^I install the app$/) do
  `adb shell pm install -r #{APK_DIR}/#{APK_NAME}`
end

When(/^I launch the app$/) do
  `adb shell am start -n #{APP_PACKAGE_NAME}/com.stuart.client.activities.MainActivity`
end

When(/^I select the (.*) domain$/) do |domain|
  element = wait { id("#{APP_PACKAGE_NAME}:id/logo") }
  for i in 1..3
    element.click
  end
  find_element(:xpath, "//android.widget.RadioButton[@text=\"#{domain}\"]").click
  id("#{APP_PACKAGE_NAME}:id/change_domain_dialog_btn_save").click
  wait { id("#{APP_PACKAGE_NAME}:id/logo") }
end
