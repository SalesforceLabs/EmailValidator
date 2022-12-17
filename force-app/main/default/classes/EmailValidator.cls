/**
 * EmailValidator
 * 
 * @description Main class used by the EmailValidator Invocable Action to dynamically select 
 * the Email validation service to be used (and its related Apex classes).
 * 
 * @group EmailValidator
 * 
 */ 
public with sharing class EmailValidator {
    
    public static final Map<String,EmailValidatorService> STRATEGIES = new Map<String,EmailValidatorService>();
    private EmailValidatorService strategy;
    public class NameException extends Exception {}
    public class MissingEmailException extends Exception {}
    public class ExternalServiceException extends Exception {}
 
    static {
        Map<String,Email_Validator_Service__mdt> services = Email_Validator_Service__mdt.getAll();
        for(Email_Validator_Service__mdt service:services.values()){
            if(service.active__c){
                STRATEGIES.put(
                    service.developerName,
                    (EmailValidatorService)Type.forName(service.Apex_Class_Name__c).newInstance()
                );
            }
        }
    }

    


    /**
     * EmailValidator Constructor
     *
     * @param service (String): The name of the service to be called to check an email address
     *
     * @throws NameException if the provided "service" String doesn't contain a valid value
     */
    public EmailValidator(String service){
        if(!STRATEGIES.containsKey(service)) {
            throw new NameException();
        }
        strategy = STRATEGIES.get(service);
    }

    /**
     * checkEmail
     * Calls the checkEmail method from the implementation classes dynamically selected
     *
     * @param prospect (ProspectDto): The prospect information received via the Invocable Action (called by External Actions or Flows)
     *
     *
     * @throws MissingEmailException if the prospect doesn't have an email address (basic check)
     */
    public void checkEmail(ProspectDto prospect) {
        if(prospect.email == null || !prospect.email.contains('@')) {
            throw new MissingEmailException();
        }
        strategy.checkEmail(prospect);
    } 
    public void logExternalActivity(ProspectDto prospect) {
        strategy.logExternalActivity(prospect);
    } 
}