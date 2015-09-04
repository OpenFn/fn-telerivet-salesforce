public with sharing class SortSelectOptions {
    /*
        @Param:List of selectOption to be sort.
        @Return: Sorted list of selectOptions by Label
    */
    public static list<selectOption> selectOptionSortByLabel(list<selectOption>
                                                            selectOptionsToSort) {
        if(selectOptionsToSort == null || selectOptionsToSort.size() <= 1){
            return selectOptionsToSort;
        }
        List<SelectOption> lessSelectOption = new List<SelectOption>();
        List<SelectOption> greaterSelectOption = new List<SelectOption>();
        integer pivot = selectOptionsToSort.size() / 2;
        
        //save the pivot and remove it from the selectOption list
        SelectOption pivotValue = selectOptionsToSort[pivot];
        selectOptionsToSort.remove(pivot);
        for(selectOption SO : selectOptionsToSort){
            if(SO.getLabel() <= pivotValue.getLabel()){
                lessSelectOption.add(SO);
            }else if(SO.getLabel() > pivotValue.getLabel()){
                greaterSelectOption.add(SO);   
            }
        }
        list<selectOption> sortedSelectOptions = new list<selectOption>(); 
        sortedSelectOptions.addAll(selectOptionSortByLabel(lessSelectOption));
        sortedSelectOptions.add(pivotValue);
        sortedSelectOptions.addAll(selectOptionSortByLabel(greaterSelectOption));
        return SortedSelectOptions;
    }
    /*
        @Param:List of selectOption to be sort.
        @Return: Sorted list of selectOptions by Value
    */
    public static list<selectOption> selectOptionSortByValue(list<selectOption>
                                                            selectOptionsToSort){
        if(selectOptionsToSort == null || selectOptionsToSort.size() <= 1){
            return selectOptionsToSort;
        }       
        List<SelectOption> lessSelectOption = new List<SelectOption>();
        List<SelectOption> greaterSelectOption = new List<SelectOption>();
        integer pivot = selectOptionsToSort.size() / 2;
         
        //save the pivot and remove it from the selectOption list
        SelectOption pivotValue = selectOptionsToSort[pivot]; 
        selectOptionsToSort.remove(pivot);
        for(selectOption SO : selectOptionsToSort){
            if(SO.getValue() <= pivotValue.getValue()){
                lessSelectOption.add(SO);
            }else if(SO.getValue() > pivotValue.getValue()){
                greaterSelectOption.add(SO);   
            }
        }
        list<selectOption> SortedSelectOptions = new list<selectOption>(); 
        SortedSelectOptions.addAll(selectOptionSortByValue(lessSelectOption));
        SortedSelectOptions.add(pivotValue);
        SortedSelectOptions.addAll(selectOptionSortByValue(greaterSelectOption));
        return SortedSelectOptions;
    }
    
    
public static map<string,string> fillNotNeededObj(){

    map<string, string> mapRemoveObject = new map<string , string>();
      
    mapRemoveObject.put('AccountCriteriaBasedSharingRule' , 'AccountCriteriaBasedSharingRule');
    mapRemoveObject.put('AccountOwnerSharingRule' , 'AccountOwnerSharingRule');
    mapRemoveObject.put('AccountSharingRules' , 'AccountSharingRules');
    mapRemoveObject.put('AnalyticSnapshot' , 'AnalyticSnapshot');
    mapRemoveObject.put('ApexClass' , 'ApexClass');
    mapRemoveObject.put('ApexComponent' , 'ApexComponent');
    mapRemoveObject.put('ApexPage' , 'ApexPage');
    mapRemoveObject.put('ApexTrigger' , 'ApexTrigger');
    mapRemoveObject.put('ApprovalProcess' , 'ApprovalProcess');
    mapRemoveObject.put('AssignmentRule' , 'AssignmentRule');
    mapRemoveObject.put('AssignmentRules' , 'AssignmentRules');
    mapRemoveObject.put('AuthProvider' , 'AuthProvider');
    mapRemoveObject.put('AutoResponseRule' , 'AutoResponseRule');
    mapRemoveObject.put('AutoResponseRules' , 'AutoResponseRules');
    mapRemoveObject.put('BusinessProcess' , 'BusinessProcess');
    mapRemoveObject.put('CallCenter' , 'CallCenter');
    mapRemoveObject.put('CampaignCriteriaBasedSharingRule' , 'CampaignCriteriaBasedSharingRule');
    mapRemoveObject.put('CampaignOwnerSharingRule' , 'CampaignOwnerSharingRule');
    mapRemoveObject.put('CampaignSharingRules' , 'CampaignSharingRules');
    mapRemoveObject.put('CaseCriteriaBasedSharingRule' , 'CaseCriteriaBasedSharingRule');
    mapRemoveObject.put('CaseOwnerSharingRule' , 'CaseOwnerSharingRule');
    mapRemoveObject.put('CaseSharingRules' , 'CaseSharingRules');
    mapRemoveObject.put('Community' , 'Community');
    mapRemoveObject.put('CompactLayout' , 'CompactLayout');
    mapRemoveObject.put('ConnectedApp' , 'ConnectedApp');
    mapRemoveObject.put('ContactCriteriaBasedSharingRule' , 'ContactCriteriaBasedSharingRule');
    mapRemoveObject.put('ContactOwnerSharingRule' , 'ContactOwnerSharingRule');
    mapRemoveObject.put('ContactSharingRules' , 'ContactSharingRules');
    mapRemoveObject.put('CustomApplication' , 'CustomApplication');
    mapRemoveObject.put('CustomApplicationComponent' , 'CustomApplicationComponent');
    mapRemoveObject.put('CustomField' , 'CustomField');
    mapRemoveObject.put('CustomLabel' , 'CustomLabel');
    mapRemoveObject.put('CustomLabels' , 'CustomLabels');
    mapRemoveObject.put('CustomObject' , 'CustomObject');
    mapRemoveObject.put('CustomObjectCriteriaBasedSharingRule' , 'CustomObjectCriteriaBasedSharingRule');
    mapRemoveObject.put('CustomObjectOwnerSharingRule' , 'CustomObjectOwnerSharingRule');
    mapRemoveObject.put('CustomObjectSharingRules' , 'CustomObjectSharingRules');
    mapRemoveObject.put('CustomObjectTranslation' , 'CustomObjectTranslation');
    mapRemoveObject.put('CustomPageWebLink' , 'CustomPageWebLink');
    mapRemoveObject.put('CustomSite' , 'CustomSite');
    mapRemoveObject.put('CustomTab' , 'CustomTab');
    mapRemoveObject.put('Dashboard' , 'Dashboard');
    mapRemoveObject.put('DataCategoryGroup' , 'DataCategoryGroup');
    mapRemoveObject.put('Document' , 'Document');
    mapRemoveObject.put('EmailTemplate' , 'EmailTemplate');
    mapRemoveObject.put('EscalationRule' , 'EscalationRule');
    mapRemoveObject.put('EscalationRules' , 'EscalationRules');
    mapRemoveObject.put('FieldSet' , 'FieldSet');
    mapRemoveObject.put('FlexiPage' , 'FlexiPage');
    mapRemoveObject.put('Flow' , 'Flow');
    mapRemoveObject.put('Group' , 'Group');
    mapRemoveObject.put('HomePageComponent' , 'HomePageComponent');
    mapRemoveObject.put('HomePageLayout' , 'HomePageLayout');
    mapRemoveObject.put('InstalledPackage' , 'InstalledPackage');
    mapRemoveObject.put('Layout' , 'Layout');
    mapRemoveObject.put('LeadCriteriaBasedSharingRule' , 'LeadCriteriaBasedSharingRule');
    mapRemoveObject.put('LeadOwnerSharingRule' , 'LeadOwnerSharingRule');
    mapRemoveObject.put('LeadSharingRules' , 'LeadSharingRules');
    mapRemoveObject.put('Letterhead' , 'Letterhead');
    mapRemoveObject.put('ListView' , 'ListView');
    mapRemoveObject.put('NamedFilter' , 'NamedFilter');
    mapRemoveObject.put('OpportunityCriteriaBasedSharingRule' , 'OpportunityCriteriaBasedSharingRule');
    mapRemoveObject.put('OpportunityOwnerSharingRule' , 'OpportunityOwnerSharingRule');
    mapRemoveObject.put('OpportunitySharingRules' , 'OpportunitySharingRules');
    mapRemoveObject.put('PermissionSet' , 'PermissionSet');
    mapRemoveObject.put('PostTemplate' , 'PostTemplate');
    mapRemoveObject.put('Profile' , 'Profile');
    mapRemoveObject.put('Queue' , 'Queue');
    mapRemoveObject.put('QuickAction' , 'QuickAction');
    mapRemoveObject.put('RecordType' , 'RecordType');
    mapRemoveObject.put('RemoteSiteSetting' , 'RemoteSiteSetting');
    mapRemoveObject.put('Report' , 'Report');
    mapRemoveObject.put('ReportType' , 'ReportType');
    mapRemoveObject.put('Role' , 'Role');
    mapRemoveObject.put('SamlSsoConfig' , 'SamlSsoConfig');
    mapRemoveObject.put('Scontrol' , 'Scontrol');
    mapRemoveObject.put('Settings' , 'Settings');
    mapRemoveObject.put('SharingReason' , 'SharingReason');
    mapRemoveObject.put('StaticResource' , 'StaticResource');
    mapRemoveObject.put('SynonymDictionary' , 'SynonymDictionary');
    mapRemoveObject.put('UserCriteriaBasedSharingRule' , 'UserCriteriaBasedSharingRule');
    mapRemoveObject.put('UserMembershipSharingRule' , 'UserMembershipSharingRule');
    mapRemoveObject.put('UserSharingRules' , 'UserSharingRules');
    mapRemoveObject.put('ValidationRule' , 'ValidationRule');
    mapRemoveObject.put('WebLink' , 'WebLink');
    mapRemoveObject.put('Workflow' , 'Workflow');
    mapRemoveObject.put('WorkflowAlert' , 'WorkflowAlert');
    mapRemoveObject.put('WorkflowFieldUpdate' , 'WorkflowFieldUpdate');
    mapRemoveObject.put('WorkflowKnowledgePublish' , 'WorkflowKnowledgePublish');
    mapRemoveObject.put('WorkflowOutboundMessage' , 'WorkflowOutboundMessage');
    mapRemoveObject.put('WorkflowRule' , 'WorkflowRule');
    mapRemoveObject.put('WorkflowSend' , 'WorkflowSend');
    mapRemoveObject.put('WorkflowTask' , 'WorkflowTask');
    
    //Section 2
    mapRemoveObject.put('AcceptedEventRelation','Accepted Event Relation');    
    mapRemoveObject.put('AccountCleanInfo','Account Clean Info');
    mapRemoveObject.put('AccountContactRole','Account Contact Role');   
    mapRemoveObject.put('AccountHistory','Account History');
    mapRemoveObject.put('AccountShare','Account Share');
    mapRemoveObject.put('ActivityHistory','Activity History');  
    mapRemoveObject.put('ApexLog','Apex Debug Log');
    mapRemoveObject.put('AsyncApexJob','Apex Job');
    mapRemoveObject.put('ApexTestQueueItem','Apex Test Queue Item');
    mapRemoveObject.put('ApexTestResult','Apex Test Result');
    mapRemoveObject.put('AppMenuItem','AppMenuItem');
    mapRemoveObject.put('Approval','Approval');
    mapRemoveObject.put('ProcessInstanceWorkitem','Approval Request');  
    mapRemoveObject.put('Attachment','Attachment');
    mapRemoveObject.put('AuthSession','Auth Session');
    mapRemoveObject.put('BusinessHours','Business Hours');  
    mapRemoveObject.put('CampaignShare','Campaign Share');  
    mapRemoveObject.put('CaseShare','Case Share');  
    mapRemoveObject.put('ChatterActivity','Chatter Activity');
    mapRemoveObject.put('ChatterConversationMember','Chatter Conversation Member'); 
    mapRemoveObject.put('ClientBrowser','Client Browser');
    mapRemoveObject.put('WorkCoachingShare','Coaching Share');  
    mapRemoveObject.put('ContactShare','Contact Share');
    mapRemoveObject.put('CronJobDetail','Cron Job');
    mapRemoveObject.put('CustomObjectUserLicenseMetrics','Custom Object Usage By User License Metric');
    mapRemoveObject.put('CustomPermission','Custom Permission');
    mapRemoveObject.put('DomainSite','Custom URL');
    mapRemoveObject.put('DatacloudPurchaseUsage','Data.com Usage');
    mapRemoveObject.put('Domain','Domain');
    mapRemoveObject.put('EmailServicesFunction','Email Service');
    mapRemoveObject.put('EmailServicesAddress','Email Services Address');
    mapRemoveObject.put('EmailStatus','Email Status');
    mapRemoveObject.put('EntitySubscription','Entity Subscription');    
    mapRemoveObject.put('WorkFeedbackRequestHistory','Feedback Request History');
    mapRemoveObject.put('WorkFeedbackRequestShare','Feedback Request Share');
    mapRemoveObject.put('WorkFeedbackShare','Feedback Share');  
    mapRemoveObject.put('FieldPermissions','Field Permissions');
    mapRemoveObject.put('FiscalYearSettings','Fiscal Year Settings');
    mapRemoveObject.put('ForecastShare','Forecast Share');      
    mapRemoveObject.put('WorkGoalHistory','Goal History');  
    mapRemoveObject.put('WorkGoalShare','Goal Share');  
    mapRemoveObject.put('CollaborationGroupMemberRequest','Group Member Request');
    mapRemoveObject.put('HashtagDefinition','Hashtag Definition');  
    mapRemoveObject.put('InstalledMobileApp','Installed Mobile App');   
    mapRemoveObject.put('LeadHistory','Lead History');
    mapRemoveObject.put('LeadShare','Lead Share');  
    mapRemoveObject.put('LoginHistory','Login History');
    mapRemoveObject.put('LoginIp','Login IP');
    mapRemoveObject.put('MailmergeTemplate','Mail Merge Template');
    mapRemoveObject.put('MobileDeviceRegistrar','Mobile Device Registrar'); 
    mapRemoveObject.put('ObjectPermissions','Object Permissions');  
    mapRemoveObject.put('OpportunityFieldHistory','Opportunity Field History');
    mapRemoveObject.put('OpportunityHistory','Opportunity History');
    mapRemoveObject.put('OpportunityPartner','Opportunity Partner');
    mapRemoveObject.put('OpportunityShare','Opportunity Share');    
    mapRemoveObject.put('OrderHistory','Order History');
    mapRemoveObject.put('OrderItem','Order Product');       
    mapRemoveObject.put('WorkPerformanceCycleShare','Performance Cycle Share');
    mapRemoveObject.put('WorkPerformanceCycleHistory','Performance Summary Cycle History'); 
    mapRemoveObject.put('PermissionSetAssignment','Permission Set Assignment');
    mapRemoveObject.put('PermissionSetLicense','Permission Set License');
    mapRemoveObject.put('PermissionSetLicenseAssign','Permission Set License Assignment');
    mapRemoveObject.put('CaseTeamTemplateMember','Predefined Case Team Member');
    mapRemoveObject.put('CaseTeamTemplateRecord','Predefined Case Team Record');    
    mapRemoveObject.put('Pricebook2History','Price Book History');  
    mapRemoveObject.put('ProcessInstanceHistory','Process Instance History');   
    mapRemoveObject.put('PushTopic','Push Topic');
    mapRemoveObject.put('QueueSobject','Queue Sobject');
    mapRemoveObject.put('RecentlyViewed','Recently Viewed');    
    mapRemoveObject.put('CronTrigger','Scheduled Jobs');
    mapRemoveObject.put('SetupEntityAccess','Setup Entity Access');
    mapRemoveObject.put('Site','Site');
    mapRemoveObject.put('SiteFeed','Site');
    mapRemoveObject.put('SiteHistory','Site History');  
    mapRemoveObject.put('SolutionHistory','Solution History');  
    mapRemoveObject.put('TenantUsageEntitlement','Tenant Usage Entitlement');
    mapRemoveObject.put('UserFeed','User Feed');
    mapRemoveObject.put('UserLicense','User License');
    mapRemoveObject.put('UserLogin','User Login');
    mapRemoveObject.put('OwnedContentDocument','User Owned File');
    mapRemoveObject.put('UserPackageLicense','User Package License');   
    mapRemoveObject.put('UserRecordAccess','User Record Access');
    mapRemoveObject.put('UserShare','User Share');
    mapRemoveObject.put('AggregateResult','Aggregate Result');
    mapRemoveObject.put('CaseHistory','Case History');
    mapRemoveObject.put('AttachedContentDocument','Attached Content Document');
    mapRemoveObject.put('ContactHistory','Contact History');
    mapRemoveObject.put('ContactCleanInfo','Contact Clean Info');
    mapRemoveObject.put('ContentDocumentHistory','Content Document History');
    mapRemoveObject.put('ContentVersionHistory','Content Version History');
    mapRemoveObject.put('ContentDocumentLink','Content Document Link');
    mapRemoveObject.put('ContractHistory','Contract History');
    mapRemoveObject.put('DocumentAttachmentMap','Document Entity Map');
    mapRemoveObject.put('FeedTrackedChange','Feed Tracked Change');
    mapRemoveObject.put('WorkGoalCollaboratorHistory','Goal Collaborator History');
    mapRemoveObject.put('CombinedAttachment','Note, Attachment, Google Doc And File');
    mapRemoveObject.put('OrderItemHistory','Order Product History');
    mapRemoveObject.put('OrgWideEmailAddress','Organization-wide From Email Address');
    mapRemoveObject.put('WorkPerformanceCycleFeed','Performance Cycle Feed');
    
    //Section 3
        mapRemoveObject.put('AccountFeed','Account Feed');
        mapRemoveObject.put('AccountPartner','Account Partner');
        mapRemoveObject.put('AdditionalNumber','Additional Directory Number');
        mapRemoveObject.put('Announcement','Announcement');
        mapRemoveObject.put('Asset','Asset');
        mapRemoveObject.put('AssetFeed','Asset Feed');
        mapRemoveObject.put('CampaignFeed','Campaign Feed');
        mapRemoveObject.put('CampaignMember','Campaign Member');
        mapRemoveObject.put('CampaignMemberStatus','Campaign Member Status');   
        mapRemoveObject.put('CaseComment','Case Comment');
        mapRemoveObject.put('CaseContactRole','Case Contact Role');
        mapRemoveObject.put('CaseFeed','Case Feed');
        mapRemoveObject.put('CaseSolution','Case Solution');
        mapRemoveObject.put('CaseStatus','Case Status Value');
        mapRemoveObject.put('CaseTeamMember','Case Team Member');
        mapRemoveObject.put('CaseTeamRole','Case Team Member Role');
        mapRemoveObject.put('CategoryData','Category Data');
        mapRemoveObject.put('CategoryNode','Category Node');
        mapRemoveObject.put('ChatterConversation','Chatter Conversation');
        mapRemoveObject.put('CollaborationInvitation','Chatter Invitation');
        mapRemoveObject.put('ChatterMessage','Chatter Message');
        mapRemoveObject.put('WorkCoachingHistory','Coaching');
        mapRemoveObject.put('WorkCoaching','Coaching');
        mapRemoveObject.put('WorkCoachingFeed','Coaching Feed');
        mapRemoveObject.put('ContactFeed','Contact Feed');
        mapRemoveObject.put('ContentDocument','Content');
        mapRemoveObject.put('ContentVersion','Content');
        mapRemoveObject.put('ContentDocumentFeed','ContentDocument Feed');
        mapRemoveObject.put('Contract','Contract');
        mapRemoveObject.put('ContractContactRole','Contract Contact Role');
        mapRemoveObject.put('ContractFeed','Contract Feed');
        mapRemoveObject.put('ContractStatus','Contract Status Value');
        mapRemoveObject.put('DandBCompany','D&amp;B Company');
        mapRemoveObject.put('DatacloudDandBCompany','D&amp;B Company');
        mapRemoveObject.put('DashboardComponent','Dashboard Component');
        mapRemoveObject.put('DashboardComponentFeed','Dashboard Component Feed');
        mapRemoveObject.put('DashboardFeed','Dashboard Feed');
        mapRemoveObject.put('DatacloudCompany','Data.com Company');
        mapRemoveObject.put('DatacloudContact','Data.com Contact');
        mapRemoveObject.put('DatacloudOwnedEntity','Data.com Owned Entity');
        mapRemoveObject.put('DatacloudSocialHandle','Data.com Social Handle');
        mapRemoveObject.put('DeclinedEventRelation','Declined Event Relation'); 
        mapRemoveObject.put('EventFeed','Event Feed');
        mapRemoveObject.put('EventRelation','Event Relation');
        mapRemoveObject.put('WorkFeedback','Feedback');
        mapRemoveObject.put('WorkFeedbackQuestionHistory','Feedback Question');
        mapRemoveObject.put('WorkFeedbackQuestion','Feedback Question');
        mapRemoveObject.put('WorkFeedbackQuestionSet','Feedback Question Set');
        mapRemoveObject.put('WorkFeedbackQuestionSetShare','Feedback Question Set Share');
        mapRemoveObject.put('WorkFeedbackQuestionShare','Feedback Question Share');
        mapRemoveObject.put('WorkFeedbackRequest','Feedback Request');
        mapRemoveObject.put('FeedComment','Feed Comment');
        mapRemoveObject.put('FeedItem','Feed Item');
        mapRemoveObject.put('FeedLike','Feed Like');
        mapRemoveObject.put('FeedPollChoice','Feed Poll Choice');
        mapRemoveObject.put('FeedPollVote','Feed Poll Vote');
        mapRemoveObject.put('Folder','Folder');
        mapRemoveObject.put('WorkGoal','Goal');
        mapRemoveObject.put('WorkGoalCollaborator','Goal Collaborator');
        mapRemoveObject.put('WorkGoalFeed','Goal Feed');
        mapRemoveObject.put('WorkGoalLink','Goal Link');
        mapRemoveObject.put('CollaborationGroup','Group');
        mapRemoveObject.put('CollaborationGroupFeed','Group Feed');
        mapRemoveObject.put('GroupMember','Group Member');
        mapRemoveObject.put('CollaborationGroupMember','Group Member');
        mapRemoveObject.put('Holiday','Holiday');
        mapRemoveObject.put('Idea','Idea');
        mapRemoveObject.put('IdeaComment','Idea Comment');
        mapRemoveObject.put('InteractionInterview','Interaction Interview');
        mapRemoveObject.put('KnowledgeableUser','Knowledgeable User');
        mapRemoveObject.put('LeadCleanInfo','Lead Clean Info');
        mapRemoveObject.put('LeadFeed','Lead Feed');
        mapRemoveObject.put('LeadStatus','Lead Status Value');
        mapRemoveObject.put('BrandTemplate','Letterhead');
        mapRemoveObject.put('ContentWorkspace','Library');
        mapRemoveObject.put('ContentWorkspaceDoc','Library Document');
        mapRemoveObject.put('Name','Name');
        mapRemoveObject.put('Note','Note');
        mapRemoveObject.put('NoteAndAttachment','Note and Attachment');
        mapRemoveObject.put('OpenActivity','Open Activity');
        mapRemoveObject.put('OpportunityCompetitor','Opportunity: Competitor');
        mapRemoveObject.put('OpportunityContactRole','Opportunity Contact Role');
        mapRemoveObject.put('OpportunityFeed','Opportunity Feed');
        mapRemoveObject.put('OpportunityLineItem','Opportunity Product');
        mapRemoveObject.put('OpportunityStage','Opportunity Stage');
        mapRemoveObject.put('Order','Order');
        mapRemoveObject.put('OrderFeed','Order Feed');
        mapRemoveObject.put('OrderItemFeed','Order Product Feed');
        mapRemoveObject.put('Organization','Organization');
        mapRemoveObject.put('PackageLicense','Package License');
        mapRemoveObject.put('Partner','Partner');
        mapRemoveObject.put('PartnerRole','Partner Role Value');
        mapRemoveObject.put('WorkPerformanceCycle','Performance Cycle');
        mapRemoveObject.put('Period','Period');
        mapRemoveObject.put('CaseTeamTemplate','Predefined Case Team');
        mapRemoveObject.put('Pricebook2','Price Book');
        mapRemoveObject.put('PricebookEntry','Price Book Entry');
        mapRemoveObject.put('ProcessDefinition','Process Definition');
        mapRemoveObject.put('ProcessInstance','Process Instance');
        mapRemoveObject.put('ProcessInstanceNode','Process Instance Node');
        mapRemoveObject.put('ProcessInstanceStep','Process Instance Step');
        mapRemoveObject.put('ProcessNode','Process Node');
        mapRemoveObject.put('Product2Feed','Product Feed');
        mapRemoveObject.put('TopicAssignment','Record');
        mapRemoveObject.put('ReportFeed','Report Feed');
        mapRemoveObject.put('UserRole','Role');
        mapRemoveObject.put('Solution','Solution');
        mapRemoveObject.put('SolutionFeed','Solution Feed');
        mapRemoveObject.put('SolutionStatus','Solution Status Value');
        mapRemoveObject.put('TaskFeed','Task Feed');
        mapRemoveObject.put('TaskPriority','Task Priority Value');
        mapRemoveObject.put('TaskStatus','Task Status Value');  
        mapRemoveObject.put('Topic','Topic');
        mapRemoveObject.put('TopicFeed','Topic Feed');
        mapRemoveObject.put('UndecidedEventRelation','Undecided Event Relation');
        mapRemoveObject.put('User','User');
        mapRemoveObject.put('UserPreference','User Preference');
        mapRemoveObject.put('UserProfile','User Profile');
        mapRemoveObject.put('Vote','Vote');
        mapRemoveObject.put('Timeline_Setting__c','Timeline Setting');        
        
    
    
    
    return mapRemoveObject ;
    
}    
}