import { LightningElement } from 'lwc';
import getSettings from '@salesforce/apex/EmailValidatorSettingApp.getSettings'
import saveSettings from '@salesforce/apex/EmailValidatorSettingApp.saveSettings'

export default class EmailValidatorSettingAbstract extends LightningElement {
    
    val = 0.5;
    password;

    handleSave(){
        console.log(this.password,this.val);
    }

    handlePasswordChange(event){
        this.password=event.detail.value;
    }

    handleSliderChange(event){
        this.val=event.detail.value;
    }

}