/**
 * @description       : Subscriber class with framework to update logger record. It will call ProcessEvents method
 * @author            : Rajesh Ramachandran
 * @group             : 
 * @last modified on  : 01-28-2021
 * @last modified by  : Rajesh Ramachandran
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   01-28-2021   Rajesh Ramachandran   Initial Version
**/
public virtual class PESubscriber {

    public List<SObject> newPEs = new List<SObject>();
    //holds replayId which can be used to resume the event processing
    public String replayId = '0';
    //holds list of unique Ids to update logger records or to check for duplicate publish
    List<String> uniqueIdList = new List<String>();

    public PESubscriber(List<Sobject> listPEs){
        this.newPEs = listPEs;
    }

    public void run(){
        Integer counter = 0;
        try{
            for (SObject so : this.newPEs){
                counter++;
                // Only process the first 200 event messages
                //200 is hardcoded. This can be enhanced to come from custom settings
                //if we get 2000 messages , we only pick first 200 records.
                //resume checkpoint will be 11th record
                if (counter <= 200){
                    // Resume after the last successfully processed
                    // event message
                    // after the trigger stops running. 
                    // Exit for loop.
                    uniqueIdList.add((String)so.get('unique_id__c'));  
                    replayId = (String)so.get('ReplayId');
                }
                else {
                    //lets add to process list
                    break;                    
                }
            }


            /* PE Logger is custom object which used for logging.
            publisher would have logged record with status 'Pending'
            Subscriber will change it to completed once received. 
            */
            List<PE_Logger__c> logList = [Select Id,status__c,unique_id__c From PE_Logger__c WHERE unique_id__c in :uniqueIdList];

            List<String> completedIds = new List<String>();
            Map<String,Id> pendingIds = new Map<String,Id>();

            //create a list of platform events that can be passed for further processing
            List<SObject> listPEs = new List<SObject>();
            //populate the completed log list and pending logs Map
            for(PE_Logger__c log : logList){
                if (log.status__c == 'Completed'){
                    completedIds.add(log.unique_id__c);
                }
                else {
                    pendingIds.put(log.unique_id__c,log.id);                    
                }
            }

            //list to update logger records
            List<PE_Logger__c> updLogList = new List<PE_Logger__c>();

            // Iterate through each notification.
            for (SObject event : this.newPEs) {
                //check to avoid processing same message
                //remember NOT CONTAINS
                if(!completedIds.contains((String)event.get('unique_id__c')) && pendingIds.get((String)event.get('unique_id__c')) != null){
                    //log record to LOgger object
                    PE_Logger__c pel = new PE_Logger__c(Id=pendingIds.get((String)event.get('unique_id__c')),status__c = 'Completed');
                    updLogList.add(pel);
                    //add records in list for processing
                    listPEs.add(event);
                }                            
            }

            if (updLogList != null && updLogList.size() > 0){
                update updLogList;
            }
            if (listPEs != null && listPEs.size() > 0){
                processEvents(listPEs);
            }

            // Set Replay ID after which to resume event processing 
            // in new trigger execution.
            if(replayId != '0'){
                EventBus.TriggerContext.currentContext().setResumeCheckpoint(replayId);
            }
        }
        catch(Exception ex){
            //replace with exception logging framework as needed
            System.debug('Exception fired ' + ex.getMessage() );
        }
        finally{
            //if an exception happens set back the replay Id to last processed replay id
            if(replayID != '0')
                EventBus.TriggerContext.currentContext().setResumeCheckpoint(replayId);
        }

    }

    //method to be written to process the events passed. Override this with necessary business logic
    @TestVisible
    protected virtual void processEvents(List<SObject> lsEvents){}
    
}