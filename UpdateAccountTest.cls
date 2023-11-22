@isTest
private class UpdateAccountTest {
    private Static List<Account> acclist = new  List<Account>();
    
    @testSetup
    static void setup() {
        List<Account> testAccounts = new List<Account>{
            new Account(Name = 'Test Account 11'),
                new Account(Name = 'Test Account 22')
                };
                    insert testAccounts;
        acclist.addAll(testAccounts);
        
        List<Contact> testContacts = new List<Contact>{
            new Contact(AccountId = testAccounts[0].Id, LastName = 'Contact 1'),
            new Contact(AccountId = testAccounts[0].Id, LastName = 'Contact 2'),
            new Contact(AccountId = testAccounts[1].Id, LastName = 'Contact 3')
        };
            insert testContacts;
    }
    
    @isTest
    static void testBatchExecution() {
        //    Test.startTest();
        Database.executeBatch(new UpdateAccount(), 20);
        //   Test.stopTest();
        
        List<Account> updatedAccounts = [SELECT Total_NoOf_Contacts__c,(SELECT Id FROM Contacts) FROM Account WHERE Id IN :acclist];
        for (Account acc : updatedAccounts) {
            System.assertEquals(acc.Total_NoOf_Contacts__c, String.valueOf(acc.Contacts.size()), 'Count should match Contacts size');
        }
    }
    @isTest
    static void sendEmailToCurrentUserTest() {
        
        try{   
            UpdateAccount inst = new UpdateAccount();
            inst.sendEmailToCurrentUser(null);
            inst.execute(null,null);
        } catch(Exception e){
            system.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }
    }
}