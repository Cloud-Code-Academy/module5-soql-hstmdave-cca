/**
 * The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
 * It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
 *
 * This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
 * a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
 * records, and manage data volume using the LIMIT keyword.
 *
 * Topics covered in this class include:
 * - Understanding the structure of a SOQL query.
 * - Crafting basic SELECT statements in SOQL.
 * - Applying filters using the WHERE clause in SOQL.
 * - Fetching related records using Relationship queries.
 * - Controlling the amount of data retrieved using the LIMIT keyword.
 *
 * Users of this class can expect to gain a solid understanding of SOQL in Apex and
 * be prepared to handle data retrieval tasks in Salesforce development.
 *
 * @author Dave B
 */

public with sharing class SOQL {
	/**
	 * Question 1
	 * Update/Uncomment the template code to create a method
	 * Returns all leads from Salesforce Org
	 * @return List of all leads with Id, LastName, Company, Phone, Email
	 * Update the corresponding test class and testGetAllLeads method to cover this method
	 */
	//[public | private ] [static] data_type method_name (input parameters) {
	//  The body of the method
	//}

	public static List<Lead> getAllLeads() {
		List<Lead> getLeads = 	[SELECT Id, LastName, Company, Phone, Email 
								FROM Lead];
		return getLeads;
	}

	/**
	 * Question 2
	 * Update/Uncomment the template code to create a method
	 * Returns all contacts with first name of John.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByFirstName method to cover this method
	 */
	//[public | private ] [static] data_type method_name (input parameters) {
	//  The body of the method
	//}

	public static List<Contact> getAllJohns() {
		List<Contact> allJohns = 	[SELECT Id, Name 
									FROM Contact 
									WHERE FirstName = 'John'];
		return allJohns;
	}

	/**
	 * Question 3
	 * Update/Uncomment the template code to create a method
	 * Returns the Contact Id for all contacts with last name of Smith or Jones
	 * @return A list of Contact Ids.
	 * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
	 */
	//[public | private ] [static] data_type method_name (input parameters) {
	//  The body of the method
	//}

	public static List<Id> getIdByLastName() {
		List<Contact> contactsByLastName = 	[SELECT Id 
											FROM Contact 
											WHERE LastName IN ('Smith', 'Jones')];
		
		List<Id> contactIdList = new List<Id>();

		for(Contact iteration : contactsByLastName) {
			contactIdList.add(iteration.Id);
		}
		return contactIdList;
	}

	/**
	 * Question 4
	 * Update/Uncomment the template code to create a method
	 * Returns List of closed won opportunities for a specific Account.
	 * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Opportunities with important opportunities fields
	 * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
	 */
	//[public | private ] [static] data_type method_name (input parameters) {
	//  The body of the method
	//}

	public static List<Opportunity> getOppsByAcct(Id accountId) {
		List<Opportunity> oppsByAcct = 	[SELECT Id, Name, StageName, Amount, CloseDate, Account.Name 
										FROM Opportunity 
										WHERE AccountId = :accountId
										AND StageName = 'Closed Won'];
		return oppsByAcct;
	}

	/**
	 * Question 5
	 * Update/Uncomment the template code to create a method
	 * Returns the total count of Account records.
	 * @return The Integer count of Account records.
	 * Update the corresponding test class and testGetAccountCount method to cover this method
	 */
	//[public | private ] [static] data_type method_name (input parameters) {
	//  The body of the method
	//}

	public static Integer getCountOfAccounts() {
		Integer countOfAccts = 	[SELECT COUNT() 
								FROM Account];
		return countOfAccts;
	}

	/**
	 * Question 6
	 * Update/Uncomment the template code to create a method
	 * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
	 * @return A map of Task Ids to Task records.
	 * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
	 */
	//[public | private ] [static] data_type method_name (input parameters) {
	//  The body of the method
	//}

	// NOTES TO SELF
	// Trying first with a for loop
	// This works, but could be more efficient?
	/*
	public static Map<Id, Task> getTaskMap() {
		Map<Id, Task> taskMap = new Map<Id, Task>();
		Date futureDate = Date.today();

		for(Task iteration : [SELECT Id FROM Task WHERE ActivityDate < :futureDate.addDays(8)]) {
			taskMap.put(iteration.Id, iteration);
		}

		return taskMap;
	}
	*/

	// Trying with direct assignment from SOQL query 
	// Had to add a second field to create map and move the entire query to the return statement.

	public static Map<Id, Task> getTaskMap() {
		return new Map<Id, Task> (	[SELECT Id, ActivityDate 
									FROM Task 
									WHERE ActivityDate < :Date.today().addDays(8)]
								 );
		
	}

	/**
	 * Question 7
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Contacts that have a example.com domain in their Email.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
	 */
	//[public | private ] [static] data_type method_name (input parameters) {
	//  The body of the method
	//}

	// NOTES TO SELF
	// Try using same direct assignmenet from Question 6
	// Error indicating SOQL needed to query Contact.Name - added to query and success.

	public static List<Contact> getContactByEmail() {
		return new List<Contact> (	[SELECT Id, Email, Name
									FROM Contact
									WHERE Email LIKE '%example.com']
								 );
	}

	

	/**
	 * Question 8
	 * Retrieves all Opportunities that have a specific keyword in their Name.
	 * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
	 * @param keyword The keyword to search for in the Opportunity Name.
	 * @return A list of Opportunity records.
	 */
	
	// NOTES TO SELF
	// This passes, but seems susceptible to injection attacks.  Revisit for a more secure code block, if time allows

	 public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
		String keywordValue = '%' + keyword + '%';
		return new List<Opportunity> (	[SELECT Id, Name
										FROM Opportunity
										WHERE Name LIKE :keywordValue]); // Replace null with the variable you used to store the result
	}

	/**
	 * Question 9
	 * Retrieves all Cases that Case Origin is not Web or Email or Blank
	 * @return A list of Case records.
	 */
	public static List<Case> getFilterCaseOrigins() {
		return new List<Case>( [SELECT Id, Origin
								FROM Case
								WHERE Origin NOT IN('Web', 'Email', '')]
							 ); // Replace null with the variable you used to store the result
	}

	/**
	 * Question 10
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
	 * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
	 * @param leadSource The Lead Source to search for.
	 * @param keyword The keyword to search for in the Lead Title.
	 * @return A list of Lead records.
	 * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
	 */
	//[public | private ] [static] data_type method_name (input parameters) {
	//  The body of the method
	//}

	public static List<Lead> getLeadsBySourceAndTitle(String leadSource, String keyword) {
		String titleKeyword = '%' + keyword + '%';
		return new List<Lead>(	[SELECT Id, LeadSource, Title, LastName, Company, Phone, Email
								FROM Lead
								WHERE LeadSource = :leadSource
								OR Title LIKE :titleKeyword]
							 );
	}

	/**
	 * Question 11
	 * Returns the names of all Contacts associated with an Account.
	 * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Contact LastName.
	 */
	public static List<String> getContactNamesByAccount(Id accountId) {
		// Create a list to hold the Contact LastNames

		// Query the Contacts
		// Loop through each Contact and add the LastName to the list
		//for () {
		//
		//}

		// Return the list of Contact LastNames

		List<String> contactLastNames = new List<String>();
															
		for(Contact iteration : [SELECT LastName
								FROM Contact
								WHERE AccountId = :accountId]) {
			contactLastNames.add(iteration.LastName);
		}

		return contactLastNames; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 12
	 * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
	 * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
	 * @param stage The Stage value to filter Opportunities.
	 * @return The total revenue.
	 */
	public static Decimal getTotalRevenueByStage(String stage) {
		// Use AggregateQuery to get the total revenue

		// Return the total revenue
		Decimal minAmount = 10000.00;
		AggregateResult[] sumByStage = [SELECT SUM(Amount) sumAmnt
										FROM Opportunity 
										WHERE StageName = :stage
										OR Amount > :minAmount];
		
		return (Decimal)sumByStage[0].get('sumAmnt'); // Replace null with the variable you used to store the result
	}

	/**
	 * Question 13
	 * Retrieves the first 10 Accounts ordered by Name.
	 * @return A list of the first 10 Accounts ordered by Name.
	 */
	public static List<Account> getFirstTenAccounts() {
		Integer numLimit = 10;
		return new List<Account>(	[SELECT Name
									FROM Account
									ORDER BY Name
									LIMIT :numLimit]
								); // Replace null with the variable you used to store the result
	}

	/**
	 * Question 14
	 * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 */
	public static List<Opportunity> getHighValueOpportunities() {
		Decimal minAmount = 100000.00;
		Integer numLimit = 5;
		return new List<Opportunity>(	[SELECT Amount, CloseDate
										FROM Opportunity
										WHERE Amount > :minAmount
										ORDER BY CloseDate
										LIMIT :numLimit]
									); // Replace null with the variable you used to store the result
	}

	/**
	 * Question 15
	 * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
	 * @return A list of Contacts
	 */
	public static List<Contact> getBirthdateContacts() {
		Integer numLimit = 3;
		return new List<Contact>(	[SELECT Id, Name, Birthdate
									FROM Contact
									ORDER BY Birthdate DESC
									LIMIT :numLimit]
								); // Replace null with the variable you used to store the result
	}

	/**
	 * Question 16
	 * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
	 * @return A list of Cases
	 */
	public static List<Case> getCasesWithStatus() {
		String caseStatus = 'Open';
		Integer numLimit = 10;
		Integer numOffset = 5;
		return new List<Case>(	[SELECT Id, Status, CreatedDate
								FROM Case
								WHERE Status = :caseStatus
								ORDER BY CreatedDate
								LIMIT :numLimit
								OFFSET :numOffset]
							); // Replace null with the variable you used to store the result
	}

	/**
	 * Question 17
	 * Returns Set of Case Ids for a specific Account.
	 * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A set of Case Ids.
	 */
	public static Set<Id> getCaseIdsByAccount(Id accountId) {
		// Create a set to hold the Case Ids

		// Query the Cases
		// Loop through each Case and add the Id to the set
		//for () {
		//
		//}
		Set<Id> caseIds = new Set<Id>();

		for(Case iteration : 	[SELECT Id, AccountId
								FROM Case
								WHERE AccountId = :accountId]) {
			caseIds.add(iteration.Id);
		}

		return caseIds; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 18
	 * Return Map of Account Ids to Account Names Not in a specific Country.
	 * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
	 * @param country The country to filter Accounts.
	 * @return A map of Account Ids to Account Names.
	 */
	public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
		// Create a map to hold the Account Ids to Account Name
		// Query the Accounts
		// Loop through each Account and add the Id and Name to the map
		Map<Id, String> accountIdsToNames = new Map<Id, String>();

		Map<Id, Account> accountMap = new Map<Id, Account> ([SELECT Id, Name
															FROM Account
															WHERE BillingCountry != :country]); 

		for(Id iteration : accountMap.keySet()) {
			accountIdsToNames.put(iteration, accountMap.get(iteration).Name);
		}
									
		return accountIdsToNames; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 19
	 * Retrieves the Account Name for a given Contact.
	 * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
	 * @param contactId The Id of the Contact.
	 * @return The Account Name of the Contact.
	 */
	public static String getAccountNameForContact(String contactId) {
		String accountName = null;
		List<Contact> contactAccount = 	[SELECT Account.Name
										FROM Contact
										WHERE Id = :contactId];

		if(!contactAccount.isEmpty()) {
			accountName = contactAccount[0].Account.Name;
		}

		return accountName; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 20
	 * Returns single Account that has related opportunities in the same query
	 * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
	 * @param accountId The ID of the Account.
	 * @return An Account record with related Opportunities.
	 */
	public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {

		List<Account> acctList = new List<Account>(	[SELECT Name,
															(SELECT Id, Name
										 	 				FROM Opportunities)
													FROM Account
													WHERE Id = :accountId]
												  );
														 
		if(!acctList.isEmpty()) {
			return acctList[0];
		}
		else {
			return null;
		}
		// Replace null with the variable you used to store the result
	}

	/**
	 * Question 21
	 * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
	 * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
	 * @param Account Id
	 * @return List of contacts with the same Mailing State as the Account Billing State
	 */
	public static List<Contact> getAccountsWithContactsByState(Id accountId) {
		// Query the Account

		// Store the Account's BillingState

		// Query the Contacts

		Account acct = 	[SELECT Id, BillingState
						FROM Account
						WHERE Id = :accountId];
		
		String acctState = acct.BillingState;

		return new List<Contact>(	[SELECT Id, Name, MailingState
									FROM Contact
									WHERE MailingState = :acctState]
								); // Replace null with the variable you used to store the result
	}

	/**
	 * Question 22
	 * Extracts email domains from them leads, then finds Accounts with matching website domains
	 * If Lead Email = test@test.com return account with website = www.test.com
	 * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
	 * @param A set of Lead Ids.
	 * @return A list of Accounts with matching email domains.
	 */
	public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
		// Query the Leads

		// Create a set of email domains from the Leads

		// Loop through each Lead

		// Get the email from the Lead

		// Check if the email is not null

		// Add the email domain to the set

		// Query the Accounts

		List<Lead> leadList = new List<Lead>([SELECT Id, Email
												FROM Lead
												WHERE Id IN :leadIds]
											);

		Set<String> emailDomains = new Set<String>();

		for(Lead iteration : leadList) {
			if(iteration.Email != null && iteration.Email != '') {
				String extractDomain = iteration.Email.subStringAfter('@');
				emailDomains.add('%' + extractDomain);
			}
		}

		return new List<Account>(	[SELECT Id, Website
									FROM Account
									WHERE Website LIKE :emailDomains]
									); // Replace null with the variable you used to store the result
	}

	/**
	 * Question 23
	 * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
	 * Adds a randomized number between 1 to 3 to the quantity of each line item.
	 * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
	 * @param Original Opportunity Id
	 * @param List of cloned Opportunity Ids
	 */
	public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
		// Query the original Opportunity Line Items

		// Create a list to hold the new line items

		// Generate a random number between 1 and 3

		// Loop through each cloned Opportunity Id

		// Loop through each original line item

		// Clone the original line item and add the random number to the quantity

		// Insert the new line items

		List<OpportunityLineItem> oliToClone =  [SELECT Id, OpportunityId, Quantity, PricebookEntryId, UnitPrice
												FROM OpportunityLineItem
												WHERE OpportunityId = :origOppId];

		List<OpportunityLineItem> newOLIs = new List<OpportunityLineItem>();

		Double randomNumber = Math.random() * (3 - 1 + 1) + 1;

		for(Id oppIds : cloneOppIds) {
			for(OpportunityLineItem origOLI : oliToClone) {
				OpportunityLineItem clonedOLI = origOLI.clone(false, true, false, false);
				clonedOLI.OpportunityId = oppIds;
				clonedOLI.Quantity = (Integer)randomNumber;
				newOLIs.add(clonedOLI);
			}
		}

		if(!newOLIs.isEmpty()) {
			insert newOLIs;
		}

	}

	/**
	 * Question 24
	 * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
	 * @return A list of filtered Opportunity
	 */
	public static List<Opportunity> getOpportunityDetailsForClosedWon() {
		String oppStageName = 'Closed Won';

		return new List<Opportunity>([SELECT Name, Account.Name, Owner.Name, StageName
									FROM Opportunity
									WHERE StageName = :oppStageName]
									);//Replace null with the variable you used to store the result
	}

	/**
	 * Question 25
	 * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to the Contact on the associated Account with the alphabetically first first name.
	 * Example: if there are two Contacts on the Account, "Billy" and "Abby," the 'Primary_Contact__c' will be set to "Abby."
	 */
	public static void setPrimaryContact() {
		//Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
		
		// Create a set of Account Ids from the Opportunities

		// Query the Contacts

		// Loop through each Contact and add the Account Id and Contact to the map

		// Loop through each Opportunity

		// Update the Opportunity primary contact from accountToContactMap

		// Update the Opportunities

		List<Opportunity> closedWonOpps = getOpportunityDetailsForClosedWon();

		if(closedWonOpps.isEmpty()) {
			return;
		}

		Set<Id> acctId = new Set<Id>();
		
		for(Opportunity iteration : closedWonOpps) {
			if(iteration.AccountId != null) {
				acctId.add(iteration.AccountId);
			}
		}

		if(acctId.isEmpty()) {
			return;
		}

		Map<Id, Contact> acctToContactMap = new Map<Id, Contact>();

		for(Contact iteration : [SELECT Id, AccountId
								FROM Contact
								WHERE AccountId IN :acctId
								ORDER BY FirstName ASC]) {
			if(!acctToContactMap.containsKey(iteration.AccountId)) {
				acctToContactMap.put(iteration.AccountId, iteration);
			}
		}

		for(Opportunity iteration : closedWonOpps) {
			Contact primaryContact = acctToContactMap.get(iteration.AccountId);
			if(primaryContact != null) {
				iteration.Primary_Contact__c = primaryContact.Id;
			}
		}

		update closedWonOpps;

	}
}
