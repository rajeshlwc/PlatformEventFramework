/**
 * @description       : Class to record an exception from Platform Events 
 * @author            : Rajesh Ramachandran
 * @group             : 
 * @last modified on  : 02-03-2021
 * @last modified by  : Rajesh Ramachandran
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   02-03-2021   Rajesh Ramachandran   Initial Version
**/
public class PEExceptionHandler {

    public static void LogError(String errMessage, String apexClass,string RecordId, String username) {
        try{
            PE_Exception__c errorLog = new PE_Exception__c();
            errorLog.Error_Message__c = errMessage.length()>255?errMessage.substring(0,254):errMessage;
            errorLog.Error_Class__c = apexClass;
            errorLog.Username__c = username;
            errorLog.Record_Id__c=RecordId;
            insert errorLog;
        }
        catch(Exception e){
            System.debug('The following error has occurred:'+ e.getCause() + ': ' + e.getMessage() + '.At line: ' + e.getLineNumber());                    
        }
    }

}