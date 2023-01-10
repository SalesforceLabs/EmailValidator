/**
 * EmailValidatorSettingSendgrid
 * @description To setup the connector
 * @group Sendgrid
 */
public with sharing class EmailValidatorSettingSendgrid {

    public static final String APIKEY_SETTING = 'Sendgrid_API_Key';

    @AuraEnabled(cacheable=false)
    public static void saveSettings(String password){
        String[] fieldsToInsert = new String[]{'cardimir__Name','cardimir__Value__c'};
        Map<String, Schema.SObjectField> settingFields = Schema.SObjectType.cardimir__EmailValidatorSetting__c.fields.getMap();
        Boolean checkFLS = true;
        for(String field : fieldsToInsert) {
            if(settingFields.get(field) != null && !settingFields.get(field).getDescribe().isCreateable()) {
                checkFLS = false;
            }
        }
        List<EmailValidatorSetting__c> settings = new List<EmailValidatorSetting__c>();
        if(password!=null){
            settings.add(new EmailValidatorSetting__c(
                Name = APIKEY_SETTING,
                Value__c = password
            ));
        }
        if(
                Schema.sObjectType.EmailValidatorSetting__c.isAccessible()
            &&  Schema.sObjectType.EmailValidatorSetting__c.isCreateable()
            &&  Schema.sObjectType.EmailValidatorSetting__c.isUpdateable()
            &&  checkFLS
        ){
            upsert settings Name;
        } else {
            throw new NoAccessException();
        }
    }
}