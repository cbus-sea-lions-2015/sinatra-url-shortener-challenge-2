enable :sessions


get '/' do
  # let user create new short URL, display a list of shortened URLs
  # @all_urls = Url.all
  # # Look in app/views/index.erb
  # erb :index

  redirect '/users/login'
end

get '/users/login' do
  @user = User.new
  erb :new
end

get '/users/logout' do
  session[:id] = nil
  redirect '/'
end

post '/users' do
  @user = User.authenticate(params[:username],params[:password])
  
  if @user
    session[:id] = @user.id
    redirect "/users/#{ @user.id }"
  else
    # flash[:notice] = "Valid info please. "
    redirect "/users/new"
  end 
end

get '/users/:user_id' do
  if session[:id] == nil || session[:id] != params[:user_id].to_i
    redirect '/users/login'
  else
    @all_urls = Url.where(user_id: params[:user_id])
    erb :index
  end
end

post '/urls' do
  @all_urls = Url.all
  # create a new Url
  my_url = params[:input]
  new_record = Url.create(original_url: my_url,short_url: '',user_id: session[:id])
  if new_record.errors[:original_url].any?
    @errors = true
  else
    new_record.save
  end
  redirect "/users/#{session[:id]}"
end

# e.g., /q6bda
get '/:short_url' do
  record = Url.where(short_url: "#{params[:short_url]}").first
  # redirect to appropriate "long" URL

  record.update_count
  redirect to(record.original_url)
end