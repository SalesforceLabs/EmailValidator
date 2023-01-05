/**
 * SettingService 
 * 
 * @description Utility class to interact with the CMT Settings
 * 
 * @group EmailValidator
 */
public with sharing class SettingService {
 
    @testVisible
    private static Map<String, EmailValidatorSetting__c> protectedSettings;

    @testVisible
    private static Map<String, EmailValidator_PublicSetting__mdt> publicSettings;

    public static String getProtectedSettingValue(String key){
        if(protectedSettings==null){
            protectedSettings = EmailValidatorSetting__c.getAll();
        }
        return protectedSettings.get(key)?.value__c;
    }

    public static String getPublicSettingValue(String key){
        if(publicSettings==null){
            publicSettings = EmailValidator_PublicSetting__mdt.getAll();
        }
        return publicSettings.get(key)?.value__c;
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