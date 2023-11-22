@isTest
public class AccountContactControllerTest {
    private Static List<Account> acclist = new  List<Account>();
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
    static void getAccountsByTypeTest() {
        List<Account> updatedAccounts = [SELECT Id,Type FROM Account  Limit 1];
        AccountContactController.getAccountsByType(updatedAccounts[0].Type);
        
        System.assertEquals( 1, updatedAccounts.size());

    }
    @isTest
    static void getContactsForAccountTest(){
        
        List<Account> updatedAccounts = [SELECT Id,Type FROM Account  Limit 1]; 
          AccountContactController.getContactsForAccount(updatedAccounts[0].Id);
              
    }
}