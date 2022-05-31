require 'sinatra'
require 'sinatra/reloader'

require './data'

enable :sessions

get '/' do
    erb :welcome
end

post '/' do
    if session[:user]
        session[:user].update(:total_won => session[:won].to_i + session[:user].total_won)
        session[:user].update(:total_lost => total_lost = session[:lost].to_i + session[:user].total_lost)
        session[:user] = nil
        session[:won] = nil
        session[:lost] = nil
    end
    redirect '/'
end

get '/signup' do
    erb :signup
end

post '/signup' do
    @username = params[:username]
    @password = params[:password]

    if !Account.get(@username)
        Account.create(:username => @username, :password => @password, :total_won => 0, :total_lost => 0)
        session[:signupsuccess] = "ACCOUNT {#{@username}} SUCCESSFULLY CREATED, PLEASE LOG IN"
        redirect '/'
    end
    session[:signuperror] = "ACCOUNT ALREADY EXISTS, PLEASE TRY AGAIN"
    redirect '/signup'
end

get '/login' do
    erb :login
end

post '/login' do
    @username = params[:username]
    @password = params[:password]

    Account.all.each do |account|
        if (@username == account.username && @password == account.password)
            session[:user] = Account.get(account.username)
            redirect '/casino'
        end
    end
    session[:loginerror] = "LOGIN FAILED, PLEASE TRY AGAIN"
    redirect '/login'
end

get '/casino' do
    if !session[:user]
        redirect '/'
    end

    if !session[:won]
        session[:won] = 0
    end
    if !session[:lost]
        session[:lost] = 0
    end
    @winnings = session[:user].total_won
    @losses = session[:user].total_lost
    @profit = (@winnings - @losses)
    erb :casino
end

post '/casino' do
    @bet = params[:money].to_i
    @guess = params[:side].to_i

    @roll = rand(6) + 1

    if @guess == @roll
        session[:won] = ((@bet * 2) + session[:won].to_i).to_s
        session[:winmessage] = "The dice landed on #{@roll}. You guessed correctly! You win $#{(@bet * 2).to_s}."
    else
        session[:lost] = (@bet + session[:lost].to_i).to_s
        session[:lossmessage] = "The dice landed on #{@roll}. You guessed incorrectly. You lose your bet of $#{(@bet).to_s}."
    end
    redirect '/casino'
end

