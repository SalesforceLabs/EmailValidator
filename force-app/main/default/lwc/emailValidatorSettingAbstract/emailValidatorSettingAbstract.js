import { LightningElement, wire, track } from 'lwc';
import getSettings from '@salesforce/apex/EmailValidatorSettingAbstract.getSettings'
import saveSettings from '@salesforce/apex/EmailValidatorSettingAbstract.saveSettings'
import settingExists from '@salesforce/apex/EmailValidatorSettingApp.settingExists'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EmailValidatorSettingAbstract extends LightningElement {
    
    error;
    @track val = 50;
    password;

    apikeyIsSet = false;
    thresholdIsSet = false;


    connectedCallback() {
        this.checkSettings();
    }

    checkSettings() {
        console.log('Checking which settings are available:');
        settingExists({settingName: 'Abstract_API_Key'})
        .then((result)=> {
            this.apikeyIsSet = result;
        })
        .catch((error)=> {
            console.log('ERROR WITH API KEY RETRIEVAL');
            console.error(error);
            this.apikeyIsSet = false;
        });

        settingExists({settingName: 'Abstract_Quality_Score_Threshold'})
        .then((result)=> {
            this.thresholdIsSet = result;
        })
        .catch((error)=> {
            console.log('ERROR WITH QUALITY SCORE THRESHOLD RETRIEVAL');
            console.error(error);
            this.thresholdIsSet = false;
        });
    }

    @wire(getSettings)
    wiredSettings({ error, data }) {
        if (data) {
            if(data['Abstract_Quality_Score_Threshold']!=''){
                this.val = +data['Abstract_Quality_Score_Threshold']*100;
            } else {
                this.val = 50;
            }
            this.error = undefined;
        } else if (error) {
            this.val = 50;
            this.error = error;
        }
    }

    handleSave(){
        saveSettings({ threshold: this.val/100, password: this.password})
        .then((result)=>{
            this.password=null;
            this.template.querySelectorAll('lightning-input').forEach(element => {
                element.value = null;
            });
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'Abstract configuration saved successfully.',
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
        saveSettings({threshold: 0.5,password: ''})
        .then((result)=>{
            this.password=null;
            this.template.querySelectorAll('lightning-input').forEach(element => {
                element.value = null;
            });
            const evt = new ShowToastEvent({
                title: 'Cleared',
                message: 'Abstract API Key has been deleted and Threshold reset to default.',
                variant: 'info',
            });
            this.dispatchEvent(evt);
            this.val = 50;
            this.checkSettings(); 
        })
        .catch((error)=>{
            console.log(error);
        });
    }

    handlePasswordChange(event){
        this.password=event.detail.value;
    }

    handleSliderChange(event){
        this.val=event.detail.value;
    }

}