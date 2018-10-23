require 'thor'

require_relative './lib/cmd'
require_relative './lib/print'

class Test < Thor
  XCODEBUILD_CMD_BASE = 'xcodebuild test -workspace XCTestHTMLReport.xcworkspace -scheme XCTestHTMLReportSampleApp -verbose'
  BIN_PATH = 'XCTestHTMLReport.xcarchive/Products/usr/local/bin/xchtmlreport'
  TEST_RESULTS_DIR = 'TestResults'

  desc 'once', 'Runs tests and creates an HTML Report'
  def once
    Print.info 'Running tests once with one HTML Report'

    Print.step "Deleting previous test results"
    Cmd.new('rm -rf #{TEST_RESULTS_DIR}/TestResultsA').run

    Print.step "Running tests"
    Cmd.new("#{XCODEBUILD_CMD_BASE} -destination 'platform=iOS Simulator,name=iPhone 8,OS=12.0' -resultBundlePath #{TEST_RESULTS_DIR}/TestResultsA | xcpretty").run

    Print.step "Generating report"
    Cmd.new("#{BIN_PATH} -r #{TEST_RESULTS_DIR}/TestResultsA -v").run
  end

  desc 'twice', 'Runs tests twice and creates an HTML Report'
  def twice
    Print.info 'Running tests twice with one HTML Report'

    Print.step "Deleting previous test results"
    Cmd.new('rm -rf #{TEST_RESULTS_DIR}/TestResultsA').run
    Cmd.new('rm -rf #{TEST_RESULTS_DIR}/TestResultsB').run

    Print.step "Running tests"
    Cmd.new("#{XCODEBUILD_CMD_BASE} -destination 'platform=iOS Simulator,name=iPhone 8,OS=12.0' -resultBundlePath #{TEST_RESULTS_DIR}/TestResultsA | xcpretty").run
    Cmd.new("#{XCODEBUILD_CMD_BASE} -destination 'platform=iOS Simulator,name=iPhone 8 Plus,OS=12.0' -resultBundlePath #{TEST_RESULTS_DIR}/TestResultsB | xcpretty").run

    Print.step "Generating report"
    Cmd.new("#{BIN_PATH} -r #{TEST_RESULTS_DIR}/TestResultsA -r #{TEST_RESULTS_DIR}/TestResultsB -v").run
  end

  desc 'parallel', 'Runs tests in parallel in multiple devices and creates an HTML Report'
  def parallel
    Print.info 'Running tests in parallel with one HTML Report'

    Print.step "Deleting previous test results"
    Cmd.new('rm -rf #{TEST_RESULTS_DIR}/TestResultsA').run

    Print.step "Running tests"
    Cmd.new("#{XCODEBUILD_CMD_BASE} -destination 'platform=iOS Simulator,name=iPhone X,OS=12.0' -destination 'platform=iOS Simulator,name=iPhone 7,OS=12.0' -destination 'platform=iOS Simulator,name=iPhone 8,OS=12.0' -resultBundlePath #{TEST_RESULTS_DIR}/TestResultsA | xcpretty").run

    Print.step "Generating report"
    Cmd.new("#{BIN_PATH} -r #{TEST_RESULTS_DIR}/TestResultsA -v").run
  end

  desc 'split', 'Runs tests split in multiple devices and creates an HTML Report'
  def split
    Print.info 'Running tests split with one HTML Report'

    Print.step "Deleting previous test results"
    Cmd.new("rm -rf #{TEST_RESULTS_DIR}/TestResultsA").run
    Cmd.new("rm -rf #{TEST_RESULTS_DIR}/TestResultsB").run

    Print.step "Running tests"
    Cmd.new("#{XCODEBUILD_CMD_BASE} -destination 'platform=iOS Simulator,name=iPhone 8,OS=12.0' -only-testing:XCTestHTMLReportSampleAppUITests/FirstSuite -resultBundlePath #{TEST_RESULTS_DIR}/TestResultsA | xcpretty").run
    Cmd.new("#{XCODEBUILD_CMD_BASE} -destination 'platform=iOS Simulator,name=iPhone X,OS=12.0' -only-testing:XCTestHTMLReportSampleAppUITests/SecondSuite -resultBundlePath #{TEST_RESULTS_DIR}/TestResultsB | xcpretty").run

    Print.step "Generating report"
    Cmd.new("#{BIN_PATH} -r #{TEST_RESULTS_DIR}/TestResultsA -r #{TEST_RESULTS_DIR}/TestResultsB -v").run
  end

  desc 'same_device', 'Runs UI and Unit tests in the same device'
  def same_device
    Print.info 'Running UI in the same device'

    Print.step "Deleting previous test results"
    Cmd.new("rm -rf #{TEST_RESULTS_DIR}/TestResultsA").run
    Cmd.new("rm -rf #{TEST_RESULTS_DIR}/TestResultsB").run

    Print.step "Running tests"
    Cmd.new("#{XCODEBUILD_CMD_BASE} -destination 'platform=iOS Simulator,name=iPhone X,OS=12.0' -only-testing:XCTestHTMLReportSampleAppUITests/FirstSuite -resultBundlePath #{TEST_RESULTS_DIR}/TestResultsA | xcpretty").run
    Cmd.new("#{XCODEBUILD_CMD_BASE} -destination 'platform=iOS Simulator,name=iPhone X,OS=12.0' -only-testing:XCTestHTMLReportSampleAppUITests/SecondSuite -resultBundlePath #{TEST_RESULTS_DIR}/TestResultsB | xcpretty").run

    Print.step "Generating report"
    Cmd.new("#{BIN_PATH} -r #{TEST_RESULTS_DIR}/TestResultsA -r #{TEST_RESULTS_DIR}/TestResultsB -v").run
  end
end
