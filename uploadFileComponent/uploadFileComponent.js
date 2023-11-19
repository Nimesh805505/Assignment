import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadFile from '@salesforce/apex/UploadFileController.uploadFile'
export default class UploadFileComponent extends LightningElement {
    @api recordId;
    @api removeButtonDisable;
    fileData
    acceptFormat =  ".xlsx, .xls, .csv, .png, .doc, .docx, .pdf"
    buttonDisable = true;

    openfileUpload(event) {
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.recordId
            }
            console.log('this is file data 28'+this.fileData)
        }
        reader.readAsDataURL(file)
        this.buttonDisable = false;
    }
    
    handleUploadFile(){
        const {base64, filename, recordId} = this.fileData
        uploadFile({ base64, filename, recordId })
        .then(result=>{
            this.fileData = null
            this.removeButtonDisable = false; //pass this value
            this.handleTostmessage(filename +' uploaded successfully!!','Success!!!','Success');
        })
        .catch((error) => {
            this.handleTostmessage('Error while Uploading file!!',error,'Error');
        });
        this.buttonDisable = true;
    }

    handleTostmessage(msg,titlemsg,varientMsg) {
        const evt = new ShowToastEvent({
            title: titlemsg ,
            message: msg,
            variant: varientMsg
        });
        this.dispatchEvent(evt);
    }
}