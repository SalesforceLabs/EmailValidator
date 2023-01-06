import { LightningElement, wire } from 'lwc';
import saveSettings from '@salesforce/apex/EmailValidatorSettingSendgrid.saveSettings'
import settingExists from '@salesforce/apex/EmailValidatorSettingApp.settingExists'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EmailValidatorSettingSendgrid extends LightningElement {
    
    error;
    password;

    apikeyIsSet = false;

    connectedCallback() {
        this.checkSettings();
    }

    checkSettings() {
        console.log('Checking which settings are available:');
        settingExists({settingName: 'Sendgrid_API_Key'})
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