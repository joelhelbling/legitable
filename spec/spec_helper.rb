require "bundler/setup"
require "legitable"
require "rspec/given"
require "pry"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec::Matchers.define :look_like do |expected|
  def left_shifted_expected
    expected.gsub(/^ {6}/, '')
  end

  match do |actual|
    actual == left_shifted_expected
  end

  description do
    "looks like ->\n#{expected}"
  end

  failure_message do |actual|
    <<-FAIL.gsub(/^ {6}/, '')
      __EXPECTED THIS____________________
      #{actual}

      __TO LOOK LIKE THAT________________
      #{left_shifted_expected}
    FAIL
  end
end
