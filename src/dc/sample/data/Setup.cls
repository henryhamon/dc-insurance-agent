Class dc.sample.data.Setup Extends %RegisteredObject
{

Parameter POLICETYPE = "Auto Insurance";

ClassMethod Synthetic() As %DynamicArray
{
    Return [
    {
        "policy_id": "POL001",
        "customer_ssn": "123.456.789-00",
        "customer_name": "João Silva",
        "policy_type": "Auto Insurance",
        "coverage": {
            "collision": true,
            "comprehensive": true,
            "liability": true,
            "medical_payments": true,
            "uninsured_motorist": true
        },
        "deductible": 1000,
        "coverage_limits": {
            "collision": 50000,
            "comprehensive": 30000,
            "liability": 100000,
            "medical_payments": 10000
        },
        "exclusions": [
            "Racing or competitive driving",
            "Intentional damage",
            "Driving under influence"
        ],
        "premium": 1200,
        "status": "active",
        "effective_date": "2024-01-01",
        "expiry_date": "2026-01-01"
    },
    {
        "policy_id": "POL002",
        "customer_ssn": "987.654.321-00",
        "customer_name": "Maria Santos",
        "policy_type": "Auto Insurance",
        "coverage": {
            "collision": true,
            "comprehensive": false,
            "liability": true,
            "medical_payments": false,
            "uninsured_motorist": true
        },
        "deductible": 500,
        "coverage_limits": {
            "collision": 25000,
            "liability": 75000
        },
        "exclusions": [
            "Commercial use",
            "Racing or competitive driving",
            "Flood damage"
        ],
        "premium": 800,
        "status": "active",
        "effective_date": "2024-03-15",
        "expiry_date": "2025-03-15"
    },
    {
        "policy_id": "POL003",
        "customer_ssn": "456.789.123-00",
        "customer_name": "Carlos Oliveira",
        "policy_type": "Auto Insurance",
        "coverage": {
            "collision": false,
            "comprehensive": true,
            "liability": true,
            "medical_payments": true,
            "uninsured_motorist": false
        },
        "deductible": 750,
        "coverage_limits": {
            "comprehensive": 40000,
            "liability": 150000,
            "medical_payments": 15000
        },
        "exclusions": [
            "Off-road driving",
            "Vehicle modifications",
            "Wear and tear"
        ],
        "premium": 950,
        "status": "active",
        "effective_date": "2024-02-01",
        "expiry_date": "2025-02-01"
    },
    {
        "policy_id": "POL004",
        "customer_ssn": "321.654.987-00",
        "customer_name": "Ana Costa",
        "policy_type": "Auto Insurance",
        "coverage": {
            "collision": true,
            "comprehensive": true,
            "liability": true,
            "medical_payments": true,
            "uninsured_motorist": true
        },
        "deductible": 2000,
        "coverage_limits": {
            "collision": 75000,
            "comprehensive": 60000,
            "liability": 200000,
            "medical_payments": 20000
        },
        "exclusions": [
            "Intentional damage",
            "Criminal activity",
            "Nuclear hazard"
        ],
        "premium": 1800,
        "status": "active",
        "effective_date": "2024-06-01",
        "expiry_date": "2025-06-01"
    },
    {
        "policy_id": "POL005",
        "customer_ssn": "789.123.456-00",
        "customer_name": "Pedro Fernandes",
        "policy_type": "Auto Insurance",
        "coverage": {
            "collision": true,
            "comprehensive": false,
            "liability": true,
            "medical_payments": false,
            "uninsured_motorist": false
        },
        "deductible": 1500,
        "coverage_limits": {
            "collision": 35000,
            "liability": 100000
        },
        "exclusions": [
            "Flood damage",
            "Earthquake damage",
            "Racing or competitive driving",
            "Commercial use"
        ],
        "premium": 600,
        "status": "suspended",
        "effective_date": "2024-04-01",
        "expiry_date": "2025-04-01"
        }
    ]
}

ClassMethod Init() As %Status
{
    Set data = ..Synthetic()
    Set it = data.%GetIterator()
    While it.%GetNext(.key, .import) {
        Set customer = ##class(Customer).%New()
        Set customer.SSN = import.%Get("customer_ssn")
        Set customer.Name = import.%Get("customer_name")
        
        Set policy = ##class(Policy).%New()
        Set policy.Code = import.%Get("policy_id")
        Set policy.PolicyType = ..#POLICETYPE
        Set policy.Deductible = import.deductible
        Set policy.Premium = import.premium
        Set policy.EffectiveDate = $ZDateH(import.%Get("effective_date"), 8)
        Set policy.ExpiryDate = $ZDateH(import.%Get("expiry_date"), 8)
        Set policy.Coverage.Collision = 1
        Set policy.Coverage.Comprehensive = 1
        Set policy.Coverage.Liability = 1
        Set policy.Coverage.MedicalPayments = 1
        Set policy.Coverage.UninsuredMotorist = 1

        Set exclusionIt = import.exclusions.%GetIterator()
        While exclusionIt.%GetNext(.excKey, .exclusionImported) {
            Do policy.Exclusions.Insert(##class(Exclusion).%New(exclusionImported))
        }

        Set limitIt = import.%Get("coverage_limits").%GetIterator()
        While limitIt.%GetNext(.limit, .limitValue) {
            Do policy.Limits.Insert(##class(Limit).%New(limit, limitValue))
        }

        Do customer.Policies.Insert(policy)
        Do customer.%Save()
    }
    Return $$$OK
}

}
