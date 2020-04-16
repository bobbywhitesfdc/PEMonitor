/**
* Custom Controller to show Platform Events Subscriber Status
**/ 
public with sharing class PlatformEventMonitoringController {
    private static final Integer EBS_LIMIT_RECORDS = 100;
    public static final String MONITORING_PERMISSION = 'Monitor_Platform_Events';
    public static final String MSG_MISSING_PERMISSIONS = 'User must have permission to monitor platform events! Missing: '
     + MONITORING_PERMISSION;
    
    @testVisible
    public static List<EventBusSubscriber> subscriptionInfo {
        get {
            final Boolean hasCustomPermission = FeatureManagement.checkPermission(MONITORING_PERMISSION);
            if (hasCustomPermission && isSafeObject('EventBusSubscriber')) {
                return [SELECT Topic, ExternalId, Name, Position, Retries, Status, Tip, Type, LastError 
                     FROM EventBusSubscriber order by Topic, Name LIMIT :EBS_LIMIT_RECORDS]; 
                     }
            else {
                throw new MonitoringException(MSG_MISSING_PERMISSIONS);
            }
        }    
        private set;
    }

    // Entry point for the VF page
    public static List<EventBusSubscriber> getResults() {
        try {
            return subscriptionInfo;
        } catch (MonitoringException me) {
            ApexPages.addMessages(me);
            return new List<EventBusSubscriber>();
        }
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
        final Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        final SObjectType myObj = schemaMap.get(objName);
        // Guard against a bad object name
        return (myObj != null) &&  myObj.getDescribe().isAccessible();
    }

    public class MonitoringException extends Exception {      
    }
}