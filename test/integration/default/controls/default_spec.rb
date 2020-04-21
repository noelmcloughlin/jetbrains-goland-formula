# frozen_string_literal: true

title 'goland archives profile'

control 'goland archive' do
  impact 1.0
  title 'should be installed'

  describe file('/etc/default/goland.sh') do
    it { should exist }
  end
  # describe file('/usr/local/jetbrains/goland-*/bin/goland.sh') do
  #   it { should exist }
  # end
  describe file('/usr/share/applications/goland.desktop') do
    it { should exist }
  end
  describe file('/usr/local/bin/goland') do
    it { should exist }
  end
end
