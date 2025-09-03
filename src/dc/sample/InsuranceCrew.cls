Class dc.sample.InsuranceCrew Extends %RegisteredObject
{

ClassMethod RetrievePolicyBySSN(pSSN As %String) As %String
{
    Set result = []
    Try {
        Set statement = ##class(%SQL.Statement).%New()
        Set tSC = statement.%PrepareClassQuery("dc.sample.data.Policy","FindBySSN")
        Throw:($$$ISERR(tSC)) tSC
        Set rset = statement.%Execute(pSSN)
        While rset.%Next() {
            Set policy = ##class(dc.sample.data.Policy).%OpenId(rset.%Get("PolicyID"))
            Do result.%Push({}.%FromJSON(policy.%JSONExport()))
        }
    } Catch ex {
        Set tSC=ex.AsStatus()
    }
    Return result.%ToJSON()
}

ClassMethod test() [ Language = python ]
{
    import iris
    a = iris.dc.sample.InsuranceCrew.RetrievePolicyBySSN('123.456.789-00')
    print(a)
}

/// Agent Crew
ClassMethod Agents() [ Language = python ]
{
    from crewai import Agent
    from langchain_openai import ChatOpenAI
    import iris

    # Initialize LLM
    llm = ChatOpenAI(model="gpt-4", temperature=0.1)

    # Initialize tools
    fraud_analysis_tool = FraudAnalysisTool()
    claim_validation_tool = ClaimValidationTool()

    # Agent 1: Input Parser Agent
    input_parser_agent = Agent(
        role="Insurance Claim Data Parser",
        goal="Extract and structure all relevant information from insurance claim JSON data",
        backstory=(
            "You are an expert data analyst specializing in insurance claim processing. "
            "Your job is to carefully parse incoming claim data and extract all relevant "
            "structured information that will be used by other agents in the pipeline."
        ),
        verbose=True,
        allow_delegation=False,
        llm=llm,
        tools=[claim_validation_tool]
    )

    # Agent 2: Report Analysis Agent
    report_analysis_agent = Agent(
        role="Incident Report Analyst",
        goal="Analyze and interpret textual incident descriptions from insurance claims",
        backstory=(
            "You are a seasoned insurance investigator with expertise in analyzing incident reports. "
            "You can identify key details about accidents, assess the severity of incidents, "
            "and extract important contextual information from narrative descriptions."
        ),
        verbose=True,
        allow_delegation=False,
        llm=llm
    )

    # Agent 3: Policy Validation Agent
    policy_validation_agent = Agent(
        role="Policy Coverage Validator",
        goal="Validate insurance claims against policy terms using IRIS database lookup",
        backstory=(
            "You are an insurance policy expert with deep knowledge of coverage terms, "
            "exclusions, and limits. You use IRIS database methods to retrieve policy "
            "information and determine whether specific incidents are covered under customer policies."
        ),
        verbose=True,
        allow_delegation=False,
        llm=llm
    )

    # Agent 4: Fraud Detection Agent
    fraud_detection_agent = Agent(
        role="Insurance Fraud Investigator",
        goal="Detect potential fraud indicators in insurance claims",
        backstory=(
            "You are a specialist in insurance fraud detection with years of experience "
            "identifying suspicious patterns, inconsistencies, and red flags in claims. "
            "You analyze all available information to assess fraud risk."
        ),
        verbose=True,
        allow_delegation=False,
        llm=llm,
        tools=[fraud_analysis_tool]
    )

    # Agent 5: Approval Agent
    approval_agent = Agent(
        role="Claims Approval Decision Maker",
        goal="Make final approval or denial decisions based on all analysis results",
        backstory=(
            "You are a senior claims adjuster with authority to approve or deny insurance claims. "
            "You carefully weigh all factors including policy coverage, fraud risk, "
            "and incident analysis to make fair and accurate decisions."
        ),
        verbose=True,
        allow_delegation=False,
        llm=llm
    )

    # Agent 6: Notification Agent
    notification_agent = Agent(
        role="Customer Communication Specialist",
        goal="Create clear, professional notifications to inform customers about claim decisions",
        backstory=(
            "You are a customer service expert specializing in insurance communications. "
            "You craft clear, empathetic, and informative messages that explain claim "
            "decisions to customers in an understandable way."
        ),
        verbose=True,
        allow_delegation=False,
        llm=llm
    )


    def create_tasks(claim_input: dict):
        """Create all tasks for the insurance claim processing pipeline."""
        
        # Task 1: Parse Input Data
        parse_input_task = Task(
            description=f"""
            Parse and validate the following insurance claim data:
            {claim_input}
            
            Extract and structure:
            1. Customer SSN
            2. Incident date
            3. Location details
            4. Vehicle type
            5. Incident description
            6. Any other relevant information
            
            Validate data completeness and format.
            Output structured data that other agents can use.
            """,
            agent=input_parser_agent,
            expected_output="Structured JSON with all parsed claim information and validation status"
        )
        
        # Task 2: Analyze Incident Report
        analyze_report_task = Task(
            description="""
            Analyze the incident description from the parsed claim data.
            
            Provide:
            1. Summary of what happened
            2. Severity assessment
            3. Type of incident (collision, comprehensive, etc.)
            4. Key details and circumstances
            5. Any notable factors
            
            Focus on details relevant to insurance coverage determination.
            """,
            agent=report_analysis_agent,
            expected_output="Detailed incident analysis with severity assessment and coverage type classification",
            context=[parse_input_task]
        )
        
        # Task 3: Validate Policy Coverage
        validate_policy_task = Task(
            description="""
            Using the customer's SSN from the parsed claim data, retrieve and validate their insurance policy.
            
            If policy exists, analyze the returned JSON to determine:
            1. Policy status and validity dates
            2. Coverage types included (collision, comprehensive, liability, etc.)
            3. Coverage limits for each type
            4. Deductible amount
            5. Policy exclusions that might apply
            6. Whether the incident type is covered
            
            If no policy found, indicate customer has no active coverage.
            Provide specific policy details and coverage determination for the incident.
            """,
            agent=policy_validation_agent,
            expected_output="Policy lookup results and comprehensive coverage analysis with specific coverage determination",
            context=[parse_input_task]
        )
        
        # Task 4: Detect Fraud
        detect_fraud_task = Task(
            description="""
            Analyze all available information to detect potential fraud indicators.
            
            Consider:
            1. Incident report analysis results
            2. Policy validation findings
            3. Claim data patterns
            4. Suspicious elements or inconsistencies
            
            Provide fraud risk assessment with specific indicators identified.
            """,
            agent=fraud_detection_agent,
            expected_output="Fraud risk assessment with risk level and specific indicators",
            context=[parse_input_task, analyze_report_task, validate_policy_task]
        )
        
        # Task 5: Make Approval Decision
        make_decision_task = Task(
            description="""
            Based on all previous analysis, make the final claim decision.
            
            Consider:
            1. Policy coverage validation results
            2. Incident analysis findings
            3. Fraud risk assessment
            4. All relevant factors
            
            Decide: APPROVE or DENY
            Provide clear reasoning for the decision.
            """,
            agent=approval_agent,
            expected_output="Final decision (APPROVE/DENY) with detailed reasoning",
            context=[parse_input_task, analyze_report_task, validate_policy_task, detect_fraud_task]
        )
        
        # Task 6: Create Customer Notification
        create_notification_task = Task(
            description="""
            Create a professional customer notification based on the claim decision.
            
            Include:
            1. Clear statement of decision (approved/denied)
            2. Explanation of reasoning
            3. Next steps for the customer
            4. Contact information if needed
            5. Professional and empathetic tone
            
            Make it clear and understandable for the customer.
            """,
            agent=notification_agent,
            expected_output="Professional customer notification message explaining the claim decision",
            context=[make_decision_task]
        )
        
        return [
            parse_input_task,
            analyze_report_task,
            validate_policy_task,
            detect_fraud_task,
            make_decision_task,
            create_notification_task
        ]
}

}
