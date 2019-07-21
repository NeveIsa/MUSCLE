
// HELPERS //

function arrayRemove(arr, value) {

    return arr.filter(function(ele){
        return ele != value;
    });
 
 }

// HELPERS //
 

var isaUsers = new Vue({
    el: '#isaUserTable',
    data: {
      users:[]
    }
  })


var isaInactiveUsers = new Vue({
el: '#isaInactiveUserDiv',
data: {
    inactiveUsers:[]
}
})


var isaAcl = new Vue({
    el: '#aclTableDiv',
    data: {
        user: "",
        acl:{}
    }
    })



class Muscle {
    constructor(_baseURL) {
        this.baseURL = _baseURL;
    }

    // Adding a method to the constructor
    users(callback) {
        axios.get(this.baseURL + "/users").then((r)=>{
            callback(r.data)
        })
    }

    acls(callback) {
        axios.get(this.baseURL + "/acls").then((r)=>{
                callback(r.data)
        })
    }

    findActiveUsers(users,acls,callback)
    {

        var aclUsers = Object.keys(acls)
        var commonUsers = Array.from($(aclUsers).filter(users))

        var inactiveUsers=Array.from(aclUsers); //make a copy


        for(var indx in commonUsers)
        {
            var u = commonUsers[indx]
            //console.log(u)
            inactiveUsers=arrayRemove(inactiveUsers,u)
        }

        this.INACTIVEUSERS=inactiveUsers;


        callback(users,inactiveUsers)


        console.log("POPULATING PAGE\n---------------------------------------------------------------")
        console.log("All users -> " + users)
        console.log("All users in acls -> " + aclUsers)
        console.log("Common (acls union users) -> " + commonUsers)
        console.log("Inactive Users (only in acls, not in Users) -> " + inactiveUsers)
        console.log("---------------------------------------------------------------\n")
       
    }

    createUser(uname,passwd,callback)
    {
        axios.get(this.baseURL + `/user/${uname}/${passwd}`).then((r)=>{
            callback(r.data);
        })
    }

    createAcl(uname,topic,access,callback)
    {
	topic=base32.encode(topic) // we need this as a slash in topic will break Sinatra e.g hello/world
        axios.get(this.baseURL + `/acl/${uname}/${topic}/${access}`).then((r)=>{
            callback(r.data)
        })
    }


    destroyUser(uname,callback)
    {
        axios.delete(this.baseURL + `/user/${uname}`).then((r)=>{
            callback(r.data)
        })
    }

    destroyAcl(uname,topic,callback)
    {
	topic=base32.encode(topic) // we need this as a slash in topic will break Sinatra e.g hello/world
        axios.delete(this.baseURL + `/acl/${uname}/${topic}`).then((r)=>{
            callback(r.data)
        })
    }

    sighup(callback)
    {
        axios.get("/sighup",callback).then((r)=>{
            callback(r.data)
        })
    }

}


musc = new Muscle("") // empty means relative url will be used


function populatePage()
{
    musc.users((_users)=>{
        musc.acls((_acls)=>{
            musc.findActiveUsers(_users,_acls,(u,iu)=>{
                isaUsers.users=u;
                isaInactiveUsers.inactiveUsers=iu
                
            })
        })
    })
}

function isActiveUser(username)
{

    // CHECKING if isaUsers.users==false is required -> this is the case when not logged in.
    return isaUsers.users && isaUsers.users.includes(username)

    
}

populatePage()
