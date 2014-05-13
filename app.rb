require_relative './config/environment'

class BuzzerApp < Sinatra::Base

	enable :sessions

	get '/' do 
		redirect '/login'
	end

	get '/login' do 
		erb :login
	end

	post '/login' do
		@user = User.find_by(username: params[:username])
		if @user.nil? || !@user.password?(params[:password])
			redirect '/failure'
		end
		if @user.admin?
			session[:admin_username] = params[:username]
			redirect '/admin'
		else
			session[:guest_username] = params[:username]
			redirect '/buzz'
		end
	end

	get '/admin' do 
		SessionError.check_session_admin(session)
		@user = User.find_by(username: session[:admin_username])
		erb :admin
	end

	get '/new_user' do
		SessionError.check_session_admin(session)
		erb :new_user
	end

	post '/new_user' do
		SessionError.check_session_admin(session)
		new_user = User.new
		new_user.username = params[:username]
		new_user.password = params[:password]
		if new_user.save
			redirect '/admin'
		else
			"Error, unable to save."
		end
	end

	get '/buzz' do
		SessionError.check_session_guest_or_admin(session)
		buzz = Buzzer.new
		buzz.open_door
		session.clear
		redirect '/success'
	end

	get '/success' do 
		erb :success
	end

	get '/failure' do 
		erb :failure
	end

	get '/logout' do 
		session.clear
		redirect '/'
	end
end
