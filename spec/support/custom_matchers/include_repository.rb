RSpec::Matchers.define :include_repository do |name, path|
  match do |repos|
    repos.any? { |r| r.name == name && r.path == path }
  end

  failure_message do |repos|
    "expected #{repos.inspect} to include repository (#{name}, #{path})"
  end
end
