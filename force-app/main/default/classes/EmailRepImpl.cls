/**
* EmailRepImpl
* @description Implementation class for the EmailRep.io service
* @group EmailRep
*/
public with sharing class EmailRepImpl implements EmailValidatorService {
    
    /**
    * checkEmail
    * @description Callout to EmailRep.io REST API to check Prospect's email
    * @param prospect (ProspectDto): Prospect information received by Pardot
    */
    public void checkEmail(ProspectDto prospect){        
        HttpResponse response;
        try {
            Http http = new Http();
            response = http.send(this.getExternalActionRequest(prospect));
            if(response.getStatusCode() != 200) {
                throw new EmailValidator.ExternalServiceException(prospect.service);
            }
            EmailRepApiResponse emailrepResponse = (EmailRepApiResponse) JSON.deserialize(response.getBody(),EmailRepApiResponse.class);
            // Business logic to define what could be considered an unwanted Prospect email address (spam, blacklisted, etc.)
            prospect.isPotentialSpam = emailrepResponse.suspicious;
            Logger.log(prospect.businessUnitId, prospect.service, prospect.email, 'Success', 'Check Email - GET Request', response.getBody());
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
    
    private HttpRequest getExternalActionRequest(ProspectDto prospect){
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:cardimir__EmailRepIO/'+prospect.email);
        request.setMethod('GET');
        request.setHeader('Key',this.getAPIKey());
        request.setHeader('User-Agent',this.getUserAgent());
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
        String apiKey = SettingService.getProtectedSettingValue('EmailRep_API_Key');
        if(apiKey==null){
            throw new SettingService.MissingSettingException('EmailRep_API_Key');
        }
        return apiKey;
    }
    
    private String getUserAgent(){
        String userAgent = 'PardotEmailValidator';
        return userAgent;
    }
    
    private String getPardotNamedCredential(){
        String pardotNamedCredential = SettingService.getPublicSettingValue('Pardot_Named_Credential');
        if(pardotNamedCredential==null){
            throw new SettingService.MissingSettingException('Pardot_Named_Credential');
        }
        return pardotNamedCredential;
    }
    
    /**
    * buildRequestBody
    * @description Builds the request body to log the External Activity back in Pardot 
    * @param prospect (ProspectDto): Prospect information received by Pardot
    *
    * @return String: JSON payload
    */
    private String buildRequestBody(ProspectDto prospect){
        ExternalActivity ea = new ExternalActivity();
        ea.extension = 'Email_Validator';
        ea.type = 'Email_Approved_EmailRep_io';
        String pass = SettingService.getPublicSettingValue('External_Activity_Value_Pass');
        String warn = SettingService.getPublicSettingValue('External_Activity_Value_Warn');
        ea.value = prospect.isPotentialSpam ? warn : pass;
        ea.email = prospect.email;
        return JSON.serialize(ea);
    }
    
    /**
    * EmailRepApiResponse
    * @description Represents the JSON response received by EmailRep.io service
    */
    @testVisible
    private class EmailRepApiResponse {
        public String email;
        public String reputation;
        public Boolean suspicious;
        public Integer references;
        public Details details;	
    }
    
    /**
    * Details
    * @description Mapping of the Details object returned within the JSON response of the EmailRep.io service
    */
    @SuppressWarnings('PMD.VariableNamingConventions,PMD.TooManyFields')
    @testVisible
    private class Details {
        public Boolean blacklisted; 
        public Boolean malicious_activity;
        public Boolean malicious_activity_recent;
        public Boolean credentials_leaked;
        public Boolean credentials_leaked_recent;
        public Boolean data_breach;
        public String first_seen;
        public String last_seen;
        public Boolean domain_exists;
        public String domain_reputation;
        public Boolean new_domain;
        public Integer days_since_domain_creation;
        public Boolean suspicious_tld;
        public Boolean spam;
        public Boolean free_provider;
        public Boolean disposable;
        public Boolean deliverable;
        public Boolean accept_all;
        public Boolean valid_mx;
        public Boolean spoofable;
        public Boolean spf_strict;
        public Boolean dmarc_enforced;
        public List<String> profiles;
    }
}