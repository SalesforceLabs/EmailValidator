public with sharing class EmailValidatorSettingAbstract {

    @AuraEnabled(cacheable=true)
    public static Map<String,String> getSettings() {
        List<String> fieldsToInclude = new List<String>{'Abstract_Quality_Score_Threshold'};
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
        List<EmailValidatorSetting__c> settings = new List<EmailValidatorSetting__c>();
        if(threshold!=null){
            settings.add(new EmailValidatorSetting__c(
                Name = 'Abstract_Quality_Score_Threshold',
                Value__c = threshold
            ));
        }
        if(password!=null){
            settings.add(new EmailValidatorSetting__c(
                Name = 'Abstract_API_Key',
                Value__c = password
            ));
        }
        upsert settings Name;
    }

}