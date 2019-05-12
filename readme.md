### This is MUSCLE - A Mosquitto ACL control interface over HTTP REST. 

[View project on Github](https://github.com/neveisa/MUSCLE)



#### Steps to get Muscle running
---

#### Setup using tools script
* Install Ruby on your system
* run ./tools-install-dependencies.sh
* run ./tools-start-server.sh [port]

#### Manual Setup
* Install Ruby on your system
* Install Sinatra using `gem install sinatra`
* Configure the authentication parameters by editing the file `muscleconf.json`
* Run the server using `ruby app.rb`

* Go to the link http://{hostname}:9292 (hostname=localhost/machineIP) and enter the credentials to check everything is working

### Consuming the API is straight forward as listed below	


### Login 
##### NOTE: Use cookies if using curl/wget
#### POST
* "/login" - parameters in urlencoded format -> *uname* and *passwd* i.e uname=paul&passwd=dirac

#### GET
* "/login" - returns true if you are logged in, else false


### List users/ACL
#### GET	
* 	"/users"
* 	"/acls"

### Add new users
#### GET	
* 	"/user/{username}/{password}"
* 	"/acl/{username}/{topic}/{access(read/write/readwrite)}"

### Delete users
#### DELETE	
* 	"/user/{username}"
* 	"/acls/{username}/{topic}"

### Reload new configuration
#### GET	
* 	"/sighup"


