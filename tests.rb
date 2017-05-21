#!/usr/bin/env ruby

DEVICE = "iPhone 7"
IOS_VERSION = "10.1"
CI = ENV["CI"] ? true : false

def run(command)
  puts(command)
  @any_failures ||= !system(command)
end

def xcodebuildCommand(command)
  if command == :build then
    "clean build"
  elsif command == :test then
    "test"
  else
    raise "Unhandled xcodebuild command"
  end
end

def xcodebuildCodeCoverage(command)
  command == :test ? "-enableCodeCoverage YES" : ""
end

def xcodebuild(command, scheme)
  run "set -o pipefail && \
    xcodebuild #{xcodebuildCommand(command)} \
      -workspace HolistiKit.xcworkspace \
      -scheme '#{scheme}' \
      -destination 'platform=iOS Simulator,name=#{DEVICE},OS=#{IOS_VERSION}' \
      #{xcodebuildCodeCoverage(command)} \
    | xcpretty"
end

def submit_codecov
  if CI
    #run "bash <(curl -s https://codecov.io/bash) -J '^#{scheme}$'"
    #run "curl -s https://codecov.io/bash | bash -s - -J '^#{scheme}$'"
    run "curl -s https://codecov.io/bash | bash -s - -X xcodeplist"
  end
end

[:SpecUIKitFringes, :UIKitFringes, :ExampleApp].each do |scheme|
  xcodebuild(:build, scheme)
  xcodebuild(:test, scheme)
end

submit_codecov

if @any_failures then
  raise "Tests failed"
end

