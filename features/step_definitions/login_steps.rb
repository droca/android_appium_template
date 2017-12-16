#########
# WHEN  #
#########

When(/^I swipe to the (.+) side$/) do |direction|
  case direction.downcase
  when 'left'
    swipe start_x: Entities::Device.screen.width-1, start_y: Entities::Device.screen.height/2, end_x: 1, end_y: Entities::Device.screen.height/2
  when 'right'
    swipe start_x: 1, start_y: Entities::Device.screen.height/2, end_x: Entities::Device.screen.width-1, end_y: Entities::Device.screen.height/2
  else
    raise "Swipe to #{direction} not implemented"
  end
end

When(/^I click the SignIn button$/) do
  wait { id("#{APP_PACKAGE_NAME}:id/splash_login_button").click }
end

When(/^I try to login using (.+) credentials$/) do |validity|
  case validity.downcase
  when 'valid'
    id("#{APP_PACKAGE_NAME}:id/fragment_login_et_email").send_keys($client.email)
    id("#{APP_PACKAGE_NAME}:id/fragment_login_et_password").send_keys($client.password)
  when 'invalid'
    id("#{APP_PACKAGE_NAME}:id/fragment_login_et_email").send_keys('invalid_email')
    id("#{APP_PACKAGE_NAME}:id/fragment_login_et_password").send_keys('invalid_password')
  else
    raise "You provided #{validity} but the parameter can only be 'valid' or 'invalid'."
  end
  id("#{APP_PACKAGE_NAME}:id/fragment_login_button_done").click
end

When(/^I try to login without providing an? (.+)$/) do |param|
  case param.downcase
  when 'email'
    id("#{APP_PACKAGE_NAME}:id/fragment_login_et_password").send_keys('invalid_password')
  when 'password'
    id("#{APP_PACKAGE_NAME}:id/fragment_login_et_email").send_keys('invalid_email')
  else
    raise "Parameter #{param} is not a valid one."
  end
  id("#{APP_PACKAGE_NAME}:id/fragment_login_button_done").click
end

#########
# THEN  #
#########

Then(/^I'm(not)? logged in$/) do |negative|
  if negative
    wait { id("#{APP_PACKAGE_NAME}:id/fragment_not_logged_in") }
  else
    wait { id("#{APP_PACKAGE_NAME}:id/fragment_logged_in") }
  end
end
