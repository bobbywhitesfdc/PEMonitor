@isTest(isParallel=false)
public class PlatformEventMonitoringController_Test {
    private static final String EXPECTED_FAILURE = 'User must have permission to monitor platform events! Missing: Monitor_Platform_Events';
    /**
* SELECT Topic, ExternalId, Name, Position, Retries, Status, Tip, Type, LastError 
* FROM EventBusSubscriber order by Topic, Name
**/ 
    
    // Has Subscribers
    private static testmethod void testHappyPathVF() {
        System.runAs(createTestUser(true)) {
            
            if (PlatformEventMonitoringController.subscriptionInfo.isEmpty()) {
                PlatformEventMonitoringController.subscriptionInfo = loadFromStaticResource(); 
            }
            
            final List<EventBusSubscriber> results = PlatformEventMonitoringController.subscriptionInfo;
            System.Assert(results.size() > 0,'Expected 1 or more Subscriptions');
            for (EventBusSubscriber current : results) {
                System.AssertNotEquals(null,current.Topic,'Topic cannot be null');
                System.AssertNotEquals(null,current.Name,'Name cannot be null');
            }
        }
    }
    
    private static testmethod void testNoPermsVF() {
        System.runAs(createTestUser(false)) {
            
            final List<EventBusSubscriber> results = PlatformEventMonitoringController.getResults();
            System.AssertEquals(0,results.size(),'Expected 0  Subscriptions');
            final List<ApexPages.Message> msgs = ApexPages.getMessages();
            System.Assert(!msgs.isEmpty(),'Expected Page Messages!');
            System.AssertEquals(EXPECTED_FAILURE,msgs[0].getDetail(),'Wrong message!');
        }
    }
    private static testmethod void testHappyPathLWC() {
        System.runAs(createTestUser(true)) {
            if (PlatformEventMonitoringController.subscriptionInfo.isEmpty()) {
                PlatformEventMonitoringController.subscriptionInfo = loadFromStaticResource(); 
            }
            
            final List<PlatformEventMonitoringController.SubscriberInfo> results = PlatformEventMonitoringController.getSubscriberInfo();
            
            for (PlatformEventMonitoringController.SubscriberInfo current : results) {
                System.AssertNotEquals(null,current.topic,'Topic cannot be null');
                System.AssertNotEquals(null,current.subscriberName,'subscriberName cannot be null');
                System.AssertNotEquals(null,current.id,'Id cannot be null');
                System.AssertNotEquals(null,current.ExternalId,'ExternalId cannot be null');
                System.AssertNotEquals(null,current.uri,'Uri cannot be null');
            }
        }
    }
    
    private static testmethod void testNoPermsLWC() {
        System.runAs(createTestUser(false)) {
            
            try {
                final List<PlatformEventMonitoringController.SubscriberInfo> results = PlatformEventMonitoringController.getSubscriberInfo();
                System.Assert(false,'Should not reach here with no permissions!');
                
            } Catch (PlatformEventMonitoringController.MonitoringException me) {
                System.AssertEquals(EXPECTED_FAILURE, me.getMessage(),'Wrong message!');
            }
        }
    }
    
    private static List<EventBusSubscriber> loadFromStaticResource() {
        final StaticResource sr = [SELECT Id, Body FROM StaticResource 
                                   WHERE Name = 'TestEventBusSubscriber' LIMIT 1];
        List<EventBusSubscriber> results = (List<EventBusSubscriber>) JSon.deserialize(sr.Body.toString(),List<EventBusSubscriber>.class);
        return results;
    }
    
    private static User createTestUser(final Boolean includePermissions) {
        final Long seed = System.currentTimeMillis();
        final String theAlias = 't' + String.valueOf(seed).right(5);
        final Profile standardUserProfile = [SELECT id, name 
                                             FROM Profile 
                                             WHERE Name = 'Standard User'];
        
        final User theTestUser = new User(FirstName='test'+seed
                                          ,LastName='User'
                                          ,Username='test' + seed + '.user@example.com'
                                          ,Email='test' + seed + 'user@example.com.invalid'
                                          ,Alias= theAlias
                                          ,TimeZoneSidKey = 'America/Los_Angeles'
                                          ,LocaleSidKey = 'en_US'
                                          ,EmailEncodingKey = 'ISO-8859-1'
                                          ,ProfileId =standardUserProfile.Id
                                          ,LanguageLocaleKey = 'en_US');
        insert theTestUser;
        
        if (includePermissions) {
            System.runAs(getRunningUser()) {
                PermissionSet pePermissionSet = [SELECT Id, Name
                                                 FROM PermissionSet
                                                 WHERE Name = 'Monitor_Platform_Events'];
                PermissionSetAssignment psa = new PermissionSetAssignment
                    (PermissionSetId = pePermissionSet.Id, AssigneeId = theTestUser.id);
                upsert psa; 
            }
        }
        return theTestUser;
    }
    private static User getRunningUser() {
        return new User(Id=UserInfo.getUserId());
    }
}