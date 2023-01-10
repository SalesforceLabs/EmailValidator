/**
 * EmailValidatorSettingSendgridTest
 * @description Test class validating EmailValidatorSettingSendgrid validation service
 * @group Sendgrid
 */
@isTest
private with sharing class EmailValidatorSettingSendgridTest {

    @isTest
    static void testSaveSettingsInsert(){
        Test.startTest();        
        System.assertEquals(null, EmailValidatorSetting__c.getValues(EmailValidatorSettingSendgrid.APIKEY_SETTING)?.Value__c,'Expecting non existing custom setting');
        EmailValidatorSettingSendgrid.saveSettings('***');
        Test.stopTest();
        System.assertEquals('***', EmailValidatorSetting__c.getValues(EmailValidatorSettingSendgrid.APIKEY_SETTING)?.Value__c,'Expecting existing custom setting');
    }

    @isTest
    static void testSaveSettingsUpdate(){
        insert new EmailValidatorSetting__c(
            Name = EmailValidatorSettingSendgrid.APIKEY_SETTING,
            Value__c = '***'
        );
        Test.startTest();
        System.assertEquals('***', EmailValidatorSetting__c.getValues(EmailValidatorSettingSendgrid.APIKEY_SETTING)?.Value__c,'Expecting existing custom setting');
        EmailValidatorSettingSendgrid.saveSettings('*******');
        Test.stopTest();
        System.assertEquals('*******', EmailValidatorSetting__c.getValues(EmailValidatorSettingSendgrid.APIKEY_SETTING)?.Value__c,'Expecting existing custom setting');
    }

}