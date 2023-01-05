/**
 * ZerobounceApiMock
 * @description Dynamic Mock class used for Unit Tests
 * @group Zerobounce
 */
@isTest
public with sharing class ZerobounceApiMock implements HttpCalloutMock {
    
    public String verdict;
    public Integer statusCode;
    public Integer pardotStatusCode;
    public Boolean hasWrongBody;

    public ZerobounceApiMock(String verdict){
        this.verdict=verdict;
        this.statusCode=200;
        this.pardotStatusCode=202;
        this.hasWrongBody=false;
    }

    public ZerobounceApiMock(Integer statusCode){
        this.verdict='Valid';
        this.statusCode=statusCode;
        this.pardotStatusCode=(statusCode==200?202:statusCode);
        this.hasWrongBody=false;
    }

    public ZerobounceApiMock(Integer statusCode,Integer pardotStatusCode){
        this.verdict='Valid';
        this.statusCode=statusCode;
        this.pardotStatusCode=pardotStatusCode;
        this.hasWrongBody=false;
    }

    public ZerobounceApiMock(Boolean hasWrongBody){
        this.verdict='Valid';
        this.statusCode=200;
        this.pardotStatusCode=202;
        this.hasWrongBody=hasWrongBody;
    }

    public HttpResponse respond(HttpRequest req) {
        
        HttpRequest emailValidationRequest = new HttpRequest();
        emailValidationRequest.setEndpoint('callout:cardimir__Zerobounce');
        
        HttpRequest pardotRequest = new HttpRequest();
        String pardotNamedCredential = SettingService.getPublicSettingValue('Pardot_Named_Credential');
        pardotRequest.setEndpoint('callout:'+pardotNamedCredential);
        
        HttpResponse res = new HttpResponse();
        
        if (req.getEndpoint().contains(emailValidationRequest.getEndpoint())) {
            System.assertEquals('GET', req.getMethod(),'Expecting POST method as HTTP Request, getting '+req.getMethod());
                        
            if(this.hasWrongBody){
                res.setBody('{\'test\':\'failed\'}');
            } else {
                ZerobounceImpl.ZerobounceApiResponse zar = new ZerobounceImpl.ZerobounceApiResponse();
                zar.status = this.verdict;
                res.setBody(JSON.serializePretty(zar));
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