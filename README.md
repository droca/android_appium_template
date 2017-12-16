### What it does
Using Cucumber and Appium (http://appium.io/, based on Selenium) we define and run the test on the connected Android device.
When configuring Cucumber, the APK files stored in the `builds` folder are copied to the device's internal storage. This is done just once to save execution time.
Before each scenario, the application is uninstalled and reinstalled, by `adb` commands, using the APK files stored in the device. This is done as a Background scenario that has to be defined in eash of the features.
When all the tests have been executed, the installed apps are uninstalled and the APK files are deleted, leaving the phone as it was before running the tests.

### Preparation
Our app APK files have to be stored in the `builds` folder and should be named `app_under_test.apk`.

For the moment, some of the tests might only work when the has the English(US) locale set.

#### Device Preparation
Since the tests are executed on a real device, we need to prepare it so Appium can interact with it.

Follow these instructions:

1. Enable the `Developer options` section in your device, if you do not have it enabled already
 1. In your device, go to `Settings -> About phone` section
 2. Search for the option `Build number` and tap it several times until you see a message saying that you are a developer
2. Go to `Settings -> Developer options` section and enable the option `Android debugging`
3. Go to `Settings -> Security` section and enable the option `Unknown sources`
4. Connect your device to your computer

A message asking for permissions to trust the computer will appear. Accept.

#### Local machine Preparation

##### Ruby
Ruby needs to be installed in the machine, more specifically v.2.3.0

You can install [RVM](https://rvm.io/) to manage the ruby versions installed. It's possible that you are asked to also install Homebrew when installing ruby via RVM.

##### Bundler

Bundler provides a consistent environment for Ruby projects by tracking and installing the exact gems and versions that are needed.

First of all it's mandatory to install bundler itself with:

```Shell
$ gem install bundler
```

Install all of the required gems from your specified sources and then start to work on a project is as simple as:

```Shell
$ bundle install
```

The project dependencies are listed in the [`Gemfile`](Gemfile) file.

##### ADB

Follow these steps to prepare the computer:

1. Download `Android Studio` from here http://developer.android.com/sdk/index.html or just the platform tools https://developer.android.com/studio/releases/platform-tools.html

This will install the `adb` tool which it's needed to interact with the connected device.

2. Add the `platform-tools` folder in your PATH to be able to execute adb just by typing `adb` on your terminal:
	- Open your terminal
	- Create or edit the .bash_profile file on your Home directory:

	```Shell
	$ nano .bash_profile`
	```

	- Add the line:

	```Shell
	$ export PATH="$PATH:path_to_the_android_tools/platform-tools"

	```

	- Save the file and exit.
	- Execute:

	```Shell
	$ source .bash_profile
	```

##### APPIUM

Also, `appium` needs to be installed, by following these instructions:

1. Install Appium using `npm`, running `npm install -g appium`, as suggested in the official page: http://appium.io/getting-started.html
 - If you do not have `npm` installed, do it by running the following command:

    ```Shell
    brew install npm
    ```

2. Install [appium doctor](https://github.com/appium/appium-doctor), by running `npm install appium-doctor -g`, and run it with `appium-doctor --android` to make sure everything is working fine with the Appium installation.

### Compatibility
Appium only supports automation for Android API Level >=17 (Android 4.2 and up) so this is our limitation.
Also, for API Level 17 we cannot locate elements using `id` or `resource_id`, because this capability was introduced in API Level 18.
For lower API Levels we would be forced to use Selendroid.
Also, assuming that different android versions will have available slightly different UI or even functionality, the test framework detect automatically the device OS version and executes the corresponding Cucumber profile, that will only run the tests that include the corresponding tag.


### Execution
First of all plug in the Android device to the computer.
Run the command `bundle install` to install any missing gems that are required for execution the tests.
Type the command `rake` to run all the tests corresponding to the connected device. We automatically detect the brand & version of the connected device and then we execute the corresponding Features/Scenarios, based on the tags on each Feature/Scenario.
Run `rake -T` to see all the tasks available with their descriptions.
The current implementation takes care of also starting an Appium server without the user having to do anything, since it uses `Foreman` (https://github.com/ddollar/foreman) to run it along the tests, with just executing one rake task.

### Limitations

The framework is built on top of a MacOS system: some of the utils that are used, could be not available on other OS so the execution of the tests on OS other than might/will not be successful.

### Technological stack

This framework is built using a *three layer* testing suite composed by:

* First layer:
	*  `Ruby`: Used for the actual tests.
* Second layer:
	*  `Appium`: Used to interact with the connected device.
* Third layer:
	*  `Cucumber`: Used for running automated tests written in plain language.


## Potential improvements
  - Stop installing the application on each scenario and implement a generic way to log out in the `after` hook
  - Write more high level steps, instead of focusing on specific actions
  - Follow a PageObject model to map the elements in the different app views
  - Implement faster clicks to access faster to the domain selection screen (I don't know if that is possible though)
  - Create an instance of the Device Entity instead of using the class itself to call the methods.
  - Since we are capturing the device locale, we could add a locales yml file containing the translations for key messages we want to check, for the corresponding locale.

  - Assume that it is a bug based on the requirements: on forget password, when an email for an unexisting user is entered we give feedback saying that the user doesn't exist. We should not give this feedback since it's something that can be exploited as a security issue.
