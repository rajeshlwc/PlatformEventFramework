/**
 * @description       : 
 * @author            : Rajesh Ramachandran
 * @group             : 
 * @last modified on  : 01-28-2021
 * @last modified by  : Rajesh Ramachandran
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   01-12-2021   Rajesh Ramachandran   Initial Version
**/
trigger CaseEventTrigger on Case_Event__e (after insert) {
    //Call the subscriber class which implements PESubscriber run method
    new CaseEventSubscriber(trigger.new).run();

}