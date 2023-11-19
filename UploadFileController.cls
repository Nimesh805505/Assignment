public with sharing class UploadFileController {
    /*
* @method uploadFile() 
* @desc Creates a content version from a given file's base64 and name
* 
* @param {String} base64 - base64 string that represents the file
* @param {String} filename - full file name with extension, i.e. 'products.csv'
* @param {String} recordId - Id of the record you want to attach this file to
* 
* @return {ContentVersion} - returns the created ContentDocumentLink Id if the
*   upload was successful, otherwise returns null
*/
    @AuraEnabled
    public static void uploadFile(String base64, String filename, String recordId) {
        ContentVersion cv = createContentVersion(base64, filename);
        ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
    }
    /*
* @method createContentVersion() [private]
* @desc Creates a content version from a given file's base64 and name
* 
* @param {String} base64 - base64 string that represents the file
* @param {String} filename - full file name with extension, i.e. 'products.csv'
* 
* @return {ContentVersion} - returns the newly created ContentVersion, or null
*   if there was an error inserting the record
*/
    private static ContentVersion createContentVersion(String base64, String filename) {
        ContentVersion cv = new ContentVersion();
        try {
            cv.VersionData = EncodingUtil.base64Decode(base64);
            cv.Title = filename;
            cv.PathOnClient = filename;
            insert cv;
            return cv;
        } catch(DMLException e) {
            String errorMessage = 'An Error Occurs While Uploading File'+e.getMessage();
            throw new AuraHandledException(errorMessage); 
        }
    }
    
    /*
* @method createContentLink() [private]
* @desc Creates a content link for a given ContentVersion and record
* 
* @param {String} contentVersionId - Id of the ContentVersion of the file
* @param {String} recordId - Id of the record you want to attach this file to
* 
* @return {ContentDocumentLink} - returns the newly created ContentDocumentLink, 
*   or null if there was an error inserting the record
*/
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) {
            return null;
        }
        ContentDocumentLink cdl = new ContentDocumentLink();
        try {
            cdl.ContentDocumentId = [SELECT ContentDocumentId 
                                     FROM ContentVersion 
                                     WHERE Id =: contentVersionId].ContentDocumentId;
            
            cdl.LinkedEntityId = recordId;
            // ShareType is either 'V', 'C', or 'I'
            // V = Viewer, C = Collaborator, I = Inferred
            cdl.ShareType = 'V';
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            String errorMessage = 'An Error Occurs While Uploading File'+e.getMessage();
            throw new AuraHandledException(errorMessage); 
        }
    } 
    
    @AuraEnabled
    public static List<ContentDocumentLink> getAllContactFile(Id recordId) {
        try {
            return [ SELECT Id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :recordId
                   ];
        }catch (Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }     
    }   
    @AuraEnabled
    public static void removeFile(String fileLinkId) {
        try {
            ContentDocumentLink selectedFile = [SELECT Id
                                                FROM ContentDocumentLink
                                                WHERE Id = :fileLinkId
                                                LIMIT 1
                                               ];
            if (selectedFile != null) {
                delete selectedFile;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage()); 
        }
    }
}