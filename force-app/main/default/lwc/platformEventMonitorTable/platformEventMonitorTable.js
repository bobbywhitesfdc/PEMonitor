import { LightningElement, api, wire } from 'lwc';
import getInfo from '@salesforce/apex/PlatformEventMonitoringController.getInfo';

export default class PlatformEventMonitorTable extends LightningElement {
    @wire(getInfo) subscriptionInfos;
} 
