/**
 * @description       : The PE Publisher class which is parent class with all framework code to publish platform event and create log records.
 * @author            : Rajesh Ramachandran
 * @group             : 
 * @last modified on  : 01-28-2021
 * @last modified by  : Rajesh Ramachandran
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   01-28-2021   Rajesh Ramachandran   Initial Version
**/
public virtual class PEPublisher {

    //set the platform events created into this object
    public List<SObject> newPEs = new List<SObject>();
    public static Boolean skipLogging = (Boolean) PE_Setting__c.getInstance().get('Skip_Logging__c');

    //common method to invoke to create a PE
    public void run(){
        //method to check if this PE should be published
        if (skipRun()){
            return;
        }
        //method to create platform events. Override this in your publisher class with your logic
        createPEs();

        //if no events are generated then exit
        if (newPEs == null || newPEs.size() == 0){
            return;
        }
        //generate the logger record and add unique id on the platform event
        List<PE_Logger__c> loggerList = new List<PE_Logger__c>();
        Integer i = 100;
        for (Sobject so : newPEs){
            i++;
            //assign unique Id field with a unique identifier
            so.put('Unique_Id__c',so.getSObjectType().getDescribe().getName() + '-' + Datetime.now() + '-' + i);
            //create logger record if skip logging flag custom setting is not set to true
            if (skipLogging == false || skipLogging == null){
                PE_Logger__c pel = new PE_Logger__c(Unique_Id__c = (String)so.get('Unique_Id__c'),Status__c = 'Pending', PE_JSON__c = JSON.serialize(so));
                loggerList.add(pel);    
            }
        }
        //publish the events
        if (newPEs != null && newPEs.size() > 0){
            Database.SaveResult[] srList = Eventbus.publish(newPEs);
            for (Database.SaveResult sr : srList){
                if (!sr.isSuccess()){
                    for (Database.Error err : sr.getErrors()){
                        System.debug('Error in publishing event ' + err.getMessage());
                    }
                }
            }
        }
        //insert the logger records
        if (loggerList != null && loggerList.size() > 0){
            insert loggerList;
        }

    }

    //method to be overridden with logic to create the platform event
    @TestVisible
    protected virtual void createPEs(){}
  
    public Boolean skipRun(){
        /*check the custom setting to see PE should be published
        Skip the publisher if this class is in custom setting field */
        String skippedHandlers = (String)PE_Setting__c.getInstance().get('Skip_PE_Publish__c');
        if (skippedHandlers == null)
            return false;
        else {
            return (skippedHandlers.contains(getHandlerName()));
        }
    }

    @TestVisible
    private String getHandlerName() {
      return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    }

}