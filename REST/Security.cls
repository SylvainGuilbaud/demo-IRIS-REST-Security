Class REST.Security Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/" Method="GET" Call="version" Cors="true"/>
<Route Url="/users" Method="GET" Call="GetUsers" Cors="true"/>
<Route Url="/users" Method="POST" Call="CreateUser" Cors="true"/>
<Route Url="/users" Method="PUT" Call="ModifyUser" Cors="true"/>
<Route Url="/users" Method="DELETE" Call="DeleteUser" Cors="true"/>
<Route Url="/roles" Method="GET" Call="GetRoles" Cors="true"/>
<Route Url="/roles" Method="POST" Call="CreateRole" Cors="true"/>
<Route Url="/roles" Method="PUT" Call="ModifyRole" Cors="true"/>
<Route Url="/roles" Method="DELETE" Call="DeleteRole" Cors="true"/>
</Routes>
}
/// get version
ClassMethod version() As %Status
{
 try {
	set sc=$$$OK
	set %response.ContentType="application/json"
	set data={}
	set data.version=$system.Version.GetVersion()
	set data.ts=$zdt($horolog,3)
	write data.%ToJSON()
	} catch e {
		throw e
	}
	return sc
}

ClassMethod CreateUser() As %Status
{
 try {
	set sc=$$$OK
	set %response.ContentType="application/json"
	set ns=$namespace
	set data={}
	zn "%sys"
	set request=%request.Content.Read()
	set json={}.%FromJSON(request)
	set Properties("Name")=json.Name
	set username=json.Name
	set Properties("Roles")=json.Roles
	set Properties("Password")=json.Password
	set Properties("FullName")=json.FullName
	set Properties("Comment")=json.Comment
	set Properties("Enabled")=json.Enabled
	set Properties("AccountNeverExpires")=json.AccountNeverExpires
	set Properties("PasswordNeverExpires")=json.PasswordNeverExpires
	set Properties("ChangePassword")=json.ChangePassword
	set Properties("NameSpace")=json.NameSpace
	set Properties("ExpirationDate")=json.ExpirationDate
	set Properties("PhoneNumber")=json.PhoneNumber
	$$$ThrowOnError(##class(Security.Users).Create(username,.Properties))
	set data.result=username _" successfully created"
	write data.%ToJSON()
	zn ns
	} catch e {
		throw e
	}
	return sc
}

ClassMethod ModifyUser() As %Status
{
 try {
	set sc=$$$OK
	set %response.ContentType="application/json"
	set ns=$namespace
	set data={}
	zn "%sys"
	set request=%request.Content.Read()
	set json={}.%FromJSON(request)
	set Properties("Name")=json.Name
	set Properties("Roles")=json.Roles
	set Properties("Password")=json.Password
	set Properties("FullName")=json.FullName
	set Properties("Comment")=json.Comment
	set Properties("Enabled")=json.Enabled
	set Properties("AccountNeverExpires")=json.AccountNeverExpires
	set Properties("PasswordNeverExpires")=json.PasswordNeverExpires
	set Properties("ChangePassword")=json.ChangePassword
	set Properties("NameSpace")=json.NameSpace
	set Properties("ExpirationDate")=json.ExpirationDate
	set Properties("PhoneNumber")=json.PhoneNumber
	$$$ThrowOnError(##class(Security.Users).Modify(json.Name,.Properties))
	set data.result=json.Name _" successfully modified"

	write data.%ToJSON()
	zn ns
	} catch e {
		throw e
	}
	return sc
}

ClassMethod DeleteUser() As %Status
{
	set sc=$$$OK
	set %response.ContentType="application/json"
	set ns=$namespace
	set data={}
	zn "%sys"
	set request=%request.Content.Read()
	set json={}.%FromJSON(request)
	$$$ThrowOnError(##class(Security.Users).Delete(json.Name))
	set data.result=json.Name_" successfully deleted"
	write data.%ToJSON()
	zn ns
	return sc
}

ClassMethod GetUsers() As %Status
{
 try {
	set sc=$$$OK
	set %response.ContentType="application/json"
	set ns=$namespace
	set data=[]
	zn "%sys"
	SET stmt=##class(%SQL.Statement).%New()
	$$$ThrowOnError(stmt.%PrepareClassQuery("Security.Users","List"))
    SET rset = stmt.%Execute("*")
    While rset.%Next() {
    	set user={}
        set user.Name=rset.%Get("Name")
        set user.Roles=rset.%Get("Roles")
        set user.Enabled=rset.%Get("Enabled")
        set user.LastLoginTime=rset.%Get("LastLoginTime")
        do data.%Push(user)
    }
    kill rset
	write data.%ToJSON()
	zn ns
	} catch e {
		throw e
	}
	return sc
}

ClassMethod GetRoles() As %Status
{
 try {
	set sc=$$$OK
	set %response.ContentType="application/json"
	set ns=$namespace
	set data=[]
	zn "%sys"
	SET stmt=##class(%SQL.Statement).%New()
	$$$ThrowOnError(stmt.%PrepareClassQuery("Security.Roles","ListAll"))
    SET rset = stmt.%Execute("*")
    While rset.%Next() {
    	set role={}
        set role.roleName=rset.%Get("Name")
        set role.Description=rset.%Get("Description")
        set role.Resources=rset.%Get("Resources")
        set role.GrantedRoles=rset.%Get("GrantedRoles")
        do data.%Push(role)
    }
    kill rset
	write data.%ToJSON()
	zn ns
	} catch e {
		throw e
	}
	return sc
}
ClassMethod CreateRole() As %Status
{
 try {
	set sc=$$$OK
	set %response.ContentType="application/json"
	set ns=$namespace
	set data={}
	zn "%sys"
	set request=%request.Content.Read()
	set json={}.%FromJSON(request)
	set Name=json.Name
	set Description=json.Description
	set Resources=json.Resources
	set GrantedRoles=json.GrantedRoles
	$$$ThrowOnError(##class(Security.Roles).Create(Name,Description,Resources,GrantedRoles))
	set data.result=Name _" successfully created"
	write data.%ToJSON()
	zn ns
	} catch e {
		throw e
	}
	return sc
}

ClassMethod ModifyRole() As %Status
{
 try {
	set sc=$$$OK
	set %response.ContentType="application/json"
	set ns=$namespace
	set data={}
	zn "%sys"
	set request=%request.Content.Read()
	set json={}.%FromJSON(request)
	set Properties("Name")=json.Name
	set Properties("Description")=json.Description
	set Properties("Resources")=json.Resources
	set Properties("GrantedRoles")=json.GrantedRoles
	$$$ThrowOnError(##class(Security.Roles).Modify(json.Name,.Properties))
	set data.result=json.Name _" successfully modified"

	write data.%ToJSON()
	zn ns
	} catch e {
		throw e
	}
	return sc
}

ClassMethod DeleteRole() As %Status
{
 try {
	set sc=$$$OK
	set %response.ContentType="application/json"
	set ns=$namespace
	set data={}
	zn "%sys"
	set request=%request.Content.Read()
	set json={}.%FromJSON(request)
	$$$ThrowOnError(##class(Security.Roles).Delete(json.Name))
	set data.result=json.Name _" successfully deleted"
	write data.%ToJSON()
	zn ns
	} catch e {
		throw e
	}
	return sc
}

}
