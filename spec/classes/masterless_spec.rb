require 'spec_helper'

describe 'puppet::masterless' do
  let(:title) {'puppet::masterless'}
  let(:cron_file) {'/usr/local/sbin/puppet-apply'}

  describe 'by default' do
    let(:facts) { {} }

    specify { should contain_file(cron_file).with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755'
      )
    }
    specify { should contain_file(cron_file).without_content(/mail/) }
    specify { should contain_cron('puppet').with_ensure('present') }
  end

  describe 'with ensure => absent' do
    let(:params) { {:ensure => 'absent'} }

    specify { should contain_file(cron_file).with_ensure('absent') }
    specify { should contain_cron('puppet').with_ensure('absent') }
  end

  describe 'with invalid ensure' do
    let(:params) { {:ensure => 'invalid'} }

    it do
      expect { should contain_file(cron_file) }.to raise_error(Puppet::Error, /invalid/)
    end
  end

  describe 'with enable => false' do
    let(:params) { {:enable => false} }

    specify { should contain_file(cron_file).with_ensure('present') }
    specify { should contain_cron('puppet').with_ensure('absent') }
  end

  describe 'should not accept invalid conf_dir' do
    let(:params) { {:conf_dir => 'invalid conf_dir'} }

    it do
      expect { should contain_file(cron_file) }.to raise_error(Puppet::Error, /invalid conf_dir/)
    end
  end

  describe 'should not accept invalid manifest_file' do
    let(:params) { {:manifest_file => 'foo bar'} }

    it do
      expect { should contain_file(cron_file) }.to raise_error(Puppet::Error, /foo bar/)
    end
  end

  describe 'should not accept invalid cron_file' do
    let(:params) { {:cron_file => 'foo bar'} }

    it do
      expect { should contain_file(cron_file) }.to raise_error(Puppet::Error, /foo bar/)
    end
  end

  describe 'with cron_file => /some/path' do
    let(:params) { {:cron_file => '/some/path'} }

    specify { should contain_file('/some/path').with_ensure('present') }
    specify { should contain_cron('puppet').with_command('/some/path') }
  end

  describe 'with mail_to => foobar@example.com' do
    let(:params) { {:mail_to => 'foobar@example.com'} }

    specify { should contain_file(cron_file).with_content(/mail/) }
    specify { should contain_file(cron_file).with_content(/foobar@example.com/) }
  end

  describe 'with empty mail_to' do
    let(:params) { {:mail_to => ''} }

    specify { should contain_file(cron_file).without_content(/mail/) }
  end

  describe 'with subject => puppet changed something' do
    let(:params) { {:mail_to => 'root@example.com', :mail_subject => 'puppet changed something'} }

    specify { should contain_file(cron_file).with_content(/mail -s "puppet changed something"/) }
  end

  describe 'with empty mail_subject' do
    let(:params) { {:mail_to => 'root@example.com', :mail_subject => ''} }

    it do
      expect { should contain_file(cron_file) }.to raise_error(Puppet::Error, /mail_subject/)
    end
  end
end
