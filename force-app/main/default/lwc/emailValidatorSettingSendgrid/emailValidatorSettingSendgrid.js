import { LightningElement, wire } from 'lwc';
import saveSettings from '@salesforce/apex/EmailValidatorSettingSendgrid.saveSettings'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EmailValidatorSettingSendgrid extends LightningElement {
    
    error;
    password;

    handleSave(){
        saveSettings({password: this.password})
        .then((result)=>{
            this.password=null;
            this.template.querySelectorAll('lightning-input').forEach(element => {
                element.value = null;
            });
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'Sendgrid API Key saved successfully.',
                variant: 'success',
            });
            this.dispatchEvent(evt);    
        })
        .catch((error)=>{
            console.log(error);
        });
    }

    handlePasswordChange(event){
        this.password=event.detail.value;
    }
}