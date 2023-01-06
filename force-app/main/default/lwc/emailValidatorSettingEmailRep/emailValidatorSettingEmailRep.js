import { LightningElement } from 'lwc';
import saveSettings from '@salesforce/apex/EmailValidatorSettingEmailRep.saveSettings'
import settingExists from '@salesforce/apex/EmailValidatorSettingApp.settingExists'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EmailValidatorSettingEmailRep extends LightningElement {
    
    error;
    password;

    apikeyIsSet = false;

    connectedCallback() {
        this.checkSettings();
    }

    checkSettings() {
        console.log('Checking which settings are available:');
        settingExists({settingName: 'EmailRep_API_Key'})
        .then((result)=> {
            this.apikeyIsSet = result;
        })
        .catch((error)=> {
            console.log('ERROR WITH API KEY RETRIEVAL');
            console.error(error);
            this.apikeyIsSet = false;
        });
    }

    handleSave(){
        saveSettings({password: this.password})
        .then(()=>{
            this.password=null;
            this.template.querySelectorAll('lightning-input').forEach(element => {
                element.value = null;
            });
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'EmailRep API Key saved successfully.',
                variant: 'success',
            });
            this.dispatchEvent(evt);
            this.checkSettings(); 
        })
        .catch((error)=>{
            console.log(error);
        });
    }

    handleReset(){
        saveSettings({password: ''})
        .then(()=>{
            this.password=null;
            this.template.querySelectorAll('lightning-input').forEach(element => {
                element.value = null;
            });
            const evt = new ShowToastEvent({
                title: 'Cleared',
                message: 'EmailRep API Key has been deleted.',
                variant: 'info',
            });
            this.dispatchEvent(evt);
            this.checkSettings(); 
        })
        .catch((error)=>{
            console.log(error);
        });
    }

    handlePasswordChange(event){
        this.password=event.detail.value;
    }
}