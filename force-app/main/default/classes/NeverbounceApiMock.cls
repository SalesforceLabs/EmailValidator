/**
 * NeverbounceApiMock
 * @description Dynamic Mock class used for Unit Tests
 * @group Neverbounce
 */
@isTest
public with sharing class NeverbounceApiMock implements HttpCalloutMock {
    
    public String result;
    public Integer statusCode;
    public Integer pardotStatusCode;
    public Boolean hasWrongBody;

    public NeverbounceApiMock(String result){
        this.result=result;
        this.statusCode=200;
        this.pardotStatusCode=202;
        this.hasWrongBody=false;
    }

    public NeverbounceApiMock(Integer statusCode){
        this.result='Valid';
        this.statusCode=statusCode;
        this.pardotStatusCode=(statusCode==200?202:statusCode);
        this.hasWrongBody=false;
    }

    public NeverbounceApiMock(Integer statusCode,Integer pardotStatusCode){
        this.result='Valid';
        this.statusCode=statusCode;
        this.pardotStatusCode=pardotStatusCode;
        this.hasWrongBody=false;
    }

    public NeverbounceApiMock(Boolean hasWrongBody){
        this.result='Valid';
        this.statusCode=200;
        this.pardotStatusCode=202;
        this.hasWrongBody=hasWrongBody;
    }

    public HttpResponse respond(HttpRequest req) {
        
        HttpRequest emailValidationRequest = new HttpRequest();
        emailValidationRequest.setEndpoint('callout:cardimir__Neverbounce');
        
        HttpRequest pardotRequest = new HttpRequest();
        String pardotNamedCredential = SettingService.getSettingValue('Pardot_Named_Credential');
        pardotRequest.setEndpoint('callout:'+pardotNamedCredential);
        
        HttpResponse res = new HttpResponse();
        
        if (req.getEndpoint().contains(emailValidationRequest.getEndpoint())) {
            System.assertEquals('POST', req.getMethod(),'Expecting POST method as HTTP Request, getting '+req.getMethod());
                        
            if(this.hasWrongBody){
                res.setBody('{\'test\':\'failed\'}');
            } else {
                NeverbounceImpl.NeverbounceApiResponse nar = new NeverbounceImpl.NeverbounceApiResponse();
                nar.result = this.result;
                res.setBody(JSON.serializePretty(nar));
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