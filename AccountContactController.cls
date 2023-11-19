public with sharing class AccountContactController {

@AuraEnabled
public static List<Account> getAccountsByType(String selectedAccountType) {
    try {
        return [SELECT Id, Name FROM Account WHERE Type =: selectedAccountType];

    }catch (Exception e){
        throw new AuraHandledException(e.getMessage()); 
    }     
}

@AuraEnabled
public static List<Contact> getContactsForAccount(Id accountId) {
    try {
        return [SELECT Id, Name FROM Contact WHERE AccountId = :accountId];
    }catch (Exception e){
        throw new AuraHandledException(e.getMessage()); 
    }  

    }
}