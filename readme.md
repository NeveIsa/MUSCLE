## This is MUSCLE - A Mosquitto ACL manager with REST APIs and dashboard. [|View on Github|](https://github.com/neveisa/MUSCLE)





#### STEPS TO GET MUSCLE RUNNING -


#### Setup using tools script
1. Install Ruby on your system
2. run ./tools-install-dependencies.sh
3. run ./tools-start-server.sh [port]

#### Manual Setup
1. Install Ruby on your system
2. Install Sinatra using `gem install sinatra`
3. Install Sinatra-CORS using `gem install sinatra-cors`
4. Install Awesome Print using `gem install awesome_print`
5. Configure the authentication parameters by editing the file `muscleconf.json`
6. Run the server using `ruby app.rb`
7. Go to the link http://{hostname}:9292 (hostname=localhost/machineIP) and enter the credentials to check everything is working


#### Configuring and running Mosquitto MQTT Broker
1. View the example Mosquitto configuration file - config-templates/mosquitto.conf.template 
2. Either copy the above file into /etc/mosquitto/mosquitto.conf or modify your own configuration file accordingly.
3. View the muscleconf.json file which contains the login credentials for consuming the REST APIs and the dashboard. Modify accordingly.
4. Start Mosquitto MQTT Broker service is on your system - service mosquitto restart | systemctl restart mosquitto 
5. Check is Mosquitto MQTT Broker service is running - service mosquitto status | systemctl restart status

## Consuming the API is straight forward as listed below	

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


