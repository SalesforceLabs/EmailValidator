/**
 * AbstractImpl 
 * @description https://www.abstractapi.com/api/email-verification-validation-api
 * @group AbstractApi
 */
public with sharing class AbstractImpl implements EmailValidatorService {
    

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
            AbstractApiResponse abstractResponse = (AbstractApiResponse) JSON.deserialize(response.getBody(),AbstractApiResponse.class);
            prospect.isPotentialSpam = abstractResponse.quality_score < 0.5;
            Logger.log(prospect.businessUnitId, prospect.service, prospect.email, 'Success', 'Check Email - GET Request', response.getBody());
        } catch (System.JSONException e) {
            Logger.log(prospect.businessUnitId, prospect.service, prospect.email, 'Error', 'JSONException', response.getBody());
        } catch (SettingService.MissingSettingException e) {
            Logger.log(prospect.businessUnitId, prospect.service, prospect.email, 'Error', 'MissingSettingException', e.getMessage()+' is missing from Email_Validator_Setting__mdt');
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
            Logger.log(prospect.businessUnitId, 'Pardot', prospect.email, 'Error', 'MissingSettingException', e.getMessage()+' is missing from Email_Validator_Setting__mdt');
        } catch (EmailValidator.ExternalServiceException e) {
            Logger.log(prospect.businessUnitId, 'Pardot', prospect.email, 'Error', 'ExternalServiceException', 'Status Code:\n'+response.getStatusCode()+'\nBody:\n'+response.getBody());
        } catch (Exception e) {
            Logger.log(prospect.businessUnitId, 'Pardot', prospect.email, 'Error', 'Exception', e.getMessage());
        }
    }
    
    private HttpRequest getExternalActionRequest(ProspectDto prospect){
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:cardimir__Abstract/?api_key='+this.getAPIKey()+'&email='+prospect.email);
        request.setMethod('GET');
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
        String apiKey = SettingService.getSettingValue('Abstract_API_Key');
        if(apiKey==null){
            throw new SettingService.MissingSettingException('Abstract_API_Key');
        }
        return apiKey;
    }

    private String getPardotNamedCredential(){
        String pardotNamedCredential = SettingService.getSettingValue('Pardot_Named_Credential');
        if(pardotNamedCredential==null){
            throw new SettingService.MissingSettingException('Pardot_Named_Credential');
        }
        return pardotNamedCredential;
    }

    private String buildRequestBody(ProspectDto prospect){
        ExternalActivity ea = new ExternalActivity();
        ea.extension = 'Email_Validator';
        ea.type = 'Email_Approved_Abstract';
        String pass = SettingService.getSettingValue('External_Activity_Value_Pass');
        String warn = SettingService.getSettingValue('External_Activity_Value_Warn');
        ea.value = prospect.isPotentialSpam ? warn : pass;
        ea.email = prospect.email;
		return JSON.serialize(ea);
    }
    
    @SuppressWarnings('PMD.VariableNamingConventions,PMD.TooManyFields')
    public class AbstractApiResponse {
        public String email;
        public String autocorrect;
        public String deliverability;
        public Double quality_score;
    }
}