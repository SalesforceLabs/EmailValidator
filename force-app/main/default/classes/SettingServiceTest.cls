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
        String value = SettingService.getProtectedSettingValue('UNEXISTING_KEY__C');
		Test.stopTest();
        system.assertEquals(NULL, value, 'CMT with the specified key \'UNEXISTING_KEY__C\' already exists.');
    }
}