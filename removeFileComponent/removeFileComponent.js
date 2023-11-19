import { LightningElement, api,track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllContactFile from '@salesforce/apex/UploadFileController.getAllContactFile';
import removeFileLink from '@salesforce/apex/UploadFileController.removeFile';
export default class RemoveFileComponent extends LightningElement {
    @api recordId;
    @api removeButtonDisable;
    
    @track isModalOpen = false;
    popupHeading=" Select File to Remove";
    uploadedFiles;
    
    connectedCallback(){
        this.getAllContactFile();
    }

    getAllContactFile() {
        getAllContactFile({ recordId :this.recordId })
            .then(result => {
                this.uploadedFiles = result;
                if( this.uploadedFiles.length > 0 ){
                    this.removeButtonDisable = false;
                }else{
                    this.removeButtonDisable = true;
                }
            })
            .catch(error => {
                console.error('Error fetching files:', error);
            });
    }

    handleRemovePopup(){
        this.uploadedFiles = [];
        this.isModalOpen = true;
        this.getAllContactFile();
    }

    closeModal() {
        this.isModalOpen = false;
    }

    submitDetails() {
        this.isModalOpen = false;
    }

    handleRemoveFile(event) {
        const fileId = event.target.dataset.fileId;
        removeFileLink({ fileLinkId: fileId })
            .then(result => {
                this.showToast('File removed successfully.', 'success');
                this.getAllContactFile();
            })
            .catch(error => {
                console.error('Error removing file:', error);
                this.showToast('Error removing file.', 'error');
            });
    }

    showToast(message, variant) {
        const event = new ShowToastEvent({
            title: 'File Removal',
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

}