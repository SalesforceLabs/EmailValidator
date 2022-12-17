/**
 * ExternalActivity
 * @description Describes all the fields required in the payload to be sent to Pardot to log an External Activity
 * 
 * @group EmailValidator
 */
public with sharing class ExternalActivity {
	public String extension;
    public String type;
    public String value;
    public String email;
}