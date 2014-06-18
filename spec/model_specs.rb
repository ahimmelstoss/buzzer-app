require_relative 'spec_helper'

describe Buzzer do 
  it 'should run buzzer command' do 
    buzzer = Buzzer.new
    expect(buzzer).to receive('system').with('/usr/local/sbin/open-buzzer')
    buzzer.open_door
  end
end

describe User do 
  it 'Alex is an admin' do 
    expect(@alex.admin?).to be true
  end

  it 'Amanda is an admin' do 
    expect(@amanda.admin?).to be true
  end

  it 'Bear is not an admin' do 
    expect(@bear.admin?).to be false
  end

  it 'password matches' do 
    expect(@bear.password?("honey")).to be true
  end

  it 'password does not match' do 
    expect(@bear.password?("Honey")).to be false
  end
end