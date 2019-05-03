Class REST.Security Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/" Method="GET" Call="version" Cors="true"/>
<Route Url="/userAdd" Method="POST" Call="CreateUser" Cors="true"/>
<Route Url="/userModify/:username" Method="PUT" Call="ModifyUser" Cors="true"/>
<Route Url="/userDelete/:username" Method="DELETE" Call="DeleteUser" Cors="true"/>
<Route Url="/users" Method="GET" Call="GetUsers" Cors="true"/>
<Route Url="/roles" Method="GET" Call="GetRoles" Cors="true"/>
</Routes>
}

ClassMethod version() As %Status
{
	set sc=$$$OK
	set %response.ContentType="application/json"
	set data={}
	set data.version=$system.Version.GetVersion()
	write data.%ToJSON()
	return sc
}

ClassMethod CreateUser() As %Status
{
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
	SET sc=##class(Security.Users).Create(username,.Properties)
	if 'sc {set data.errors="Failed to create user "_ username _" "_$system.Status.GetErrorText(sc)}
	set data.result=username _" successfully created"

	write data.%ToJSON()
	zn ns
	return sc
}

ClassMethod ModifyUser(username As %String) As %Status
{
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
	SET sc=##class(Security.Users).Modify(username,.Properties)
	if 'sc {set data.errors="Failed to modify user "_ username _" "_$system.Status.GetErrorText(sc)}
	set data.result=username _" successfully modified"

	write data.%ToJSON()
	zn ns
	return sc
}

ClassMethod DeleteUser(username As %String) As %Status
{
	set sc=$$$OK
	set %response.ContentType="application/json"
	set ns=$namespace
	set data={}
	zn "%sys"
	SET sc=##class(Security.Users).Delete(username)
	if 'sc {set data.errors="Failed to delete user "_username_" "_$system.Status.GetErrorText(sc)}
	set data.result=username_" successfully deleted"

	write data.%ToJSON()
	zn ns
	return sc
}

ClassMethod GetUsers() As %Status
{
	set sc=$$$OK
	set %response.ContentType="application/json"
	set ns=$namespace
	set data=[]
	zn "%sys"

	SET stmt=##class(%SQL.Statement).%New()
	SET status = stmt.%PrepareClassQuery("Security.Users","List")
    IF 'status {set data.error="%Prepare failed:"_$System.Status.DisplayError(status) QUIT}
    SET rset = stmt.%Execute("*","*")
    While rset.%Next() {
    	set user={}
        set user.name=rset.%Get("Name")
        set user.role=rset.%Get("Roles")
        do data.%Push(user)
    }
    kill rset
	write data.%ToJSON()
	zn ns
	return sc
}

ClassMethod GetRoles() As %Status
{
	set sc=$$$OK
	set %response.ContentType="application/json"
	set ns=$namespace
	set data=[]
	zn "%sys"

	SET stmt=##class(%SQL.Statement).%New()
	SET status = stmt.%PrepareClassQuery("Security.Roles","List")
    IF 'status {set data.error="%Prepare failed:"_$System.Status.DisplayError(status) QUIT}
    SET rset = stmt.%Execute("*","*")
    While rset.%Next() {
    	set role={}
        set role.roleName=rset.%Get("Name")
        set role.GrantedRoles=rset.%Get("GrantedRoles")
        do data.%Push(role)
    }
    kill rset
	write data.%ToJSON()
	zn ns
	return sc
}

}
