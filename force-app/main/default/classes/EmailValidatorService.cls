/**
 * EmailValidatorService
 * 
 * @description Interface that needs to be implemented by all email validation services
 * 
 * @group EmailValidator
 *
 */
public interface EmailValidatorService {
    void checkEmail(ProspectDto prospect);
    void logExternalActivity(ProspectDto prospect);
}