/**
 * EmailValidatorSettingExternalActivity
 * @description To setup the connector
 * @group Global
 */
public with sharing class EmailValidatorSettingExternalActivity {

    public static final String EXTERNAL_ACTIVITY_VALUE_PASS = 'External_Activity_Value_Pass';
    public static final String EXTERNAL_ACTIVITY_VALUE_WARN = 'External_Activity_Value_Warn';
    public static final String PARDOT_NAMED_CREDENTIAL = 'Pardot_Named_Credential';

    @AuraEnabled(cacheable=true)
    public static Map<String,String> getSettings() {
        List<String> fieldsToInclude = new List<String>{
            EXTERNAL_ACTIVITY_VALUE_PASS
        ,   EXTERNAL_ACTIVITY_VALUE_WARN
        ,   PARDOT_NAMED_CREDENTIAL
        };
        Map<String,String> params = new Map<String,String>();
        for(EmailValidatorSetting__c evs:EmailValidatorSetting__c.getAll().values()){
            if(fieldsToInclude.contains(evs.Name)){
                params.put(evs.Name,evs.Value__c);
            }
        }
        return params;
    }

    @AuraEnabled(cacheable=false)
    public static void saveSettings(String pardot, String pass, String warn){
        String[] fieldsToInsert = new String[]{'cardimir__Name','cardimir__Value__c'};
        Map<String, Schema.SObjectField> settingFields = Schema.SObjectType.cardimir__EmailValidatorSetting__c.fields.getMap();
        Boolean checkFLS = true;
        for(String field : fieldsToInsert) {
            if(settingFields.get(field) != null && !settingFields.get(field).getDescribe().isCreateable()) {
                checkFLS = false;
            }
        }
        List<EmailValidatorSetting__c> settings = new List<EmailValidatorSetting__c>();
        if(pass!=null){
            settings.add(new EmailValidatorSetting__c(
                Name = EXTERNAL_ACTIVITY_VALUE_PASS,
                Value__c = pass
            ));
        }
        if(warn!=null){
            settings.add(new EmailValidatorSetting__c(
                Name = EXTERNAL_ACTIVITY_VALUE_WARN,
                Value__c = warn
            ));
        }
        if(pardot!=null){
            settings.add(new EmailValidatorSetting__c(
                Name = PARDOT_NAMED_CREDENTIAL,
                Value__c = pardot
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