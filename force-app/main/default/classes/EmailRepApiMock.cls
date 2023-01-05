/**
 * EmailRepApiMock
 * @description Dynamic Mock class used for Unit Tests
 * @group EmailRep
 * 
 */
@isTest
public with sharing class EmailRepApiMock implements HttpCalloutMock {
    
    public String reputation;
    public Integer statusCode;
    public Boolean hasWrongBody;
    
    public EmailRepApiMock(String reputation) {
        this.reputation = reputation;
        this.statusCode = 200;
        this.hasWrongBody = false;
    }
    
    public EmailRepApiMock(Integer statusCode) {
        this.reputation = 'high';
        this.statusCode = statusCode;
        this.hasWrongBody = false;
    }

    public EmailRepApiMock(Boolean hasWrongBody) {
        this.reputation = 'high';
        this.statusCode = 200;
        this.hasWrongBody = hasWrongBody;
    }
    public HttpResponse respond(HttpRequest req) {
        
        HttpRequest emailValidationRequest = new HttpRequest();
        emailValidationRequest.setEndpoint('callout:cardimir__EmailRep');

        HttpRequest pardotRequest = new HttpRequest();
        String pardotNamedCredential = SettingService.getPublicSettingValue('Pardot_Named_Credential');
        pardotRequest.setEndpoint('callout:'+pardotNamedCredential);
        
        HttpResponse res = new HttpResponse();
        
        if (req.getEndpoint().contains(emailValidationRequest.getEndpoint())) {
            System.assertEquals('GET', req.getMethod(),'Expecting GET method as HTTP Request, getting '+req.getMethod());
            EmailRepImpl.EmailRepApiResponse emailRepResponse = new EmailRepImpl.EmailRepApiResponse();
            emailRepResponse.email = 'bill@microsoft.com';
            emailRepResponse.suspicious = this.reputation.equals('low');
            emailRepResponse.reputation = this.reputation;
            emailRepResponse.references = 59;

            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(this.statusCode);
            if(this.hasWrongBody){
                res.setBody('{\'test\':\'failed\'}');
            } else {
                res.setBody(JSON.serializePretty(emailRepResponse));
            }

        } else if (req.getEndpoint().contains(pardotRequest.getEndpoint())) {
            //Mockup successful logging Pardot External Activity
            System.assertEquals('POST', req.getMethod(),'Expecting POST method as HTTP Request, getting '+req.getMethod());
            res.setStatusCode(202);
        } else {
            System.debug(LoggingLevel.ERROR, 'Mock class received an unrecognized endpoint: '+req.getEndpoint());
            res.setStatusCode(500);
        }
        return res;
    }
   
}