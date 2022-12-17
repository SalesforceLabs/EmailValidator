/**
 * SendgridEmailValidatorTest
 * 
 * @description Main test class validating all implemented validation services
 *
 * @group Sendgrid
 */
@isTest
private with sharing class SendgridEmailValidatorTest {

    @isTest
    static List<ProspectDto> getProspectDTOs(){
        List<ProspectDto> prospects = new List<ProspectDto>();
        ProspectDto prospect = new ProspectDto();
        prospect.email = 'bill@microsoft.com';
        prospect.service = 'Sendgrid';
        prospect.businessUnitId = 'fakeBusinessUnit';
        prospects.add(prospect);
        System.assertEquals('Sendgrid', prospect.service,'Expecting Sendgrid');
        return prospects;
    }

    @isTest
    static void testSendgridApiSuccessValid(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'Sendgrid_API_Key' => new Email_Validator_Setting__mdt(developerName = 'Sendgrid_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new Email_Validator_Setting__mdt(developerName = 'Pardot_Named_Credential', value__c = 'Pardot')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new SendgridApiMock('Valid'));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(false, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = false');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c FROM EmailValidatorLog__c];
        System.assertEquals('Success', logs[0].Status__c,'Expecting Success and not '+logs[0].Status__c);
    } 

    @isTest
    static void testSendgridApiSuccessRisky(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'Sendgrid_API_Key' => new Email_Validator_Setting__mdt(developerName = 'Sendgrid_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new Email_Validator_Setting__mdt(developerName = 'Pardot_Named_Credential', value__c = 'Pardot')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new SendgridApiMock('Risky'));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(true, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = true');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c FROM EmailValidatorLog__c];
        System.assertEquals('Success', logs[0].Status__c,'Expecting Success and not '+logs[0].Status__c);
    } 

    @isTest
    static void testSendgridApiServiceSettingException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>();
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new SendgridApiMock(200));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(null, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = null');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Error', logs[0].Status__c,'Expecting success and not '+logs[0].Status__c);
        System.assertEquals('MissingSettingException', logs[0].Message__c,'Expecting MissingSettingException and not '+logs[0].Message__c);
    }

    @isTest
    static void testSendgridApiPardotSettingException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'Sendgrid_API_Key' => new Email_Validator_Setting__mdt(developerName = 'Sendgrid_API_Key', value__c = 'QWERTZUIOP')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new SendgridApiMock(200));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(false, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = false');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Success', logs[0].Status__c,'Expecting Success and not '+logs[0].Status__c);
        System.assertEquals('Error', logs[1].Status__c,'Expecting Error and not '+logs[1].Status__c);
        System.assertEquals('MissingSettingException', logs[1].Message__c,'Expecting MissingSettingException and not '+logs[0].Message__c);
    }
    
    @isTest
    static void testSendgridApiExternalServiceException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'Sendgrid_API_Key' => new Email_Validator_Setting__mdt(developerName = 'Sendgrid_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new Email_Validator_Setting__mdt(developerName = 'Pardot_Named_Credential', value__c = 'Pardot')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new SendgridApiMock(301));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(null, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = null');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Error', logs[0].Status__c,'Expecting success and not '+logs[0].Status__c);
        System.assertEquals('ExternalServiceException', logs[0].Message__c,'Expecting ExternalServiceException and not '+logs[0].Message__c);
    }

    @isTest
    static void testSendgridApiPardotException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'Sendgrid_API_Key' => new Email_Validator_Setting__mdt(developerName = 'Sendgrid_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new Email_Validator_Setting__mdt(developerName = 'Pardot_Named_Credential', value__c = 'Pardot')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new SendgridApiMock(200,300));
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
    static void testSendgridApiJsonException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'Sendgrid_API_Key' => new Email_Validator_Setting__mdt(developerName = 'Sendgrid_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new Email_Validator_Setting__mdt(developerName = 'Pardot_Named_Credential', value__c = 'Pardot')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new SendgridApiMock(true));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(null, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = null');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Error', logs[0].Status__c,'Expecting success and not '+logs[0].Status__c);
        System.assertEquals('JSONException', logs[0].Message__c,'Expecting JSONException and not '+logs[0].Message__c);
    }
}