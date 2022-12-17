/**
 * ProspectDto
 * @description Data transfer object containining the information received from Pardot about the Prospect to be analysed 
 * as well as the service to be used and the Pardot Business Unit to which we're logging back the activity
 * 
 * @group EmailValidator
 * 
 */
global with sharing class ProspectDto {
    @InvocableVariable(label = 'Email Address' required=true)
    global String email;
    @InvocableVariable (label = 'Email Validation Service Name' required=true)
    global String service;
    @InvocableVariable (label = 'Business Unit ID' required=true)
    global String businessUnitId;
 
    global Boolean isPotentialSpam;

    global Boolean isCalloutSuccess() {
        return this.isPotentialSpam != null;
    }
}