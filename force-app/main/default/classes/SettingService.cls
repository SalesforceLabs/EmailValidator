/**
 * SettingService 
 * 
 * @description Utility class to interact with the CMT Settings
 * 
 * @group EmailValidator
 */
public with sharing class SettingService {
 
    @testVisible
    private static Map<String, EmailValidatorSetting__c> settings;

    public static String getSettingValue(String key){
        if(settings==null){
            settings = EmailValidatorSetting__c.getAll();
        }
        return settings.get(key)?.value__c;
    }

    public static List<String> getAllAPIKeySettingNames(){
        List<String> settingNames = new List<String>();
        for(Email_Validator_Service__mdt evs:Email_Validator_Service__mdt.getAll().values()){
            settingNames.add(evs.APIKey_SettingName__c);
        }
        return settingNames;
    }

    public class MissingSettingException extends Exception {}
}