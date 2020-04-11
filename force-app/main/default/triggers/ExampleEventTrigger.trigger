trigger ExampleEventTrigger on ExampleEvent__e (AFTER INSERT) {
    for(ExampleEvent__e current : Trigger.new) {
        System.debug(current.info__c);
    }
}