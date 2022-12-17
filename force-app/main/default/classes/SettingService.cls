/**
 * SettingService 
 * 
 * @description Utility class to interact with the CMT Settings
 * 
 * @group EmailValidator
 */
public with sharing class SettingService {
 
    @testVisible
    private static Map<String, Email_Validator_Setting__mdt> settings;
 
    public static String getSettingValue(String key){
        if(settings==null){
            settings = Email_Validator_Setting__mdt.getAll();
        }
        return settings.get(key)?.value__c;
    }

    public class MissingSettingException extends Exception {}
}