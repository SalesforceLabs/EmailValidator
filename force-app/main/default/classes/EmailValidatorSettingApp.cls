public with sharing class EmailValidatorSettingApp {
    
    @AuraEnabled(cacheable=false)
    public static Boolean settingExists(String settingName){
        try {
            EmailValidatorSetting__c evs = EmailValidatorSetting__c.getValues(settingName);
            return evs != null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}