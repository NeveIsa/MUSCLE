### This is MUSCLE - A Mosquitto ACL control interface over HTTP REST.


#### Requirements - Ruby and Sinatra

#### Steps to get Muscle running
---

* Install Ruby on your system
* Install Sinatra using `gem install sinatra`
* Configure the authentication parameters by editing the file `muscleconf.json`
* Run the server using `ruby app.rb`

* Go to the link http://{hostname}:9292 (hostname=localhost/machineIP) and enter the credentials to check everything is working

### Consuming the API is straight forward as listed below	

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


