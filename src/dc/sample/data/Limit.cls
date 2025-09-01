Class dc.sample.data.Limit Extends (%Persistent, %JSON.Adaptor)
{

Index idxPolicy On Policy;

Property CoverageType As %String(%JSONFIELDNAME = "coverage_type", MAXLEN = 30) [ Required, SqlFieldName = coverage_type ];

Property Amount As %Numeric(%JSONFIELDNAME = "amount", SCALE = 2) [ Required ];

Relationship Policy As Policy [ Cardinality = one, Inverse = Limits ];

Method %OnNew(pCoverageType As %String = "", pAmount As %Numeric = "") As %Status [ Private ]
{
    Set:(pCoverageType'="") ..CoverageType = pCoverageType
    Set:(pAmount'="") ..Amount = pAmount
    Return $$$OK
}

Storage Default
{
<Data name="LimitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CoverageType</Value>
</Value>
<Value name="3">
<Value>Amount</Value>
</Value>
<Value name="4">
<Value>Policy</Value>
</Value>
</Data>
<DataLocation>^dc.sample.data.LimitD</DataLocation>
<DefaultData>LimitDefaultData</DefaultData>
<IdLocation>^dc.sample.data.LimitD</IdLocation>
<IndexLocation>^dc.sample.data.LimitI</IndexLocation>
<StreamLocation>^dc.sample.data.LimitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
