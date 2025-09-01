Class dc.sample.data.Exclusion Extends (%Persistent, %JSON.Adaptor)
{

Index idxPolicy On Policy;

Property Description As %String(%JSONFIELDNAME = "description", MAXLEN = 200);

Relationship Policy As Policy [ Cardinality = one, Inverse = Exclusions ];

Method %OnNew(pDescription As %String = "") As %Status [ Private ]
{
    Set:(pDescription'="") ..Description = pDescription
    Return $$$OK
}

Storage Default
{
<Data name="ExclusionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Policy</Value>
</Value>
</Data>
<DataLocation>^dc.sample.data.ExclusionD</DataLocation>
<DefaultData>ExclusionDefaultData</DefaultData>
<IdLocation>^dc.sample.data.ExclusionD</IdLocation>
<IndexLocation>^dc.sample.data.ExclusionI</IndexLocation>
<StreamLocation>^dc.sample.data.ExclusionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
