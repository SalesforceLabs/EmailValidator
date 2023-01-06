/**
 * EmailValidatorSettingEmailRepTest
 * @description Test class validating EmailValidatorSettingEmailRep validation service
 * @group EmailRep
 */
@isTest
private with sharing class EmailValidatorSettingEmailRepTest {

    @isTest
    static void testSaveSettingsInsert(){
        Test.startTest();        
        System.assertEquals(null, EmailValidatorSetting__c.getValues(EmailValidatorSettingEmailRep.APIKEY_SETTING)?.Value__c,'Expecting non existing custom setting');
        EmailValidatorSettingEmailRep.saveSettings('***');
        Test.stopTest();
        System.assertEquals('***', EmailValidatorSetting__c.getValues(EmailValidatorSettingEmailRep.APIKEY_SETTING)?.Value__c,'Expecting existing custom setting');
    }

    @isTest
    static void testSaveSettingsUpdate(){
        insert new EmailValidatorSetting__c(
            Name = EmailValidatorSettingEmailRep.APIKEY_SETTING,
            Value__c = '***'
        );
        Test.startTest();
        System.assertEquals('***', EmailValidatorSetting__c.getValues(EmailValidatorSettingEmailRep.APIKEY_SETTING)?.Value__c,'Expecting existing custom setting');
        EmailValidatorSettingEmailRep.saveSettings('*******');
        Test.stopTest();
        System.assertEquals('*******', EmailValidatorSetting__c.getValues(EmailValidatorSettingEmailRep.APIKEY_SETTING)?.Value__c,'Expecting existing custom setting');
    }

}