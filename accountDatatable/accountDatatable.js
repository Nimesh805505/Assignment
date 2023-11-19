import { LightningElement ,api, wire, track} from 'lwc';
import getAccountRecord from '@salesforce/apex/AccountDatatableController.getAccountRecord';
const columns = [
    { label: 'Account Name', fieldName: 'accountName', type: 'text',  sortable: true },
    { label: 'Type', fieldName: 'accountType', type: 'text', sortable: true},
    { label: 'Annual Revenue', fieldName: 'annualRevenue', type: 'currency', sortable: true },
    { label: 'Phone', fieldName: 'accountPhone', type: 'phone' , sortable: false},
    { label: 'Total Contacts', fieldName: 'totalContacts', type: 'number', sortable: true },
];

export default class AccountDatatable extends LightningElement {

    accColumns = columns;
    accRecord ;
    @track sortBy;
    @track sortDirection;
    datatableHeading = 'Account Datatable';
    @wire(getAccountRecord)
    wiredAccounts({ error, data}) {
        if (data) {
                this.accRecord = data.map(record=> {
                    return {
                    totalContacts: record.totalContacts,
                    accountName: record.accRecord.Name,
                    accountType: record.accRecord.Type,
                    annualRevenue: record.accRecord.AnnualRevenue,
                    accountPhone: record.accRecord.Phone,
                    };
                });
        } else if (error) {
            console.error('Error fetching object info: ' + error);
        }
   }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        console.log('event det 37-'+event.detail.fieldName);
        this.sortDirection = event.detail.sortDirection;
        console.log('event sortDirection 39-'+  JSON.stringify(this.sortDirection));
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldName, sortDirection) {
        let cloneData = JSON.parse(JSON.stringify(this.accRecord));
    
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
     
        this.accRecord = cloneData;
    }
}