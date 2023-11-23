public with sharing class AccountContactController {
    
    @AuraEnabled
    public static List<Account> getAccountsByType(String selectedAccountType) {
             List<Account> acclist;
        try {
            acclist = [SELECT Id, Name FROM Account WHERE Type =: selectedAccountType WITH SECURITY_ENFORCED];
            if(acclist.size()> 0){
              return acclist;  
            }
           return acclist;    
            
        }catch (Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }     
    }
    
    @AuraEnabled   
    public static List<Contact> getContactsForAccount(Id accountId) {
        List<Contact> conList;
        try {   
            conList = [SELECT Id, Name FROM Contact WHERE AccountId = :accountId WITH SECURITY_ENFORCED];
            if(conList.size()>0){
               return conList;  
            }
            return conList;
        }catch (Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }  
        
    }
   // List has no rows for assignment to SObject
}