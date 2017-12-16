########
# THEN #
########

Then(/^An? '(.+)' error message is shown$/) do |message|
  text_to_check = 'sample error message'
  case message.downcase
  when 'incorrect credentials'
    text_to_check = 'Email or password invalid'
  when 'fill in both fields'
    text_to_check = 'Please fill in both fields'
  end

  expect(id("#{APP_PACKAGE_NAME}:id/fragment_login_validation_error").text.include?(text_to_check)).to be true

end
