/**
 * AbstractApiMock
 * @description Dynamic Mock class used for Unit Tests
 * @group AbstractApi
 * 
 */
@isTest
public with sharing class AbstractApiMock implements HttpCalloutMock {

    public Decimal qualityScore;
    public Integer statusCode;
    public Boolean hasWrongBody;

    public AbstractApiMock(Decimal qualityScore) {
        this.qualityScore = qualityScore;
        this.statusCode = 200;
        this.hasWrongBody = false;
    }
    
    public AbstractApiMock(Integer statusCode) {
        this.qualityScore = 1;
        this.statusCode = statusCode;
        this.hasWrongBody = false;
    }

    public AbstractApiMock(Boolean hasWrongBody) {
        this.qualityScore = 1;
        this.statusCode = 200;
        this.hasWrongBody = hasWrongBody;
    }

    public HttpResponse respond(HttpRequest req) {
        
        HttpRequest emailValidationRequest = new HttpRequest();
        emailValidationRequest.setEndpoint('callout:cardimir__Abstract');

        HttpRequest pardotRequest = new HttpRequest();
        String pardotNamedCredential = SettingService.getPublicSettingValue('Pardot_Named_Credential');
        pardotRequest.setEndpoint('callout:'+pardotNamedCredential);
        
        HttpResponse res = new HttpResponse();
        
        if (req.getEndpoint().contains(emailValidationRequest.getEndpoint())) {
            System.assertEquals('GET', req.getMethod(),'Expecting GET method as HTTP Request, getting '+req.getMethod());
            AbstractImpl.AbstractApiResponse aar = new AbstractImpl.AbstractApiResponse();
            aar.autocorrect = '';
            aar.deliverability = 'DELIVERABLE';
            aar.email = 'bill@microsoft.com';
            aar.quality_score = this.qualityScore;
            
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(this.statusCode);
            if(this.hasWrongBody){
                res.setBody('{\'test\':\'failed\'}');
            } else {
                res.setBody(JSON.serializePretty(aar));
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