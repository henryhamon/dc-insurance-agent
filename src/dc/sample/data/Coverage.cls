Class dc.sample.data.Coverage Extends (%SerialObject, %JSON.Adaptor)
{

Property Collision As %Boolean(%JSONFIELDNAME = "collision") [ InitialExpression = 0 ];

Property Comprehensive As %Boolean(%JSONFIELDNAME = "comprehensive") [ InitialExpression = 0 ];

Property Liability As %Boolean(%JSONFIELDNAME = "liability") [ InitialExpression = 0 ];

Property MedicalPayments As %Boolean(%JSONFIELDNAME = "medical_payments") [ InitialExpression = 0, SqlFieldName = medical_payments ];

Property UninsuredMotorist As %Boolean(%JSONFIELDNAME = "uninsured_motorist") [ InitialExpression = 0, SqlFieldName = uninsured_motorist ];

Storage Default
{
<Data name="CoverageState">
<Value name="1">
<Value>Collision</Value>
</Value>
<Value name="2">
<Value>Comprehensive</Value>
</Value>
<Value name="3">
<Value>Liability</Value>
</Value>
<Value name="4">
<Value>MedicalPayments</Value>
</Value>
<Value name="5">
<Value>UninsuredMotorist</Value>
</Value>
</Data>
<State>CoverageState</State>
<StreamLocation>^dc.sample.data.CoverageS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
