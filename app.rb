
require_relative 'model'
require 'json'
require 'sinatra'


enable :sessions


$mosquitto_conf_file=""
$basic_auth_user=""
$basic_auth_pass=""


$MUSCLE_CONF_FILE="muscleconf.json"

def loadMuscleConf
	f=File.open($MUSCLE_CONF_FILE)
	conf=f.read
	f.close
	
	conf=JSON.parse(conf)

	$mosquitto_conf_file=conf["mosquitto_conf_file"]
	$basic_auth_user=conf['basic_auth_user']
	$basic_auth_pass=conf['basic_auth_pass']
end


def dumpMuscleConfig(yconf)
	g=open($MUSCLE_CONF_FILE,'w')
	g.write(JSON.dump(yconf))
	g.close

	#reload muscle config
	loadMuscleConf
end





# load Muscle conf on script start
loadMuscleConf

puts "========"*7
puts "MOSQUITTO CONF. FILE: " + $mosquitto_conf_file
puts "========"*7

aclsfile=""
passwordfile=""

File.open($mosquitto_conf_file).each do |line|
	if /password_file (.+)/.match(line)
		passwordfile,=/password_file (.+)/.match(line).captures
		#puts passwordfile
	end	
	if /acl_file (.+)/.match(line)
		aclsfile,=/acl_file (.+)/.match(line).captures
		#puts aclsfile
	end
end

if aclsfile=="" or passwordfile==""
	puts "============="
	puts $mosquitto_conf_file + " doesn't contain acl_file or password_file entry in it"		
	puts "============="
	exit
end



puts "==========="*7
puts "Found ==> \n #{passwordfile}\n #{aclsfile} \n"
puts "==========="*7


model=Model.new(passwordfile,aclsfile)



##BASIC AUTH
#
#use Rack::Auth::Basic, "Protected Area" do |username, password|
#	  username == $basic_auth_user && password == $basic_auth_pass
#end



# Enable CORS
require "sinatra/cors"
set :allow_origin, "*"
set :allow_methods, "GET,HEAD,POST"
set :allow_headers, "content-type,if-modified-since"
set :expose_headers, "location,link"


#Set static file serve folder
set :public_folder, 'public'


before do
	if request.path_info=="/"
		if session["logged"]==true
			redirect "/public/dashboard/index.html"
		else 
			redirect "/public/dashboard/login.html"
		end
	elsif request.path_info=="/login"
	else
		if session["logged"]==true
		else 
			redirect "/login" 
		end
	end
end

post "/updateAdminSettings" do
	content_type :json

	newName = params['NewUname'].strip
	newPass = params['NewPasswd'].strip

	#puts newName,newPass


	if (newName=="" || newPass=="")
		return false.to_json
	else
		xconf={}
		xconf["mosquitto_conf_file"]=$mosquitto_conf_file
		xconf['basic_auth_user']=newName
		xconf['basic_auth_pass']=newPass
		dumpMuscleConfig(xconf)
		return true.to_json
	end
end

get '/logout' do
	session["logged"]=false
	redirect "/"
end

# checks login status
get '/login' do
	content_type :json
	(session["logged"]==true).to_json
end

# does login
post '/login' do
	content_type :json
	username=params['uname']
	password=params['passwd']
	if username == $basic_auth_user && password == $basic_auth_pass
		session["logged"]=true
		return true.to_json
	else
		session["logged"]=false
		return false.to_json
	end
end

get '/' do
	redirect '/public/dashboard/index.html'
end


get '/docs' do

	# Using https://marked.js.org/ to render Markdown on the browser 

	
	f=File.open("readme.md")
	readme=f.read()
	f.close()

	return readme


	#content_type :json	
	#{
	#	"1-GET"=>["/users","/acls"],
	#	"2-GET"=>["/user/{username}/{password}","/acl/{username}/{topic}/{access(read/write/readwrite)}"],
	#	"3-DELETE"=>["/user/{username}","/acl/{username}/{topic}"],
	#	"4-GET"=>["/sighup"],
	#	"dashboard"=>"/public/dashboard/index.html"
	#}.to_json
end

get '/users' do 
	content_type :json
	model.getUsers.to_json
end

get '/user/:username/:password' do |u,p|
	content_type :json
	model.putUser(u,p).to_json	
end

delete '/user/:username' do
	content_type :json
	u=params['username']
	model.delUser(u).to_json
end


get '/acls' do
	content_type :json
	model.getAcls.to_json
end

get '/acl/:username/:topic/:access' do |u,t,a|
	if a=="read" or a=="write" or a=="readwrite"
		content_type :json
		model.putAcls(u,t,a).to_json
	else
		"Access \"#{a}\" is not valid"
	end
end

delete '/acl/:username/:topic' do |u,t|
	content_type :json
	model.delAcls(u,t).to_json
end


get '/sighup' do
	content_type :json

	if not File.file?("/var/run/mosquitto.pid")
		errormsg={ "status"=>"fail"  ,"error" => "/var/run/mosquitto.pid not found. Mosquitto service running?"}
		halt 200,errormsg.to_json
	end
	mosquittoPID=""
	File.open("/var/run/mosquitto.pid") {|file| mosquittoPID = file.read().strip()}
	result=Process.kill("HUP",mosquittoPID.to_i)
	{"status"=>"success","mosquittoPID"=>mosquittoPID,"SIGHUPResult"=>result}.to_json
end
