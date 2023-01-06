import { LightningElement, wire } from 'lwc';
import getSettings from '@salesforce/apex/EmailValidatorSettingAbstract.getSettings'
import saveSettings from '@salesforce/apex/EmailValidatorSettingAbstract.saveSettings'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EmailValidatorSettingAbstract extends LightningElement {
    
    error;
    val;
    password;

    @wire(getSettings)
    wiredSettings({ error, data }) {
        if (data) {
            if(data['Abstract_Quality_Score_Threshold']!=''){
                this.val = +data['Abstract_Quality_Score_Threshold'];
            } else {
                this.val = 0.5
            }
            this.error = undefined;
        } else if (error) {
            this.val = 0.5
            this.error = error;
        }
    }

    handleSave(){
        saveSettings({ threshold: this.val, password: this.password})
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