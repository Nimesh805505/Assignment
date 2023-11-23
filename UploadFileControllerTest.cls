@IsTest
public class UploadFileControllerTest {
    @isTest
    static void testUploadFile() {
        Contact testContact = new Contact(LastName = 'TestContact');
        insert testContact;
        
        String testBase64 = EncodingUtil.base64Encode(Blob.valueOf('Test File Content'));
        String testFilename = 'testfile.txt';
        
        UploadFileController.uploadFile(testBase64, testFilename, testContact.Id);
        
        List<ContentDocumentLink> resultLinks = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :testContact.Id];
        System.assertEquals(1, resultLinks.size(), 'File upload failed');
    }
    
    @isTest
    static void createContentVersionException() {        
        String testBase64 = EncodingUtil.base64Encode(Blob.valueOf('Test File Content'));
        try{
            UploadFileController.createContentVersion(testBase64, null);
        }catch(exception e) {
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        
    }
    
    
    @isTest
    static void testRemoveFile() {
        Contact testContact = new Contact(LastName = 'TestContact');
        insert testContact;
        
        String testBase64 = EncodingUtil.base64Encode(Blob.valueOf('Test File Content1'));
        String testFilename = 'testfile1.txt';
        
        ContentVersion cv=new Contentversion();
        cv.title='ABC1';
        cv.contenturl='abc1';
        insert cv;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        system.debug(' documents '+documents);
        ContentDocumentLink testLink = new ContentDocumentLink(
            LinkedEntityId = testContact.Id,
            ContentDocumentId = documents[0].id
        );
        insert testLink;
        UploadFileController.removeFile(testLink.Id);
        
        
        List<ContentDocumentLink> resultLinks = [SELECT Id FROM ContentDocumentLink WHERE Id = :testLink.Id];
        System.assertEquals(0, resultLinks.size(), 'File removal failed');
    }
    @IsTest
    static void testGetAllContactFile() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        UploadFileController.getAllContactFile(testAccount.Id);
        
    }
    @IsTest
    static void testRemoveFileException() {      
        try {
            Contact testContacts = new Contact();
            testContacts.LastName = 'testContact2';
            insert testContacts;  
            UploadFileController.removeFile(testContacts.Id);
        } catch (Exception e) {
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        
    } 
    @IsTest
    static void getAllContactFileException() {      
        try {  
            UploadFileController.getAllContactFile(null);
        } catch (Exception e) {
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        
    }
    @isTest
    static void getuploadfileException(){

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
            
        Contact testContact = new Contact(LastName = 'TestContact');
        insert testContact;
        
        String testBase64 = EncodingUtil.base64Encode(Blob.valueOf('Test File Content'));
        String testFilename = 'testfile.txt';
        
       
            System.runAs(uu) {
                   UploadFileController.uploadFile(testBase64, testFilename, testContact.Id);
            }
        } catch (Exception e) {
           System.assertEquals('Script-thrown exception', e.getMessage());
        }            
    }  
}