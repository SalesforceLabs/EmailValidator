/**
 * SendgridApiMock
 * @description Dynamic Mock class used for Unit Tests
 * @group Sendgrid
 */
@isTest
public with sharing class SendgridApiMock implements HttpCalloutMock {
    
    public String verdict;
    public Integer statusCode;
    public Integer pardotStatusCode;
    public Boolean hasWrongBody;

    public SendgridApiMock(String verdict){
        this.verdict=verdict;
        this.statusCode=200;
        this.pardotStatusCode=202;
        this.hasWrongBody=false;
    }

    public SendgridApiMock(Integer statusCode){
        this.verdict='Valid';
        this.statusCode=statusCode;
        this.pardotStatusCode=(statusCode==200?202:statusCode);
        this.hasWrongBody=false;
    }

    public SendgridApiMock(Integer statusCode,Integer pardotStatusCode){
        this.verdict='Valid';
        this.statusCode=statusCode;
        this.pardotStatusCode=pardotStatusCode;
        this.hasWrongBody=false;
    }

    public SendgridApiMock(Boolean hasWrongBody){
        this.verdict='Valid';
        this.statusCode=200;
        this.pardotStatusCode=202;
        this.hasWrongBody=hasWrongBody;
    }

    public HttpResponse respond(HttpRequest req) {
        
        HttpRequest emailValidationRequest = new HttpRequest();
        emailValidationRequest.setEndpoint('callout:cardimir__Sendgrid');
        
        HttpRequest pardotRequest = new HttpRequest();
        String pardotNamedCredential = SettingService.getSettingValue('Pardot_Named_Credential');
        pardotRequest.setEndpoint('callout:'+pardotNamedCredential);
        
        HttpResponse res = new HttpResponse();
        
        if (req.getEndpoint().contains(emailValidationRequest.getEndpoint())) {
            System.assertEquals('POST', req.getMethod(),'Expecting POST method as HTTP Request, getting '+req.getMethod());
                        
            if(this.hasWrongBody){
                res.setBody('{\'test\':\'failed\'}');
            } else {
                SendgridImpl.SendgridApiResponse sar = new SendgridImpl.SendgridApiResponse();
                SendgridImpl.Result result = new SendgridImpl.Result();
                result.verdict = this.verdict;
                sar.result = result;
                res.setBody(JSON.serializePretty(sar));
            }

            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(this.statusCode);
        } else {
            //Mockup successful logging Pardot External Activity
            System.assertEquals('POST', req.getMethod(),'Expecting POST method as HTTP Request, getting '+req.getMethod());
            res.setStatusCode(this.pardotStatusCode);
        }
        return res;
    }
}