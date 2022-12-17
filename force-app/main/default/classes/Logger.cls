/**
 * Logger
 * 
 * @description Basic logger, inserting debug information on EmailValidatorLog__c custom object
 *  
 * @group EmailValidator
 * 
 */
public with sharing class Logger { //implements Queueable {

    private static List<EmailValidatorLog__c> logs;
    public static void writeLogsToDatabase() {
        if(logs.size()!=0) {
            Database.SaveResult[] results = Database.insert(logs, false);
            for (Database.SaveResult sr : results) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug(LoggingLevel.INFO,'Successfully inserted log. Log ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug(LoggingLevel.ERROR,'The following error has occurred.');                    
                        System.debug(LoggingLevel.ERROR,err.getStatusCode() + ': ' + err.getMessage());
                        System.debug(LoggingLevel.ERROR,'Log fields that affected this error: ' + err.getFields());
                    }
                }
            }
        } else {
            System.debug(LoggingLevel.ERROR, 'Something went wrong, there is nothing to log (logs = null)');
        }
    }

    /**
     * Logs debug information on the EmailValidatorLog custom object
     *
     * @param businessUnitId (String): Pardot Business Unit ID
     * @param serviceName (String): Service Name
     * @param email (String): Prospect's Email
     * @param status (String): Action Status
     * @param message (String): Action Description or message
     * @param rawMessage (String): Raw JSON messages
     * 
     */
    @SuppressWarnings('PMD.ExcessiveParameterList')
    public static void log(String businessUnitId, String serviceName, String email, String status, String message, String rawMessage) {
        DescribeSObjectResult logDescribe = cardimir__EmailValidatorLog__c.getSObjectType().getDescribe();
        String[] fieldsToInsert = new String[]{'cardimir__BusinessUnitId__c','cardimir__ServiceName__c','cardimir__Email__c','cardimir__Status__c','cardimir__Message__c','cardimir__RawMessage__c'};
        Map<String, Schema.SObjectField> logFields = Schema.SObjectType.cardimir__EmailValidatorLog__c.fields.getMap();
        Boolean checkFLS = true;
        for(String field : fieldsToInsert) {
            if(logFields.get(field) != null && !logFields.get(field).getDescribe().isCreateable()) {
                checkFLS = false;
            }
        }
        if(logDescribe.isAccessible() && logDescribe.isCreateable() && checkFLS){
            cardimir__EmailValidatorLog__c log = new cardimir__EmailValidatorLog__c(
                cardimir__BusinessUnitId__c = businessUnitId,
                cardimir__ServiceName__c = serviceName,
                cardimir__Email__c = email,
                cardimir__Status__c = status,
                cardimir__Message__c = message,
                cardimir__RawMessage__c = rawMessage
            );
            if(logs==null){
                logs = new List<EmailValidatorLog__c>();
            }
            logs.add(log);
            System.debug(LoggingLevel.INFO, 'New log:');
            System.debug(LoggingLevel.INFO, log);
            System.debug(LoggingLevel.INFO, 'At this stage there are '+logs.size()+' logs.');
        } else {
            System.debug(LoggingLevel.ERROR, 'User is not allowed to write logs to EmailValidatorLog__c');
        }
    }
}