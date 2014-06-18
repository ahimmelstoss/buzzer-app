module LoginHelper
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
end