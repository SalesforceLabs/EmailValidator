public with sharing class EmailValidatorSettingZerobounce {

    @AuraEnabled(cacheable=false)
    public static void saveSettings(String password){
        List<EmailValidatorSetting__c> settings = new List<EmailValidatorSetting__c>();
        if(password!=null){
            settings.add(new EmailValidatorSetting__c(
                Name = 'Zerobounce_API_Key',
                Value__c = password
            ));
        }
        upsert settings Name;
    }

}