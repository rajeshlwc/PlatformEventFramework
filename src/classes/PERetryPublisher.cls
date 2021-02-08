/**
 * @description       : Class to retry the platform events
 * @author            : Rajesh Ramachandran
 * @group             : 
 * @last modified on  : 02-08-2021
 * @last modified by  : Rajesh Ramachandran
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   02-08-2021   Rajesh Ramachandran   Initial Version
**/
public without sharing class PERetryPublisher  extends PEPublisher{

    List<PE_Logger__c> listPEs = new List<PE_Logger__c>();

    public PERetryPublisher(List<PE_Logger__c> retryPELs){
        this.listPEs = retryPELs;
    }


    //overridden method to create the platform events. Add all logic to generate the event here. Dont publish it. Framework will publish it.
    public override void createPEs(){
        for (PE_Logger__c pel : this.listPEs){
            Type t1 = Type.forName(pel.PE_Name__c);
            String peJSON = pel.PE_JSON__c;
            SObject peSO = (SObject)JSON.deserialize(peJSON, t1);
            this.newPEs.add(peSO);
        }
    }

}