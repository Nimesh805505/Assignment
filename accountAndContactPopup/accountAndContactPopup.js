import { LightningElement,track } from 'lwc';

export default class AccountAndContactPopup extends LightningElement {

 @track isModalOpen = false;
 popupHeading=" Select Account Type , Accounts and its Contacts";
 openModal() {
     this.isModalOpen = true;
 }

 closeModal() {
     this.isModalOpen = false;
 }

 submitDetails() {
     this.isModalOpen = false;
 }
}