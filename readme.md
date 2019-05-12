### This is MUSCLE - A Mosquitto ACL manager with REST APIs and dashboard. 

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


### Configuring Mosquitto 
* View the example Mosquitto configuration file - config-templates/mosquitto.conf.template
* Either copy the above file into /etc/mosquitto/mosquitto.conf or modify your own configuration file accordingly.
* View the muscleconf.json file which contains the login credentials for consuming the REST APIs and the dashboard. Modify accordingly.

### Consuming the API is straight forward as listed below	

### Dashboard
#### GET 
* "/" - point your browser to the root of the server e.g http://localhost:9292 (default)

### Login 
##### NOTE: Use cookies if using curl/wget
#### POST
* "/login" - parameters in urlencoded format -> *uname* and *passwd* e.g uname=paul&passwd=dirac (default)

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


