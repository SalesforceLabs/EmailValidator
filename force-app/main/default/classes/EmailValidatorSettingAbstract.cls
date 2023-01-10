/**
 * EmailValidatorSettingAbstract
 * @description To setup the connector
 * @group AbstractApi
 */
public with sharing class EmailValidatorSettingAbstract {

    public static final String APIKEY_SETTING = 'Abstract_API_Key';
    public static final String QUALITYSCORE_SETTING = 'Abstract_Quality_Score_Threshold';

    @AuraEnabled(cacheable=true)
    public static Map<String,String> getSettings() {
        List<String> fieldsToInclude = new List<String>{QUALITYSCORE_SETTING};
        Map<String,String> params = new Map<String,String>();
        for(EmailValidatorSetting__c evs:EmailValidatorSetting__c.getAll().values()){
            if(fieldsToInclude.contains(evs.Name)){
                params.put(evs.Name,evs.Value__c);
            }
        }
        return params;
    }

    @AuraEnabled(cacheable=false)
    public static void saveSettings(String threshold, String password){
        String[] fieldsToInsert = new String[]{'cardimir__Name','cardimir__Value__c'};
        Map<String, Schema.SObjectField> settingFields = Schema.SObjectType.cardimir__EmailValidatorSetting__c.fields.getMap();
        Boolean checkFLS = true;
        for(String field : fieldsToInsert) {
            if(settingFields.get(field) != null && !settingFields.get(field).getDescribe().isCreateable()) {
                checkFLS = false;
            }
        }
        List<EmailValidatorSetting__c> settings = new List<EmailValidatorSetting__c>();
        if(threshold!=null){
            settings.add(new EmailValidatorSetting__c(
                Name = QUALITYSCORE_SETTING,
                Value__c = threshold
            ));
        }
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