require_relative './config/environment'

class BuzzerApp < Sinatra::Base

	enable :sessions

	get '/' do 
		redirect '/login'
	end

	get '/login' do 
		erb :login
	end

	# POST /login checks username/password combination and sets the session if valid
	post '/login' do
		@user = User.find_by(username: params[:username])
		content_type :json if params[:api]
		if @user.nil? || !@user.password?(params[:password])
			return params[:api] ? {:authenticated => false}.to_json : redirect('/failure')
		end
		if @user.admin?
			session[:admin_username] = params[:username]
			return params[:api] ? {:admin => true, :authenticated => true}.to_json : redirect('/admin')
		else
			session[:guest_username] = params[:username]
			return params[:api] ? {:admin => false, :authenticated => true}.to_json : redirect('/buzz')
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

	# POST /new_user checks if user is a admin, creates a new user via params input
	post '/new_user' do
		SessionError.check_session_admin(session)
		new_user = User.new
		new_user.username = params[:username]
		new_user.password = params[:password]
		if new_user.save
			return params[:api] ? {:new_user => true}.to_json : redirect('/admin')
		else
			return params[:api] ? {:new_user => false}.to_json : "Error, unable to save."
		end
	end

	# GET /buzz runs checks, calls instance method open_door, then clears session
	get '/buzz' do
		content_type :json if params[:api]
		SessionError.check_session_guest_or_admin(session)
		buzz = Buzzer.new
		buzz.open_door
		session.clear
		return params[:api] ? {:buzz => true}.to_json : redirect('/success')
	end

	get '/success' do 
		erb :success
	end

	get '/failure' do 
		erb :failure
	end

	# Only used on the /admin page
	get '/logout' do 
		session.clear
		redirect '/'
	end
end
