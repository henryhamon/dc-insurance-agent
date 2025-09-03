Class dc.sample.data.Policy Extends (%Persistent, %JSON.Adaptor)
{

Index idxCode On Code [ Unique ];

Index idxCustomer On Customer;

Property Code As %String [ Required ];

Property PolicyType As %String(%JSONFIELDNAME = "policy_type", MAXLEN = 50) [ Required, SqlFieldName = policy_type ];

Property Deductible As %Numeric(%JSONFIELDNAME = "deductible", SCALE = 2);

Property Status As %String(%JSONFIELDNAME = "status", DISPLAYLIST = "Active,Inative", VALUELIST = "A,I") [ InitialExpression = "A" ];

Property EffectiveDate As %Date(%JSONFIELDNAME = "effective_date") [ SqlFieldName = effective_date ];

Property ExpiryDate As %Date(%JSONFIELDNAME = "expiry_date") [ SqlFieldName = expiry_date ];

Property Premium As %Numeric(%JSONFIELDNAME = "premium", SCALE = 2);

Property Coverage As Coverage(%JSONFIELDNAME = "coverage");

Relationship Customer As Customer [ Cardinality = one, Inverse = Policies ];

Relationship Exclusions As Exclusion(%JSONFIELDNAME = "exclusions") [ Cardinality = many, Inverse = Policy ];

Relationship Limits As Limit(%JSONFIELDNAME = "coverage_limits") [ Cardinality = many, Inverse = Policy ];

Query FindBySSN(SSN As %String) As %SQLQuery [ SqlProc ]
{
    SELECT id as PolicyID
    FROM dc_sample_data.Policy
    WHERE Customer->SSN = :SSN
}

Storage Default
{
<Data name="PolicyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>PolicyType</Value>
</Value>
<Value name="4">
<Value>Deductible</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>EffectiveDate</Value>
</Value>
<Value name="7">
<Value>ExpiryDate</Value>
</Value>
<Value name="8">
<Value>Premium</Value>
</Value>
<Value name="9">
<Value>Coverage</Value>
</Value>
<Value name="10">
<Value>Customer</Value>
</Value>
</Data>
<DataLocation>^dc.sample.data.PolicyD</DataLocation>
<DefaultData>PolicyDefaultData</DefaultData>
<IdLocation>^dc.sample.data.PolicyD</IdLocation>
<IndexLocation>^dc.sample.data.PolicyI</IndexLocation>
<StreamLocation>^dc.sample.data.PolicyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
