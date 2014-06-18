require_relative 'spec_helper'

#TODO: figure out how to move this to helper module
def admin_login 
  visit '/'
  expect(current_path).to eq('/login')
  fill_in('username', :with => @amanda.username)
  fill_in('password', :with => @amanda.password)
  click_button 'OPEN DOOR'
  expect(current_path).to eq('/admin')
  expect(page).to have_content 'Welcome, Amanda!'
end

def guest_login
  visit '/'
  expect(current_path).to eq('/login')
  fill_in('username', :with => @bear.username)
  fill_in('password', :with => @bear.password)
  click_button 'OPEN DOOR'
end

describe 'non admin user actions', :type => :feature do
  it 'successfully logs in' do 
    guest_login
    expect(current_path).to eq('/success')
    expect(page).to have_content 'The door was opened!'
  end

  it 'fails to log in' do 
    visit '/'
    expect(current_path).to eq('/login')
    fill_in('username', :with => 'not')
    fill_in('password', :with => 'allowed')
    click_button 'OPEN DOOR'
    expect(current_path).to eq('/failure')
    expect(page).to have_content 'Access Denied'
  end

  it 'cannot go to /admin with no session' do
    visit '/admin'
    expect(400 .. 599).to include(page.status_code)
  end

  it 'cannot go to /admin with guest session' do
    guest_login
    visit '/admin'
    expect(400 .. 599).to include(page.status_code)
  end

  it 'cannot go to /buzz without login' do
    visit '/buzz'
    expect(400 .. 599).to include(page.status_code)
  end
end

describe 'admin user actions', :type => :feaure do
  it 'successfully logs in' do
    admin_login
  end

  it 'can create a new user' do 
    admin_login
    click_link 'Create New User'
    expect(current_path).to eq('/new_user')
    fill_in('username', :with => "Iguana")
    fill_in('password', :with => "poetry")
    click_button 'CREATE USER'
    expect(current_path).to eq('/admin')
  end

  it 'can buzz door open' do 
    admin_login
    visit '/admin'
    click_link 'Buzz Door Open (this will log you out)'
    expect(current_path).to eq('/success')
    expect(page).to have_content 'The door was opened!'
  end

  it 'can logout' do
    admin_login
    click_link 'Log Out'
    expect(current_path).to eq('/login')
    expect(page).to have_content 'Welcome to Court Street Buzzer'
  end
end