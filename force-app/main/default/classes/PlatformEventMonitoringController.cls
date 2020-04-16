/**
* Custom Controller to show Platform Events Subscriber Status
**/ 
public with sharing class PlatformEventMonitoringController {
    private static final Integer EBS_LIMIT_RECORDS = 100;

    @testVisible
    public static List<EventBusSubscriber> subscriptionInfo {
        get {
            Boolean hasCustomPermission = FeatureManagement.checkPermission('Monitor_Platform_Events');
            if (hasCustomPermission && isSafeObject('EventBusSubscriber')) {
                return [SELECT Topic, ExternalId, Name, Position, Retries, Status, Tip, Type, LastError 
                     FROM EventBusSubscriber order by Topic, Name LIMIT :EBS_LIMIT_RECORDS]; 
                     }
            else {
                List<EventBusSubscriber> subscriptionInfo = new List<EventBusSubscriber>();
                return subscriptionInfo ;
            }
        }    
        private set;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<SubscriberInfo> getSubscriberInfo(){
        System.debug('getSubscriptionInfo:' + subscriptionInfo.size());
        final List<SubscriberInfo> infos = new List<SubscriberInfo>();
        for (EventBusSubscriber current : subscriptionInfo) {
            infos.add(new SubscriberInfo(current));
        }
        return infos;
        
    }
    public class SubscriberInfo {
        @AuraEnabled
        public String topic { get; private set; }
        @AuraEnabled
        public String externalId { get; private set; }
        @AuraEnabled
        public String subscriberName { get; private set; }
        @AuraEnabled
        public Integer position {get; private set; }
        @AuraEnabled
        public Integer tip {get; private set;}
        @AuraEnabled
        public Integer retries {get; private set; }
        @AuraEnabled
        public String status {get; private set; }
        @AuraEnabled
        public String type {get; private set; }
        @AuraEnabled
        public String id {get; private set; }
        @AuraEnabled
        public String uri  {
            get { return  '/' + externalId; }
        }
    

        public SubscriberInfo (final EventBusSubscriber theRecord) {
            this.externalId = theRecord.ExternalId;
            this.id = theRecord.Id;
            this.tip = theRecord.Tip;
            this.position = theRecord.Position;
            this.retries = theRecord.Retries;
            this.type = theRecord.Type;
            this.topic = theRecord.Topic;
            this.subscriberName = theRecord.Name;
            this.status = theRecord.Status;
        }
    }

    private static boolean isSafeObject(String objName){
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType myObj = schemaMap.get(objName);
        if (myObj.getDescribe().isAccessible() ) { 
            return true; 
        }else{
            return false;
        }
    }
}