/**
 * EmailValidatorSettingZerobounceTest
 * @description Test class validating EmailValidatorSettingZerobounce validation service
 * @group Zerobounce
 */
@isTest
private with sharing class EmailValidatorSettingZerobounceTest {

    @isTest
    static void testSaveSettingsInsert(){
        Test.startTest();        
        System.assertEquals(null, EmailValidatorSetting__c.getValues(EmailValidatorSettingZerobounce.APIKEY_SETTING)?.Value__c,'Expecting non existing custom setting');
        EmailValidatorSettingZerobounce.saveSettings('***');
        Test.stopTest();
        System.assertEquals('***', EmailValidatorSetting__c.getValues(EmailValidatorSettingZerobounce.APIKEY_SETTING)?.Value__c,'Expecting existing custom setting');
    }

    @isTest
    static void testSaveSettingsUpdate(){
        insert new EmailValidatorSetting__c(
            Name = EmailValidatorSettingZerobounce.APIKEY_SETTING,
            Value__c = '***'
        );
        Test.startTest();
        System.assertEquals('***', EmailValidatorSetting__c.getValues(EmailValidatorSettingZerobounce.APIKEY_SETTING)?.Value__c,'Expecting existing custom setting');
        EmailValidatorSettingZerobounce.saveSettings('*******');
        Test.stopTest();
        System.assertEquals('*******', EmailValidatorSetting__c.getValues(EmailValidatorSettingZerobounce.APIKEY_SETTING)?.Value__c,'Expecting existing custom setting');
    }

}