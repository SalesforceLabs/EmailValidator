/**
 * AbstractEmailValidatorTest
 * 
 * @description Test class validating AbstractApi validation service
 *
 * @group AbstractApi
 */
@isTest
private with sharing class AbstractEmailValidatorTest {
    @isTest
    static List<ProspectDto> getProspectDTOs(){
        List<ProspectDto> prospects = new List<ProspectDto>();
        ProspectDto prospect = new ProspectDto();
        prospect.email = 'bill@microsoft.com';
        prospect.service = 'Abstract';
        prospect.businessUnitId = 'fakeBusinessUnit';
        prospects.add(prospect);
        System.assertEquals('Abstract', prospect.service,'Expecting Abstract');
        return prospects;
    }

    @isTest
    static void testAbstractApiSuccessHighQualityScore(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'Abstract_API_Key' => new Email_Validator_Setting__mdt(developerName = 'Abstract_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new Email_Validator_Setting__mdt(developerName = 'Pardot_Named_Credential', value__c = 'Pardot'),
            'Abstract_Quality_Score_Threshold' => new Email_Validator_Setting__mdt(developerName = 'Abstract_Quality_Score_Threshold', value__c = '0.5')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new AbstractApiMock(0.9));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(false, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = false');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c FROM EmailValidatorLog__c];
        System.assertEquals('Success', logs[0].Status__c,'Expecting success and not '+logs[0].Status__c);
    }

    @isTest
    static void testAbstractApiSuccessLowQualityScore(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'Abstract_API_Key' => new Email_Validator_Setting__mdt(developerName = 'Abstract_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new Email_Validator_Setting__mdt(developerName = 'Pardot_Named_Credential', value__c = 'Pardot'),
            'Abstract_Quality_Score_Threshold' => new Email_Validator_Setting__mdt(developerName = 'Abstract_Quality_Score_Threshold', value__c = '0.5')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new AbstractApiMock(0.1));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(true, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = true');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c FROM EmailValidatorLog__c];
        System.assertEquals('Success', logs[0].Status__c,'Expecting success and not '+logs[0].Status__c);
    } 

    @isTest
    static void testAbstractApiServiceSettingException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>();
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new AbstractApiMock(200));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(null, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = null');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Error', logs[0].Status__c,'Expecting success and not '+logs[0].Status__c);
        System.assertEquals('MissingSettingException', logs[0].Message__c,'Expecting MissingSettingException and not '+logs[0].Message__c);
    }

    @isTest
    static void testAbstractApiPardotSettingException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'Abstract_API_Key' => new Email_Validator_Setting__mdt(developerName = 'Abstract_API_Key', value__c = 'QWERTZUIOP'),
            'Abstract_Quality_Score_Threshold' => new Email_Validator_Setting__mdt(developerName = 'Abstract_Quality_Score_Threshold', value__c = '0.5')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new AbstractApiMock(200));
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
    static void testAbstractApiExternalServiceException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'Abstract_API_Key' => new Email_Validator_Setting__mdt(developerName = 'Abstract_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new Email_Validator_Setting__mdt(developerName = 'Pardot_Named_Credential', value__c = 'Pardot'),
            'Abstract_Quality_Score_Threshold' => new Email_Validator_Setting__mdt(developerName = 'Abstract_Quality_Score_Threshold', value__c = '0.5')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new AbstractApiMock(301));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(null, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = null');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Error', logs[0].Status__c,'Expecting success and not '+logs[0].Status__c);
        System.assertEquals('ExternalServiceException', logs[0].Message__c,'Expecting ExternalServiceException and not '+logs[0].Message__c);
    }

    @isTest
    static void testAbstractApiJsonException(){
        //Injection of Custom Metadata Type
        SettingService.settings = new Map<String, Email_Validator_Setting__mdt>{
            'Abstract_API_Key' => new Email_Validator_Setting__mdt(developerName = 'Abstract_API_Key', value__c = 'QWERTZUIOP'),
            'Pardot_Named_Credential' => new Email_Validator_Setting__mdt(developerName = 'Pardot_Named_Credential', value__c = 'Pardot'),
            'Abstract_Quality_Score_Threshold' => new Email_Validator_Setting__mdt(developerName = 'Abstract_Quality_Score_Threshold', value__c = '0.5')
        };
        Test.startTest();
        //Set mock class callout
        Test.setMock(HttpCalloutMock.class, new AbstractApiMock(true));
        List<ProspectDto> prospects = getProspectDTOs();
        EmailValidatorAction.getEmailReputation(prospects);
        Test.stopTest();
        System.assertEquals(null, prospects[0].isPotentialSpam, 'Expected isPotentialSpam = null');
        List<EmailValidatorLog__c> logs = [SELECT Id, Status__c, Message__c FROM EmailValidatorLog__c];
        System.assertEquals('Error', logs[0].Status__c,'Expecting success and not '+logs[0].Status__c);
        System.assertEquals('JSONException', logs[0].Message__c,'Expecting JSONException and not '+logs[0].Message__c);
    }
}