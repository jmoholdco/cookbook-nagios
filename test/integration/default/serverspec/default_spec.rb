require 'spec_helper'

RSpec.describe 'nagios::default' do
  describe file('/usr/local/nagios') do
    it { is_expected.to be_directory }
    it { is_expected.to exist }
  end

  describe service('httpd') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe service('nagios') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe service('mysql-nagios') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe user('nagios') do
    it { is_expected.to exist }
    it { is_expected.to belong_to_group 'nagios' }
    it { is_expected.to belong_to_group 'nagcmd' }
  end

  describe user('apache') do
    it { is_expected.to exist }
    it { is_expected.to belong_to_group 'nagcmd' }
  end
end
