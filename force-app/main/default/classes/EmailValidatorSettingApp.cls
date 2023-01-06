public with sharing class EmailValidatorSettingApp {

   
    @AuraEnabled(cacheable=false)
    public static Boolean settingExists(String settingName){
            String evs = SettingService.getSettingValue(settingName);
            return (evs != null) && evs.length() > 0;
    }
}