import { LightningElement, wire,track } from 'lwc';
import SAMPLEMC from "@salesforce/messageChannel/SampleMessageChannel__c"
import {subscribe, MessageContext,APPLICATION_SCOPE } from 'lightning/messageService';
import getContactsForAccount from '@salesforce/apex/AccountContactController.getContactsForAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns = [
    { label: 'Name', fieldName: 'Name', sortable: true},
    { label: 'Email', fieldName: 'Email', type: 'email', sortable: true},
    { label: 'Phone', fieldName: 'Phone', type: 'phone', sortable: true }
];
 
export default class DisplayContactFromAura extends LightningElement {
    receivedAccountId ;
    subscription;
    contactsRecord;
    columns = columns;
    dataLoad = false;
    @track sortBy;
    @track sortDirection;

    @wire(MessageContext)
    context

    connectedCallback(){
        this.subscribeMessage()
    }

    subscribeMessage(){
        //subscribe(messageContext, messageChannel, listener, subscriberOptions)
        this.subscription= subscribe(this.context, SAMPLEMC, (message)=>{this.handleMessage(message)}, {scope:APPLICATION_SCOPE})
    }

    handleMessage(message){
        this.receivedAccountId = message.lmsData.value;
        if(message!=null){
            this.dataLoad = true;
        }
        this.loadContacts();
    }

    loadContacts() {
        getContactsForAccount({ accountId: this.receivedAccountId })
        .then((result) => {
            this.contactsRecord = result.map(record=> {
                return {
                Name: record.Name,
                Email: record.Email,
                Phone: record.Phone,
                };
            });
        })   
        .catch((error) => {
            this.showErrorToast(error);
        });
    }
    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldName, sortDirection) {
        let cloneData = JSON.parse(JSON.stringify(this.contactsRecord));
    
        cloneData = cloneData.sort((a, b) => {
            let valueA = a[fieldName];
            let valueB = b[fieldName];
     
            if (typeof valueA === 'string') {
                valueA = valueA.toLowerCase();
                valueB = valueB.toLowerCase();
            }   
            if (valueA < valueB) {
                return sortDirection === 'asc' ? -1 : 1;
            } else if (valueA > valueB) {
                return sortDirection === 'asc' ? 1 : -1;
            } else {
                return 0;
            }
        });
     
        this.contactsRecord = cloneData;
    }

    showErrorToast(msg) {
        const evt = new ShowToastEvent({
            title: 'Error!!!',
            message:msg ,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
   }