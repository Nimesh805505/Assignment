import { LightningElement, api } from 'lwc';
import CONTACT_OBJECT from '@salesforce/schema/Contact'
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import TITLE_FIELD from '@salesforce/schema/Contact.Title'
import ACCOUNT_FIELD from '@salesforce/schema/Contact.AccountId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class EditContactRecord extends LightningElement {

    @api recordId;
    objectApiName = CONTACT_OBJECT;
    fields={ 
        accountField : ACCOUNT_FIELD,
        nameField : NAME_FIELD,
        titleField : TITLE_FIELD,
        phoneField : PHONE_FIELD
    }
    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'Success!!!',
            message: 'Contact Record Updated',
            variant: 'Success'
        });
        this.dispatchEvent(evt);
    }
}