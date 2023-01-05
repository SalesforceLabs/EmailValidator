/**
* SendgridImpl
* @description Implementation class for the Sendgrid service
* @group Sendgrid
*/
public with sharing class SendgridImpl implements EmailValidatorService {
    
    /**
    * checkEmail
    * @description Callout to Sendgrid REST API to check Prospect's email
    * @param prospect (ProspectDto): Prospect information received by Pardot
    *
    *
    * @throws EmailValidator.ExternalServiceException Exception when the callout to the external web service is not successful
    * @throws System.JSONException Exception when the JSON payload received from the external web service cannot be parsed
    * @throws SettingService.MissingSettingException Exception when some configuration is missing in Salesforce (API keys, Named Credentials, etc.)
    */
    public void checkEmail(ProspectDto prospect){        
        HttpResponse response;
        try {
            Http http = new Http();
            response = http.send(this.getExternalActionRequest(prospect));
            if(response.getStatusCode() != 200) {
                throw new EmailValidator.ExternalServiceException(prospect.service);
            }
            SendgridApiResponse sendgridResponse = (SendgridApiResponse) JSON.deserialize(response.getBody(),SendgridApiResponse.class);
            prospect.isPotentialSpam = sendgridResponse.result.verdict != 'Valid';
            Logger.log(prospect.businessUnitId, prospect.service, prospect.email, 'Success', 'GET Request', response.getBody());
        } catch (System.JSONException e) {
            Logger.log(prospect.businessUnitId, prospect.service, prospect.email, 'Error', 'JSONException', response.getBody());
        } catch (SettingService.MissingSettingException e) {
            Logger.log(prospect.businessUnitId, prospect.service, prospect.email, 'Error', 'MissingSettingException', e.getMessage()+' is missing from EmailValidatorSetting__c');
        } catch (EmailValidator.ExternalServiceException e) {
            Logger.log(prospect.businessUnitId, prospect.service, prospect.email, 'Error', 'ExternalServiceException', response.getBody());
        } catch (Exception e) {
            Logger.log(prospect.businessUnitId, prospect.service, prospect.email, 'Error', 'Exception', response.getBody());
        }
    }

    /**
    * logExternalActivity 
    * @description Logs an External Activity on the provided Prospect
    * @param prospect (ProspectDto): Prospect information received by Pardot
    *
    *
    * @throws Class name here Write the class description
    */
    public void logExternalActivity(ProspectDto prospect) {
        HttpResponse response;
        try {
            HttpRequest request = this.getPardotActivityRequest(prospect);
            Http http = new Http();
            response = http.send(request);
            
            if(response.getStatusCode() != 202) {
                throw new EmailValidator.ExternalServiceException('Pardot');
            }
            Logger.log(prospect.businessUnitId, 'Pardot', prospect.email, 'Success', 'POST Request', response.getBody());
        } catch (SettingService.MissingSettingException e) {
            Logger.log(prospect.businessUnitId, 'Pardot', prospect.email, 'Error', 'MissingSettingException', e.getMessage()+' is missing from EmailValidatorSetting__c');
        } catch (EmailValidator.ExternalServiceException e) {
            Logger.log(prospect.businessUnitId, 'Pardot', prospect.email, 'Error', 'ExternalServiceException', 'Status Code:\n'+response.getStatusCode()+'\nBody:\n'+response.getBody());
        } catch (Exception e) {
            Logger.log(prospect.businessUnitId, 'Pardot', prospect.email, 'Error', 'Exception', e.getMessage());
        }
    }

    @SuppressWarnings('PMD.ApexSuggestUsingNamedCred')
    private HttpRequest getExternalActionRequest(ProspectDto prospect){
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:cardimir__Sendgrid');
        request.setMethod('POST');
        request.setHeader('Authorization','Bearer '+this.getAPIKey());
        request.setHeader('Content-Type','application/json');
        request.setBody('{email:\''+prospect.email+'\'}');
        return request;
    }
    
    private HttpRequest getPardotActivityRequest(ProspectDto prospect){
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type','application/json');
        request.setHeader('Pardot-Business-Unit-Id', prospect.businessUnitId);
        request.setEndpoint('callout:'+this.getPardotNamedCredential()+'/api/v5/external-activities');
        request.setMethod('POST');
        request.setBody(this.buildRequestBody(prospect));
		return request;
    }
    
    private String getAPIKey(){
        String apiKey = SettingService.getProtectedSettingValue('Sendgrid_API_Key');
        if(apiKey==null){
            throw new SettingService.MissingSettingException('Sendgrid_API_Key');
        }
        return apiKey;
    }
    
    private String getPardotNamedCredential(){
        String pardotNamedCredential = SettingService.getPublicSettingValue('Pardot_Named_Credential');
        if(pardotNamedCredential==null){
            throw new SettingService.MissingSettingException('Pardot_Named_Credential');
        }
        return pardotNamedCredential;
    }

    /**
    * buildRequestBody Description
    *
    * @param prospect (ProspectDto): Write the parameter description
    *
    * @return String: Write the return description
    *
    * @throws Class name here Write the class description
    */
    private String buildRequestBody(ProspectDto prospect){
        ExternalActivity ea = new ExternalActivity();
        ea.extension = 'Email_Validator';
        ea.type = 'Email_Approved_Sendgrid';
        String pass = SettingService.getPublicSettingValue('External_Activity_Value_Pass');
        String warn = SettingService.getPublicSettingValue('External_Activity_Value_Warn');
        ea.value = prospect.isPotentialSpam ? warn : pass;
        ea.email = prospect.email;
        return JSON.serialize(ea);
    }
    
    /**
    * EmailRepApiResponse
    * @description Represents the JSON response received by Sendgrid service
    */
    @testVisible
    private class SendgridApiResponse {
        public Result result;
    }

    /**
    * Details
    * @description Mapping of the Details object returned within the JSON response of the Sendgrid service
    */
    @testVisible
    private class Result {
        public String email; 
        public String verdict;
        public Double score;
    }
}