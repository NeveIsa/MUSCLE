
require 'ap'


class Model
	def initialize(passwordfile="/etc/mosquitto/passwd",aclsfile="/etc/mosquitto/acls")
		@passwordfile=passwordfile
		@aclsfile=aclsfile


		if File.file?(@passwordfile)
		else
			system "touch #{@passwordfile}"
		end
		
		if File.file?(@aclsfile)
		else
			system "touch #{@aclsfile}"
		end
	end

	def getUsers
		users=[]
		File.open(@passwordfile).each do |line|
			if line!=""
				user=(line.split (":"))[0]
				users.push(user)
			end
		end

		return @users=users
	end

	def putUser(username,password)
		system "mosquitto_passwd -b #{@passwordfile} #{username} #{password}"
	end

	def delUser(username)	
		if File.file?(@passwordfile)
			system "mosquitto_passwd -D #{@passwordfile} #{username}"
		end
	end


	def loadAcls
		acls={}
		user=""
		File.open(@aclsfile).each do |line|
			line=line.strip
			if line!=""
				if /^user .+$/.match(line)
					user,= /^user (.+)$/.match(line).captures
					#ap user
				elsif /^topic (write|read|readwrite) (.+)$/.match(line)
					access,topic = /^topic (write|read|readwrite) (.+)$/.match(line).captures
					if acls.has_key? user
					else
						acls[user]={}
					end
					
					acls[user][topic]=access
				end
			end
		end
		@acls=acls
	end
	

	def addAcls(username,topic,access)
		getUsers
		if not @users.include? username
			return false
		end

		if not @acls.has_key? username
			@acls[username]={}
		end
		
		#adding acl
		@acls[username][topic]=access
		return @acls
	end


	def remAcls(username,topic)
		if @acls.has_key?username
			@acls[username].delete(topic)
		end
		return @acls
	end
	
	def dumpAcls
		#ap "#{user} >>> #{key}"
		File.open(@aclsfile,"w") { |file|
			@acls.each do |user,key|
				file.write("\nuser #{user}\n")
				key.each do |topic,access|
					file.write("topic #{access} #{topic}\n")
				end
			end
		}
	end

	############## USER FRIENDLY FUNCTIONS ##############
	
	def getAcls
		loadAcls
	end

	def putAcls(username,topic,access)
		loadAcls
		if addAcls(username,topic,access)==false
			return false
		end
		dumpAcls
		@acls
	end

	def delAcls(username,topic)
		loadAcls
		remAcls(username,topic)
		dumpAcls
		@acls
	end

	############## USER FRIENDLY FUNCTIONS ##############

end



if __FILE__ == $0
	model=Model.new()

	model.putUser("sam","pad")
	ap model.getUsers

	ap model.getAcls()

	ap model.putAcls("sam","world","readwrite")

	ap model.getAcls()

	model.delAcls("sam","hello")
	ap model.getAcls
end
