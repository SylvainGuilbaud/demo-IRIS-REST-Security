Include WorkShop.macros

Class WorkShop.Patient Extends (%Persistent, %Library.Populate,%XML.Adaptor)
{
Property name As %String;

ClassMethod showInfo() As %Status
{
	set sc=$$$OK
	set info={}
	set info.compiled=$$$CompTS
	write info.%ToJSON()
	return sc
}

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
</Data>
<DataLocation>^WorkShop.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^WorkShop.PatientD</IdLocation>
<IndexLocation>^WorkShop.PatientI</IndexLocation>
<StreamLocation>^WorkShop.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
