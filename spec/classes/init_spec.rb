require 'spec_helper'
describe 'uwsgi' do
  context 'with default values for all parameters' do
    it { should contain_class('uwsgi') }
  end
end
