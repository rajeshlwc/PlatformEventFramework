/**
 * @description       : Example Class of a platform event publisher. Extends PEPublisher and overrides the method createPEs
 * @author            : Rajesh Ramachandran
 * @group             : 
 * @last modified on  : 01-28-2021
 * @last modified by  : Rajesh Ramachandran
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   01-28-2021   Rajesh Ramachandran   Initial Version
**/
public class CaseEventPublisher extends PEPublisher{

    //overridden method to create the platform events. Add all logic to generate the event here. Dont publish it. Framework will publish it.
    public override void createPEs(){
        system.debug('create PEs in case event publisher');
        List<Case_Event__e> listCEs = new List<Case_Event__e>();
        for (Case cs : (List<Case>) Trigger.new){
            this.newPEs.add(new Case_Event__e(Case_Number__c = cs.casenumber));
        }
    }


}