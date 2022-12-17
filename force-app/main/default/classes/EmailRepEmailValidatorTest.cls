/**
 * EmailRepEmailValidatorTest
 * 
 * @description Test class validating EmailRep.io validation service
 *
 * @group EmailRep
 */
@isTest
private with sharing class EmailRepEmailValidatorTest {
    @isTest
    static List<ProspectDto> getProspectDTOs(){
        List<ProspectDto> prospects = new List<ProspectDto>();
        ProspectDto prospect = new ProspectDto();
        prospect.email = 'bill@microsoft.com';
        prospect.service = 'EmailRep';
        prospect.businessUnitId = 'fakeBusinessUnit';
        prospects.add(prospect);
        System.assertEquals('EmailRep', prospect.service,'Expecting EmailRep');
        return prospects;
    }

    @isTest
    static void testEmailRepApiSuccessHighReputation(){
        //Injection of Custom Metadata Type EmailRep_User_Agent
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'EmailRep_API_Key' => new Email_Validator_Setting__mdt(developerName = 'EmailRep_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new Email_Validator_Setting__mdt(developerName = 'Pardot_Named_Credential', value__c = 'Pardot')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new EmailRepApiMock('high'));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(false, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = false');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c FROM EmailValidatorLog__c];
        System.assertEquals('Success', logs[0].Status__c,'Expecting success and not '+logs[0].Status__c);
    }

    @isTest
    static void testEmailRepApiSuccessLowReputation(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'EmailRep_API_Key' => new Email_Validator_Setting__mdt(developerName = 'EmailRep_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new Email_Validator_Setting__mdt(developerName = 'Pardot_Named_Credential', value__c = 'Pardot')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new EmailRepApiMock('low'));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(true, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = true');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c FROM EmailValidatorLog__c];
        System.assertEquals('Success', logs[0].Status__c,'Expecting success and not '+logs[0].Status__c);
    } 

    @isTest
    static void testEmailRepApiServiceSettingException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>();
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new EmailRepApiMock(200));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(null, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = null');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Error', logs[0].Status__c,'Expecting success and not '+logs[0].Status__c);
        System.assertEquals('MissingSettingException', logs[0].Message__c,'Expecting MissingSettingException and not '+logs[0].Message__c);
    }

    @isTest
    static void testEmailRepApiPardotSettingException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'EmailRep_API_Key' => new Email_Validator_Setting__mdt(developerName = 'EmailRep_API_Key', value__c = 'QWERTZUIOP')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new EmailRepApiMock(200));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(false, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = false');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Success', logs[0].Status__c,'Expecting success and not '+logs[0].Status__c);
        System.assertEquals('Error', logs[1].Status__c,'Expecting success and not '+logs[0].Status__c);
        System.assertEquals('MissingSettingException', logs[1].Message__c,'Expecting MissingSettingException and not '+logs[0].Message__c);
    }
    
    @isTest
    static void testEmailRepApiExternalServiceException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'EmailRep_API_Key' => new Email_Validator_Setting__mdt(developerName = 'EmailRep_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new Email_Validator_Setting__mdt(developerName = 'Pardot_Named_Credential', value__c = 'Pardot')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new EmailRepApiMock(301));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(null, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = null');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Error', logs[0].Status__c,'Expecting success and not '+logs[0].Status__c);
        System.assertEquals('ExternalServiceException', logs[0].Message__c,'Expecting ExternalServiceException and not '+logs[0].Message__c);
    }

    @isTest
    static void testEmailRepApiJsonException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'EmailRep_API_Key' => new Email_Validator_Setting__mdt(developerName = 'EmailRep_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new Email_Validator_Setting__mdt(developerName = 'Pardot_Named_Credential', value__c = 'Pardot')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new EmailRepApiMock(true));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(null, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = null');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Error', logs[0].Status__c,'Expecting success and not '+logs[0].Status__c);
        System.assertEquals('JSONException', logs[0].Message__c,'Expecting JSONException and not '+logs[0].Message__c);
    }
}