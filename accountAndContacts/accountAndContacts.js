import { LightningElement, track, wire } from 'lwc';
import { getObjectInfo, getPicklistValues} from 'lightning/uiObjectInfoApi'
import TYPE_FIELD  from '@salesforce/schema/Account.Type'
import ACCOUNT_OBJECT from '@salesforce/schema/Account'
import getAccountsByType from '@salesforce/apex/AccountContactController.getAccountsByType';
import getContactsForAccount from '@salesforce/apex/AccountContactController.getContactsForAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountAndContacts extends LightningElement {
    @track selectedAccountType;
    @track selectedAccountId;
    @track selectedContactId;
 
    accountTypeOptions = [];
    @track accountOptions = [];
    @track contactOptions = [];

    accounttablelable= 'Select Account Type , Account and its contacts';

    @wire(getObjectInfo, {objectApiName:ACCOUNT_OBJECT})
    objectInfo

    generatePicklist(data){
        return data.values.map(item=>({ label: item.label, value: item.value }))
    }

    @wire(getPicklistValues, { recordTypeId:'$objectInfo.data.defaultRecordTypeId', fieldApiName:TYPE_FIELD})
    typePicklist({data, error}){
        if(data){
            console.log(data)
             this.accountTypeOptions = [...this.generatePicklist(data)]
        }
        if(error){
            console.error(error)
        }
    }
 
    handleAccountTypeChange(event) {
        this.selectedAccountType = event.detail.value;
        this.selectedAccountId = null;

        this.contactOptions = [];
        this.loadAccounts();
    }
 
    handleAccountChange(event) {
        this.selectedAccountId = event.detail.value;
        this.loadContacts();
    }
 
    loadAccounts() {
       getAccountsByType({ selectedAccountType: this.selectedAccountType })
            .then((result) => {
                if(result.length === 0){                   
                    this.showErrorToast('No Account Found');
                    this.accountOptions =[];
                }else{
                    let aaryDemo=[]
                    for(let i = 0; i < result.lenght ; i++){
                        aaryDemo.push({
                            label: result[i].Name,
                            value: result[i].Id,
                        });                      
                     }
                     this.accountOptions = aaryDemo;
                }

            })   
            .catch((error) => {
                console.error('Error loading Account Data'+ error);
                this.showErrorToast(error);
            });
    }
 
    loadContacts() {
        getContactsForAccount({ accountId: this.selectedAccountId })
        .then((result) => {
            if(result.length === 0){                   
                this.showErrorToast('No Contact Found');
                this.contactOptions =[];
            }else{
                this.contactOptions = result.map((con) => ({
                    label: con.Name,
                    value: con.Id,
                }));
            }
        })   
        .catch((error) => {
            console.error('Error loading Contact Data'+ error);
            this.showErrorToast(error);
        });
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