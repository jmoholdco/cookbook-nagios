require 'chefspec'
require 'chefspec/berkshelf'
require 'chef-vault/test_fixtures'
require 'json'

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.include ChefVault::TestFixtures.rspec_shared_context

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  else
    config.default_formatter = 'progress'
  end

  config.fail_fast = true
  config.platform = 'centos'
  config.version = '7.1.1503'
  config.file_cache_path = '/var/cache'

  config.before(:each) do
    stub_command('which php').and_return('/usr/bin/php')
    stub_command('test -d /etc/php-fpm.d || mkdir -p /etc/php-fpm.d')
      .and_return(0)
  end
end

def parse_data_bag(path)
  data_bags_path = File.expand_path(
    File.join(File.dirname(__FILE__), '../test/integration/data_bags')
  )
  JSON.parse(File.read("#{data_bags_path}/#{path}"))
end
