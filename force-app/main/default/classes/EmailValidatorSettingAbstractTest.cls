/**
 * EmailValidatorSettingAbstractTest
 * @description Test class validating EmailValidatorSettingAbstract validation service
 * @group AbstractApi
 */
@isTest
private with sharing class EmailValidatorSettingAbstractTest {

    @isTest
    static void testGetSettingsNoValue(){
        Test.startTest();
        Map<String,String> settingMap = EmailValidatorSettingAbstract.getSettings();
        Test.stopTest();
        System.assertEquals(null, settingMap.get(EmailValidatorSettingAbstract.QUALITYSCORE_SETTING),'Expecting non existing custom setting');
    }

    @isTest
    static void testGetSettingsExistingValue(){
        insert new EmailValidatorSetting__c(
            Name = EmailValidatorSettingAbstract.QUALITYSCORE_SETTING,
            Value__c = '0.50'
        );
        Test.startTest();
        Map<String,String> settingMap = EmailValidatorSettingAbstract.getSettings();
        Test.stopTest();
        System.assertEquals('0.50', settingMap.get(EmailValidatorSettingAbstract.QUALITYSCORE_SETTING),'Expecting existing custom setting');
    }

    @isTest
    static void testSaveSettingsInsert(){
        Test.startTest();
        Map<String,String> settingMap = EmailValidatorSettingAbstract.getSettings();
        System.assertEquals(null, settingMap.get(EmailValidatorSettingAbstract.QUALITYSCORE_SETTING),'Expecting non existing custom setting');
        EmailValidatorSettingAbstract.saveSettings('0.80',null);
        settingMap = EmailValidatorSettingAbstract.getSettings();
        Test.stopTest();
        System.assertEquals('0.80', settingMap.get(EmailValidatorSettingAbstract.QUALITYSCORE_SETTING),'Expecting existing custom setting');
    }

    @isTest
    static void testSaveSettingsUpdate(){
        insert new EmailValidatorSetting__c(
            Name = EmailValidatorSettingAbstract.QUALITYSCORE_SETTING,
            Value__c = '0.50'
        );
        Test.startTest();
        Map<String,String> settingMap = EmailValidatorSettingAbstract.getSettings();
        System.assertEquals('0.50', settingMap.get(EmailValidatorSettingAbstract.QUALITYSCORE_SETTING),'Expecting existing custom setting');
        EmailValidatorSettingAbstract.saveSettings('0.80','*******');
        settingMap = EmailValidatorSettingAbstract.getSettings();
        Test.stopTest();
        System.assertEquals('0.80', settingMap.get(EmailValidatorSettingAbstract.QUALITYSCORE_SETTING),'Expecting existing custom setting');
    }

}