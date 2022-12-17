/**
 * EmailValidatorAction
 * @description Invocable Action used by Pardot's External Activity (can also be used in Flows)
 * 
 * @group EmailValidator
 */
global with sharing class EmailValidatorAction {
        
    /**
     * @description Invocable Action used by Pardot's External Activity (can also be used in Flows)
     * 
     * @param prospects (List<ProspectDto>): a list of Prospects to be sent to external email validation services
     */
    @InvocableMethod(label='Get Email Reputation' description='Check Prospect\'s Email Reputation using one of the available services.' callout=true category='Email' iconName='slds:standard:product_required')
    global static List<Response> getEmailReputation(List<ProspectDto> prospects){
        List<Response> responses = new List<Response>();
        for(ProspectDto prospect:prospects){
            EmailValidator ev = new EmailValidator(prospect.service);
            Response res = new Response();
            try {
                ev.checkEmail(prospect);
                if (prospect.isCalloutSuccess()) {
                    ev.logExternalActivity(prospect);
                    res.success = true;
                    String feedback = prospect.isPotentialSpam == true ? 'potential SPAM' : 'a valid email address (NOT spam)';
                    res.resultMessage = 'Email '+prospect.email+' is '+ feedback +' according to service '+prospect.service;
                } else {
                    throw new EmailValidator.ExternalServiceException('Error with Email Validation or logging the activity to Pardot, please check the logs in Email Validator Log object');
                }               
            } catch (Exception e) {
                res.success = false;
                res.resultMessage = e.getMessage();
            }
            responses.add(res);
            
        }
        //System.enqueueJob(new Logger());
        Logger.writeLogsToDatabase();
        return responses;
    }
    
    global class Response {
        @InvocableVariable(label='Callout Success' required=true)
        global Boolean success;
        @InvocableVariable(label='Results Message' required=true)
        global String resultMessage;
    }
}