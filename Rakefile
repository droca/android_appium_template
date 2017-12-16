require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require './features/support/entities/device'

unless `adb devices -l | grep "model"`.empty?

  # Device properties detection
  Entities::Device.new

  @prof = "api#{Entities::Device.apilevel}".downcase

  raise StandardError, 'Incorrect profile format cancelling execution. ' \
                       "Current profile: #{@prof}" unless @prof =~ /^api[0-9]{1,}/
  raise StandardError, 'Unexisting profile. ' \
                       "Current profile #{@prof}" unless ['api17','api18','api19','api21','api22','api23','api24', 'api25'].include?(@prof)
end

namespace :environment do
  task 'test' do
    ENV['domain'] = 'Test'
  end
end

namespace :runners do
  Cucumber::Rake::Task.new('run'.to_sym, '') do |task|
    task.cucumber_opts = ["--profile #{@prof} --format pretty --out cucumber_last_execution.log --format pretty"]
    task.cucumber_opts << '-r features'
  end

  Cucumber::Rake::Task.new('run_fail_fast'.to_sym, '') do |task|
    task.cucumber_opts = ["--profile #{@prof} --fail-fast --format pretty --out cucumber_last_execution.log --format pretty"]
    task.cucumber_opts << '-r features'
  end

  Cucumber::Rake::Task.new('run_smoke'.to_sym, '') do |task|
    task.cucumber_opts = ["--profile #{@prof}_smoke --format pretty --out cucumber_last_execution.log --format pretty"]
    task.cucumber_opts << '-r features'
  end

end

namespace :foreman do
  task 'write_base_procfile' do
    File.open('./Procfile', 'w') {}
    File.open('./Procfile', 'a') { |file|
      file.write("appium: appium --log appium_last_execution.log --log-timestamp --log-level=error:debug\n")
    }
  end
end

desc "Run the whole test suite in Test environment"
task 'sandbox' do
  Rake::Task['environment:test'].execute
  Rake::Task['foreman:write_base_procfile'].execute # Write base content to Procfile

  # Write the rake command on the Procfile
  File.open('./Procfile', 'a') { |file|
    file.puts "cucumber: sleep 10; rake runners:run"
  }

  sh "foreman start"
end

desc "Run the Smoke test suite in Test environment"
task 'sandbox' do
  Rake::Task['environment:test'].execute
  Rake::Task['foreman:write_base_procfile'].execute # Write base content to Procfile

  # Write the rake command on the Procfile
  File.open('./Procfile', 'a') { |file|
    file.puts "cucumber: sleep 10; rake runners:run_smoke"
  }

  sh "foreman start"
end

# For the moment this task cannot be launched with Foreman, because of the local rake task defined inside
# This means that appium needs to be started separately
desc 'Run a the parametrized feature on the Test environment. Ex: rake test_feature[login.feature] or rake test_feature\[login.feature\]'
task 'test_feature', [:feature] do |t, args|
  Rake::Task['environment:test'].execute
  Cucumber::Rake::Task.new('run_feature') do |task|
    task.cucumber_opts = ["--profile #{@prof}"]
    task.cucumber_opts << "-r features features/#{args[:feature]}"
  end
  Rake::Task['run_feature'].execute
end


desc 'Default task, run tests in Test environment'
task :default => 'test'
