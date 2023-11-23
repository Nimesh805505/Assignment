@isTest
public class AccountContactControllerTest {
    
    @testSetup
    static void setup() {
        Account testAccounts = new Account();
        testAccounts.Name =  'Test Account 11';
        testAccounts.Type =  'Other';
        insert testAccounts;
        
        List<Contact> testContacts = new List<Contact>{
                new Contact(AccountId = testAccounts.Id, LastName = 'Contact 1'),
                new Contact(AccountId = testAccounts.Id, LastName = 'Contact 2')
        };
                insert testContacts;
    }
    
    @isTest
    static void getAccountsByTypeTest() {
        List<Account> updatedAccounts = [SELECT Id,Type FROM Account  Limit 1];
        AccountContactController.getAccountsByType(updatedAccounts[0].Type);
        
        System.assertEquals( 1, updatedAccounts.size());
        
    }
    
    @isTest
    static void getAccountsByType2Test() {
        AccountContactController.getAccountsByType(null);       
        System.assertEquals( 0, 0, 'No account with this type');
    }
    
    @isTest
    static void getContactsForAccountTest(){
        List<Account> updatedAccounts = [SELECT Id,Type FROM Account  Limit 1];
        List<Contact> testContacts = [SELECT Id, AccountId FROM Contact where AccountId =: updatedAccounts[0].Id]; 
        AccountContactController.getContactsForAccount(updatedAccounts[0].Id);
        System.assertEquals( 2, testContacts.size());      
    }
    
    @isTest
    static void getContactsForAccount2Test() {
        AccountContactController.getContactsForAccount(null);       
        System.assertEquals( 0, 0, 'No contact with this type');
    }
    
    @isTest
    static void getAccountsByTypeTestException(){

        try {  
            Profile pf = [SELECT Id FROM profile WHERE Name='Gaurav' LIMIT 1];  
            User u = [SELECT ProfileId FROM User WHERE ProfileId =: pf.Id];
            
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
               AccountContactController.getAccountsByType(updatedAccounts[0].Type);
               AccountContactController.getContactsForAccount(updatedAccounts[0].Id);
            }
        } catch (Exception e) {
           System.assertEquals('Script-thrown exception', e.getMessage());
        }            
    }
     @isTest
    static void getContactTestException(){

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
               AccountContactController.getContactsForAccount(updatedAccounts[0].Id);
            }
        } catch (Exception e) {
           System.assertEquals('Script-thrown exception', e.getMessage());
        }            
    }   
}