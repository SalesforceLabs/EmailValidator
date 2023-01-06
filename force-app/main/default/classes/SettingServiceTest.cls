/**
 * SettingServiceTest
 * 
 * @description Simple test class for SettingService
 *
 * @group Sendgrid
 */
@isTest
private with sharing class SettingServiceTest {
    @isTest
    static void testEmailRepApiSuccess(){
        Test.startTest();
        String value = SettingService.getSettingValue('UNEXISTING_KEY__C');
		Test.stopTest();
        system.assertEquals(NULL, value, 'CMT with the specified key \'UNEXISTING_KEY__C\' already exists.');
    }

    @IsTest
    static void testGetAllAPIKeys(){
        Test.startTest();
        List<String> apiKeyFields = SettingService.getAllAPIKeySettingNames();
        Test.stopTest();
        System.assertEquals(true, apiKeyFields.size()>0, 'Expecting at least 1 API Key field');
    }

    @IsTest
    static void testInvalidSettingKey(){
        Test.startTest();
        Boolean shouldBeFalse = EmailValidatorSettingApp.settingExists('MISSING');
        Test.stopTest();
        System.assertEquals(false, shouldBeFalse, 'Expecting false for a missing setting...');
    }
}