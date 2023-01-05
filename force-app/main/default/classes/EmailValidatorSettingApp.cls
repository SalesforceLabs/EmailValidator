public with sharing class EmailValidatorSettingApp {
    
    @AuraEnabled
    public static void getSettings(List<String> settingNames) {
        List<String> fieldsToExclude = SettingService.getAllAPIKeySettingNames();
    }

    @AuraEnabled
    public static void saveSettings() {
        List<String> fieldsToExclude = SettingService.getAllAPIKeySettingNames();
    }

    @AuraEnabled
    public static void get(){
        try {
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}