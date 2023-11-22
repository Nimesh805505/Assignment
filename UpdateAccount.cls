public class UpdateAccount implements Database.Batchable<sObject>{
    public  List<Account> allupdatedAccount = new List<Account>();
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Name,Total_NoOf_Contacts__c, (SELECT Id FROM Contacts) FROM Account]);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> accList) {
        List<Account> accountsToUpdate = new List<Account>();
        try{
            for(Account acc : accList) {
                acc.Total_NoOf_Contacts__c = String.valueOf(acc.Contacts.size());
                accountsToUpdate.add(acc);                 
            }
            if(accountsToUpdate.size()>0){
                update accountsToUpdate; 
                allupdatedAccount.addAll(accountsToUpdate);
            }                             
            
        } Catch (Exception e){
             string error = e.getMessage();
            sendEmailforException(error ,'Apex error message');
        }
        
    }
    
    public void finish(Database.BatchableContext bc) {
        sendEmailToCurrentUser(allupdatedAccount);
    }
    @testVisible
    private void sendEmailToCurrentUser(List<Account> accListUpdated) {
        try {
            String currentUserEmail = UserInfo.getUserEmail();
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[]{ currentUserEmail });
            mail.setSubject('Account Contacts Count Updated');
            
            String emailBody = 'Account Name - Total Contacts\n';
            for(Account acc : accListUpdated) {
                emailBody += acc.Name + ' - ' + acc.Total_NoOf_Contacts__c + '\n';
            }
            mail.setPlainTextBody(emailBody);
            
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {mail};
                Messaging.SendEmailResult[] result = Messaging.sendEmail(messages);
        } Catch(Exception e) {
            string error = e.getMessage();
            sendEmailforException(error ,'Error while sending mail');
        }
    }
      private void sendEmailforException(String error, String displaymsg) {
            String currentUserEmail = UserInfo.getUserEmail();      
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {currentUserEmail};
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName(displaymsg);
            mail.setSubject('Error from Org : ' + UserInfo.getOrganizationName());
            mail.setPlainTextBody(error);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}