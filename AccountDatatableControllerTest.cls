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
     @isTest
    static void getAccountsTestException(){

        try {  
            Profile pf = [SELECT Id FROM profile WHERE Name='Gaurav' LIMIT 1]; 
            
            String orgId = UserInfo.getOrganizationId(); 
            String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
            Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
            String uniqueName = orgId+dateString+RandomId; 
            User uu = new User(firstname = 'ABC', 
                             lastName = 'XYZ', 
                             email = uniqueName + '@test' + orgId + '.org', 
                             Username = uniqueName + '@test' + orgId + '.org', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             Alias = uniqueName.substring(18, 23), 
                             TimeZoneSidKey = 'America/Los_Angeles', 
                             LocaleSidKey = 'en_US', 
                             LanguageLocaleKey = 'en_US', 
                             ProfileId = pf.Id
                            ); 
            insert uu;
            
            
            List<Account> updatedAccounts = [SELECT Id,Type FROM Account  Limit 1];
            System.runAs(uu) {
                   AccountDatatableController.getAccountRecord();
            }
        } catch (Exception e) {
           System.assertEquals('Script-thrown exception', e.getMessage());
        }            
    }
    
}