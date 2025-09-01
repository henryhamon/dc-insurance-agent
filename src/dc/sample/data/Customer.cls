Class dc.sample.data.Customer Extends (%Persistent, %JSON.Adaptor)
{

Index idxSSN On SSN [ Unique ];

Property SSN As %String(%JSONFIELDNAME = "customer_ssn", MAXLEN = 20) [ Required ];

Property Name As %String(%JSONFIELDNAME = "customer_name", MAXLEN = 100);

Relationship Policies As Policy(%JSONFIELDNAME = "customer_policy") [ Cardinality = many, Inverse = Customer ];

Storage Default
{
<Data name="CustomerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SSN</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^dc.sample.data.CustomerD</DataLocation>
<DefaultData>CustomerDefaultData</DefaultData>
<IdLocation>^dc.sample.data.CustomerD</IdLocation>
<IndexLocation>^dc.sample.data.CustomerI</IndexLocation>
<StreamLocation>^dc.sample.data.CustomerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
