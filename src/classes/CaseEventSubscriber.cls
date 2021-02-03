/**
 * @description       : 
 * @author            : Rajesh Ramachandran
 * @group             : 
 * @last modified on  : 02-03-2021
 * @last modified by  : Rajesh Ramachandran
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   01-28-2021   Rajesh Ramachandran   Initial Version
**/
public  class CaseEventSubscriber extends PESubscriber{

    //constructor to pass events. Every subscriber class should include this
    //pass an integer which indicates upper threshold of events for processing
    public CaseEventSubscriber(List<SObject> lsEvents){
        super(lsEvents, 20);
    }

    //method to override in the subscriber class where the event will be process according to business logic
    public override void processEvents(List<SObject> lsEvents){
        for (Case_Event__e cs: (List<Case_Event__e>)lsEvents){
            system.debug('event getting processed is ' + cs.Case_Number__c);
        }
    }

}