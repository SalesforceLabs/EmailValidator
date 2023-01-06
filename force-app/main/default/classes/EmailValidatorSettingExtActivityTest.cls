/**
 * EmailValidatorSettingExtActivityTest
 * @description Test class validating EmailValidatorSettingExternalActivity validation service
 * @group Global
 */
@isTest
private with sharing class EmailValidatorSettingExtActivityTest {

    @isTest
    static void testGetSettingsNoValue(){
        Test.startTest();
        Map<String,String> settingMap = EmailValidatorSettingExternalActivity.getSettings();
        Test.stopTest();
        System.assertEquals(null, settingMap.get(EmailValidatorSettingExternalActivity.EXTERNAL_ACTIVITY_VALUE_PASS),'Expecting non existing custom setting');
    }

    @isTest
    static void testGetSettingsExistingValue(){
        insert new EmailValidatorSetting__c(
            Name = EmailValidatorSettingExternalActivity.EXTERNAL_ACTIVITY_VALUE_PASS,
            Value__c = 'Pass'
        );
        Test.startTest();
        Map<String,String> settingMap = EmailValidatorSettingExternalActivity.getSettings();
        Test.stopTest();
        System.assertEquals('Pass', settingMap.get(EmailValidatorSettingExternalActivity.EXTERNAL_ACTIVITY_VALUE_PASS),'Expecting existing custom setting');
    }

    @isTest
    static void testSaveSettingsInsert(){
        Test.startTest();
        Map<String,String> settingMap = EmailValidatorSettingExternalActivity.getSettings();
        System.assertEquals(null, settingMap.get(EmailValidatorSettingExternalActivity.EXTERNAL_ACTIVITY_VALUE_PASS),'Expecting non existing custom setting');
        EmailValidatorSettingExternalActivity.saveSettings('Pass',null,null);
        settingMap = EmailValidatorSettingExternalActivity.getSettings();
        Test.stopTest();
        System.assertEquals('Pass', settingMap.get(EmailValidatorSettingExternalActivity.EXTERNAL_ACTIVITY_VALUE_PASS),'Expecting existing custom setting');
    }

    @isTest
    static void testSaveSettingsUpdate(){
        insert new EmailValidatorSetting__c(
            Name = EmailValidatorSettingExternalActivity.EXTERNAL_ACTIVITY_VALUE_PASS,
            Value__c = 'Pass'
        );
        Test.startTest();
        Map<String,String> settingMap = EmailValidatorSettingExternalActivity.getSettings();
        System.assertEquals('Pass', settingMap.get(EmailValidatorSettingExternalActivity.EXTERNAL_ACTIVITY_VALUE_PASS),'Expecting existing custom setting');
        EmailValidatorSettingExternalActivity.saveSettings('Pardot','Passing','Warn');
        settingMap = EmailValidatorSettingExternalActivity.getSettings();
        Test.stopTest();
        System.assertEquals('Passing', settingMap.get(EmailValidatorSettingExternalActivity.EXTERNAL_ACTIVITY_VALUE_PASS),'Expecting existing custom setting');
    }

}