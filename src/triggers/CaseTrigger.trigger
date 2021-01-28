/**
 * @description       : Sample trigger which calls the case event publisher class run method
 * @author            : Rajesh Ramachandran
 * @group             : 
 * @last modified on  : 01-28-2021
 * @last modified by  : Rajesh Ramachandran
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   01-04-2021   Rajesh Ramachandran   Initial Version
**/
trigger CaseTrigger on Case (before insert, after insert) {
    
    List<Case> afterInsertCases = new List<Case>();
    for (Case cs : trigger.new){
        if (trigger.isAfter && trigger.isInsert){
            afterInsertCases.add(cs);
        }
    }
    //invoke the publisher run method
    if (afterInsertCases != null && afterInsertCases.size() > 0)
        new CaseEventPublisher().run();

}