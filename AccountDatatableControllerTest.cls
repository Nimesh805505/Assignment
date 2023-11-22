@isTest
Private class AccountDatatableControllerTest {
  private Static List<Account> acclist = new  List<Account>();
    String accId;
    @testSetup
    static void setup() {
         Account testAccounts = new Account();
         testAccounts.Name =  'Test Account 11';
         testAccounts.Type =  'Other';
         insert testAccounts;
        
        acclist.add(testAccounts);
        
        List<Contact> testContacts = new List<Contact>{
            new Contact(AccountId = testAccounts.Id, LastName = 'Contact 1'),
            new Contact(AccountId = testAccounts.Id, LastName = 'Contact 2')
        };
            insert testContacts;
    }
   @isTest
    static void getAccountsTest() {
        List<Account> updatedAccounts = [SELECT Id,Type FROM Account  Limit 1];
        
        AccountDatatableController.getAccountRecord();
    }  
    
}