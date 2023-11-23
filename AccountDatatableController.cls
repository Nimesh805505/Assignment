public with sharing class AccountDatatableController {
    
    @AuraEnabled(cacheable = true)
    public static List<AccountWrapper>  getAccountRecord() {
        List<AccountWrapper> accountData = new List<AccountWrapper>();
        try {
            List<Account> accountsWithContacts = [SELECT Id, Name, Type, AnnualRevenue, Phone, (SELECT Id FROM Contacts) 
                                                  FROM Account  WITH SECURITY_ENFORCED
                                                  LIMIT 10];
            for (Account acc : accountsWithContacts) {
                accountData.add(new AccountWrapper(acc, acc.Contacts.size()));
            }
                 
        }catch (Exception e){ 
            throw new AuraHandledException(e.getMessage()); 
        }
        return  accountData;  
    }

    public class AccountWrapper {
        @AuraEnabled
        public Account accRecord ;
        @AuraEnabled
        public Integer totalContacts ;
 
        public AccountWrapper(Account acc, Integer count) {
            accRecord = acc ;
            totalContacts = count;
        }
    }
}