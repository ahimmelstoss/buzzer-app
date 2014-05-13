require_relative 'spec_helper'

describe Buzzer do 
  it 'should run buzzer command' do 
    buzzer = Buzzer.new
    buzzer.should_receive('system').with('/usr/local/sbin/open-buzzer')
    buzzer.open_door
  end
end

describe User do 
  it 'Alex is an admin' do 
    @alex.admin?.should be_true
  end

  it 'Amanda is an admin' do 
    @amanda.admin?.should be_true
  end

  it 'Bear is not an admin' do 
    @bear.admin?.should be_false
  end

  it 'password matches' do 
    @bear.password?("honey").should be_true
  end

  it 'password does not match' do 
    @bear.password?("Honey").should be_false
  end
end