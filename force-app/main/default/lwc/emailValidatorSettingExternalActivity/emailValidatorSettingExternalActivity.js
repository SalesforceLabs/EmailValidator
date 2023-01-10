import { LightningElement, wire } from 'lwc';
import getSettings from '@salesforce/apex/EmailValidatorSettingExternalActivity.getSettings'
import saveSettings from '@salesforce/apex/EmailValidatorSettingExternalActivity.saveSettings'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EmailValidatorSettingExternalActivity extends LightningElement {
    
    pardot;
    pass;
    warn;
    isPardotSaved=false;
    isPassSaved=false;
    isWarnSaved=false;
    error;

    @wire(getSettings)
    wiredSettings({ error, data }) {
        if (data) {
            if(data['Pardot_Named_Credential']){
                this.pardot = data['Pardot_Named_Credential'];
                this.isPardotSaved=true;
            }
            if(data['External_Activity_Value_Pass']){
                this.pass = data['External_Activity_Value_Pass'];
                this.isPassSaved=true;
            }
            if(data['External_Activity_Value_Warn']){
                this.warn = data['External_Activity_Value_Warn'];
                this.isWarnSaved=true;
            }
            this.error = undefined;
        } else if (error) {
            this.error = error;
        }
    }

    handleSave(){
        if(!this.pardot||!this.pass||!this.warn){
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Required fields are missing.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
            return;
        }
        saveSettings({ pardot: this.pardot, pass: this.pass, warn: this.warn})
        .then(()=>{
            this.isPardotSaved=this.pardot;
            this.isPassSaved=this.pass;
            this.isWarnSaved=this.warn;
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'Configuration saved successfully.',
                variant: 'success',
            });
            this.dispatchEvent(evt);
        })
        .catch((error)=>{
            console.log(error);
        });
    }

    handlePardotChange(event){
        this.pardot=event.detail.value;
    }

    handlePassChange(event){
        this.pass=event.detail.value;
    }

    handleWarnChange(event){
        this.warn=event.detail.value;
    }

}