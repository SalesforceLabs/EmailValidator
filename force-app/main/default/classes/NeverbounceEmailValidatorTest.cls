/**
 * NeverbounceEmailValidatorTest
 * 
 * @description Main test class validating all implemented validation services
 *
 * @group Neverbounce
 */
@isTest
private with sharing class NeverbounceEmailValidatorTest {

    @isTest
    static List<ProspectDto> getProspectDTOs(){
        List<ProspectDto> prospects = new List<ProspectDto>();
        ProspectDto prospect = new ProspectDto();
        prospect.email = 'bill@microsoft.com';
        prospect.service = 'Neverbounce';
        prospect.businessUnitId = 'fakeBusinessUnit';
        prospects.add(prospect);
        System.assertEquals('Neverbounce', prospect.service,'Expecting Neverbounce');
        return prospects;
    }

    @isTest
    static void testNeverbounceApiSuccessValid(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, EmailValidatorSetting__c>{
            'Neverbounce_API_Key' => new EmailValidatorSetting__c(Name = 'Neverbounce_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new EmailValidatorSetting__c(Name = 'Pardot_Named_Credential', value__c = 'Pardot')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new NeverbounceApiMock('Valid'));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(false, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = false');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c FROM EmailValidatorLog__c];
        System.assertEquals('Success', logs[0].Status__c,'Expecting Success and not '+logs[0].Status__c);
    } 

    @isTest
    static void testNeverbounceApiSuccessRisky(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, EmailValidatorSetting__c>{
            'Neverbounce_API_Key' => new EmailValidatorSetting__c(Name = 'Neverbounce_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new EmailValidatorSetting__c(Name = 'Pardot_Named_Credential', value__c = 'Pardot')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new NeverbounceApiMock('Risky'));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(true, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = true');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c FROM EmailValidatorLog__c];
        System.assertEquals('Success', logs[0].Status__c,'Expecting Success and not '+logs[0].Status__c);
    } 

    @isTest
    static void testNeverbounceApiServiceSettingException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, EmailValidatorSetting__c>();
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new NeverbounceApiMock(200));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(null, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = null');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Error', logs[0].Status__c,'Expecting Error and not '+logs[0].Status__c);
        System.assertEquals('MissingSettingException', logs[0].Message__c,'Expecting MissingSettingException and not '+logs[0].Message__c);
    }

    @isTest
    static void testNeverbounceApiPardotSettingException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, EmailValidatorSetting__c>{
            'Neverbounce_API_Key' => new EmailValidatorSetting__c(Name = 'Neverbounce_API_Key', value__c = 'QWERTZUIOP')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new NeverbounceApiMock(200));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(false, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = false');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Success', logs[0].Status__c,'Expecting Success and not '+logs[0].Status__c);
        System.assertEquals('Error', logs[1].Status__c,'Expecting Error and not '+logs[1].Status__c);
        System.assertEquals('MissingSettingException', logs[1].Message__c,'Expecting MissingSettingException and not '+logs[1].Message__c);
    }
    
    @isTest
    static void testNeverbounceApiExternalServiceException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, EmailValidatorSetting__c>{
            'Neverbounce_API_Key' => new EmailValidatorSetting__c(Name = 'Neverbounce_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new EmailValidatorSetting__c(Name = 'Pardot_Named_Credential', value__c = 'Pardot')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new NeverbounceApiMock(301));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(null, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = null');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Error', logs[0].Status__c,'Expecting Error and not '+logs[0].Status__c);
        System.assertEquals('ExternalServiceException', logs[0].Message__c,'Expecting ExternalServiceException and not '+logs[0].Message__c);
    }

    @isTest
    static void testNeverbounceApiPardotException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, EmailValidatorSetting__c>{
            'Neverbounce_API_Key' => new EmailValidatorSetting__c(Name = 'Neverbounce_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new EmailValidatorSetting__c(Name = 'Pardot_Named_Credential', value__c = 'Pardot')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new NeverbounceApiMock(200,300));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(false, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = false');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Success', logs[0].Status__c,'Expecting Success and not '+logs[0].Status__c);
        System.assertEquals('Error', logs[1].Status__c,'Expecting Error and not '+logs[1].Status__c);
        System.assertEquals('ExternalServiceException', logs[1].Message__c,'Expecting ExternalServiceException and not '+logs[0].Message__c);
    }

    @isTest
    static void testNeverbounceApiJsonException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, EmailValidatorSetting__c>{
            'Neverbounce_API_Key' => new EmailValidatorSetting__c(Name = 'Neverbounce_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new EmailValidatorSetting__c(Name = 'Pardot_Named_Credential', value__c = 'Pardot')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new NeverbounceApiMock(true));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(null, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = null');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Error', logs[0].Status__c,'Expecting Error and not '+logs[0].Status__c);
        System.assertEquals('JSONException', logs[0].Message__c,'Expecting JSONException and not '+logs[0].Message__c);
    }
}