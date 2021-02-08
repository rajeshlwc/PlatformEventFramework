/**
 * @description       : Batch class that can be used to retry platform events that fail
 * @author            : Rajesh Ramachandran
 * @group             : 
 * @last modified on  : 02-08-2021
 * @last modified by  : Rajesh Ramachandran
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   02-08-2021   Rajesh Ramachandran   Initial Version
**/
public without sharing class PERetryBatch implements Database.Batchable<SObject>{

    String peQuery;
    List<SObject> retryPEs = new List<SObject>();

    //retry events in the last day
    public PERetryBatch(){
        peQuery = 'Select id, unique_id__c,PE_JSON__c,PE_Name__c,Retry_PE__c from PE_Logger__c where Retry_PE__c = true and status__c = \'Pending\' and Createddate = last_n_days:1';
    }    

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(peQuery);
    }

    public void execute(Database.BatchableContext bc, List<PE_Logger__c> records){

        if (records != null && records.size() > 0){
            PERetryPublisher retryCls = new PERetryPublisher(records);
            retryCls.run();
        }
        //reset the processed pe loggers to retry = false
        for (PE_Logger__c pel : records){
            pel.retry_pe__c = false;
        }
        update records;

    }

    public void finish(Database.BatchableContext bc){
        //add any fnish logic specific to org
    }

}