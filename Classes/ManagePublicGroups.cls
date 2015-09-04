/* **************************************************************************
* Class: ManagePublicGroups
* Created by {developerName},  {dateCreated 03/26/2013}
*
* Purpose/Methods:
* -  It is allow user to add into Group.

* Unit Test: 
************************************************************************** */
Public Class ManagePublicGroups{

    public PageReference removeFromUsers() {
        return null;
    }

    Public GroupMember objGroupMember;
    Public String strGroups;
    Public Boolean blnSelectoption {get;set;}
    
    Public List<User> lstUsers {get;set;}
    Public List<Group> lstGroups {get;set;}
    
    Public Id idOfSelectedUser {get;set;}
    Public Id idOfSelectedGroup {get;set;}
    
    Public List<SelectOption> lstOfGroup{get;set;}
    Public List<SelectOption> lstOfUser{get;set;}
    
    Public List<SelectOption> lstSelectedGroup{get;set;}
    Public List<SelectOption> lstSelectedToAddGroup{get;set;}
    
    Public List<SelectOption> lstSelectedUser{get;set;}
    Public List<SelectOption> lstSelectedToAddUser{get;set;}
    
    Public String strSelectedGroup{get;set;}
    Public String strSelectedToAddGroup{get;set;}
    
    Public String strSelectedUser{get;set;}
    Public String strSelectedToAddUser{get;set;}
   
    Public User objUserSearch {get;set;}
    Public Group objGroupSearch {get;set;}
    
    Public String strUsernm {get;set;}
    Public String strGroupnm {get;set;}
    Public String strUserpSearchArea ='';
    Public String strGroupSearchArea = '';
    // -----------------------------------------------------------------------
    // Constructor Method
    // -----------------------------------------------------------------------
    Public ManagePublicGroups(){
    
        blnSelectoption = false;
        strGroups = 'User';
        
        lstUsers = [select ID,name from User order by name nulls last];
        lstGroups = [select ID,name from Group order by name nulls last ];
        
        lstOfGroup=New List<SelectOption>();
        
        for(Group objGroup: lstGroups ){
            if(objGroup.id != null && objGroup.name != '' && objGroup.name != null){ 
                lstOfGroup.Add(New SelectOption(objGroup.Id,objGroup.name));            
            }
        }  
        
        lstOfUser=New List<SelectOption>();
       
        for(User objUser: lstUsers){
            if(objUser.id != null && objUser.name != '' && objUser.name != null){ 
                lstOfUser.Add(New SelectOption(objUser.Id,objUser.name));            
            }
        }  
        
        lstSelectedGroup = New List<SelectOption>();
        lstSelectedToAddGroup = New List<SelectOption>();
        lstSelectedUser = New List<SelectOption>();
        lstSelectedToAddUser = New List<SelectOption>();
       
        if(Apexpages.currentPage().getParameters().get('praGroupId')==null){
            idOfSelectedUser =lstUsers[0].id;
            selectGroupOnUser();
        
        }
        if(Apexpages.currentPage().getParameters().get('praGroupId')==null){
            idOfSelectedGroup = lstGroups[0].id;
            selectUserOnGroup();
        }
          
        //objUserSearch = [select ID,name from User order by name nulls last limit 1];
        objUserSearch = new User();
        objGroupSearch = new Group();
       
    }
    
    Public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('User','User'));
        options.add(new SelectOption('Groups','Groups'));
            return options;
    }
    
    Public String getstrGroups() {
        return strGroups;
    }
    
    Public void setstrGroups(String strGroups) { this.strGroups= strGroups; }
    
    
    Public void loadUserOnclick(){
        /*lstUsers = [select ID,name from User order by name nulls last];
        lstGroups = [select ID,name from Group order by name nulls last];
        */
        if(strGroups == 'Groups'){
            blnSelectoption = true;
        }else{
            blnSelectoption = false;
        }
        
    }
    
    Public void selectGroupOnUser(){
        if(Apexpages.currentPage().getParameters().get('praUserId') != null){
            idOfSelectedUser = Apexpages.currentPage().getParameters().get('praUserId');
        }
        //idOfSelectedUser = Apexpages.currentPage().getParameters().get('praUserId');
        system.debug('idOfSelectedUser :'+idOfSelectedUser);
        system.debug('strGroupSearchArea:'+strGroupSearchArea);
        
        list<GroupMember> lstGroupOfUser = new list<GroupMember> ();
        if(idOfSelectedUser != null){
            lstGroupOfUser = [ select id, GroupId, UserOrGroupId from GroupMember
                                                where UserOrGroupId =: idOfSelectedUser ];
        }
        
        set<Id> setOfGroupId = new set<Id>();
        for(GroupMember objGroup : lstGroupOfUser){
            if(objGroup.GroupId != null){
                setOfGroupId.add(objGroup.GroupId);
            }
        }  
       
        list<Group> lstGroupTemp = new list<Group>();
        lstGroupTemp = [ select id, name from Group where id In : setOfGroupId ]; 
       
        system.debug('lstGroupTemp:'+lstGroupTemp);
        //list<Group> lstGroupTemp = [ select id, name from Group where id In : setOfGroupId]; 
        lstSelectedToAddGroup = new List<SelectOption>();
        if(lstGroupTemp.size() > 0){
            for(Group objGroup : lstGroupTemp){
                if(objGroup.id != null && objGroup.name != null && objGroup.name != ''){
                    lstSelectedToAddGroup.Add(New SelectOption(objGroup.id,objGroup.name));            
                }
            }
        }
        system.debug('lstSelectedToAddGroup:'+lstSelectedToAddGroup);
        //Remove from existing
        List<Group> lstGroupTemp1 = new List<Group> ();
        lstGroupTemp1 = [Select Id,Name From Group where id NOT In : setOfGroupId Order By name nulls last limit 50000 ];
       
        system.debug('lstGroupTemp1:'+lstGroupTemp1);
        //List<Group> lstGroupTemp1 = [Select Id,Name From Group where id NOT In : setOfGroupId Order By name nulls last limit 200 ];
        lstSelectedGroup = new List<SelectOption>();
        
        for(Group objGroup: lstGroupTemp1 ){
            if(objGroup.id != null && objGroup.name != '' && objGroup.name != null){ 
                lstSelectedGroup.Add(New SelectOption(objGroup.Id,objGroup.name));            
            }
        } 
        system.debug('lstSelectedGroup:'+lstSelectedGroup);
       
    }
    
    Public void selectUserOnGroup(){
        if(Apexpages.currentPage().getParameters().get('praGroupId')!=null){
            idOfSelectedGroup = Apexpages.currentPage().getParameters().get('praGroupId');
        }
        system.debug('strGroupSearchArea2:'+strGroupSearchArea);
        system.debug('idOfSelectedGroup:'+idOfSelectedGroup);
        
        list<GroupMember> lstUserInGroup = [ select id, GroupId, UserOrGroupId from GroupMember
                                                where GroupId =: idOfSelectedGroup and UserOrGroupId != null];
        set<Id> setOfUserId = new set<Id>();
        for(GroupMember objUser: lstUserInGroup){
            if(objUser.UserOrGroupId != null){
                setOfUserId.add(objUser.UserOrGroupId);
            }
        }  
        //Add to SelectedList 
        lstSelectedToAddUser = new List<SelectOption>();
        list<User> lstUserTemp = [ select id, name from User where id In : setOfUserId]; 
        if(lstUserTemp.size() > 0){
            for(User objUser : lstUserTemp){
                lstSelectedToAddUser.Add(New SelectOption(objUser.id,objUser.name));            
            }
        }
        //Remove from existing
        List<User> lstGroupTempToMain = [Select Id,Name From User where id NOT In : setOfUserId Order By name nulls last limit 50000 ];
        lstSelectedUser = new List<SelectOption>();
        
        //Where Id NOT IN:setOfGroupIds
        for(User objUser: lstGroupTempToMain ){
            if(objUser.id != null && objUser.name != '' && objUser.name != null){ 
                lstSelectedUser.Add(New SelectOption(objUser.Id,objUser.name));            
            }
        } 
        
    }
    
    // -----------------------------------------------------------------------
    // addToGroups Method
    //   Add Users to Groups
    // -----------------------------------------------------------------------
    Public PageReference addToGroups(){
    
        List<GroupMember> lstGroupMemberTemp = new List<GroupMember>();
        objGroupMember = new GroupMember();
        Integer Index = 0;    
        set<Id> setOfId = new set<ID>();
        List<SelectOption> lstAddTemp = New List<SelectOption>();
        lstAddTemp.AddAll(lstSelectedGroup);
        system.debug('lstAddTemp:'+lstAddTemp);
        
        //if(idOfSelectedUser != null && idOfSelectedUser != ''){
            system.debug('idOfSelectedUser:'+idOfSelectedUser);
        try{
            For(SelectOption objAdd: lstAddTemp){                
                system.debug('objAdd:'+objAdd);
                system.debug('strSelectedGroup:'+strSelectedGroup);
                
                If(strSelectedGroup.contains(objAdd.getvalue().Trim()) == true){ 
                    objGroupMember = new GroupMember();
                    objGroupMember.GroupId = objAdd.getvalue();   
                    objGroupMember.UserOrGroupId = idOfSelectedUser;
                    lstGroupMemberTemp.add(objGroupMember);            
                    lstSelectedGroup.remove(Index);
                    lstSelectedToAddGroup.Add(New selectOption(objAdd.getvalue(),objAdd.getlabel()));                 
                    
                }Else{
                    Index++;
                }
            }
            system.debug('lstGroupMemberTemp:'+lstGroupMemberTemp);
            if(lstGroupMemberTemp.size() > 0) upsert lstGroupMemberTemp;
            
            } Catch(exception exc){
                /*ApexPages.Message myMsg;
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error:'+exc);  
                ApexPages.addMessage(myMsg);*/
                return null;
            }
        //}
        return null;
      
    }
    
    // -----------------------------------------------------------------------
    // addToGroups Method
    //  Remove Users From Groups
    // -----------------------------------------------------------------------
    Public void removeFromGroups(){
        Integer Index = 0;            
        List<SelectOption> lstAddTemp = New List<SelectOption>();
        set<Id> idToDelete = new set<Id>();
        lstAddTemp.AddAll(lstSelectedToAddGroup);
        system.debug('lstSelectedToAddGroup(Remove):'+lstSelectedToAddGroup);
        
        For(SelectOption objadd: lstAddTemp){
            If(strSelectedToAddGroup.contains(objadd.getvalue().Trim()) == true){
                idToDelete.Add(objadd.getvalue());                
                lstSelectedToAddGroup.remove(Index);
                lstSelectedGroup.Add(New selectOption(objadd.getvalue(),objadd.getlabel()));                 
            }Else{
                Index++;
            }
        }
       
        List<GroupMember> lstGroupMemberToDelete = [Select Id,GroupId,UserOrGroupId from GroupMember Where 
                GroupId In : idToDelete and UserOrGroupId =: idOfSelectedUser];
        system.debug('lstGroupMemberToDelete:'+lstGroupMemberToDelete);        
        if(lstGroupMemberToDelete.size()>0) Delete lstGroupMemberToDelete;
    }
     // -----------------------------------------------------------------------
    // addToUsers Method
    //  
    // -----------------------------------------------------------------------
    Public PageReference addToUsers(){
        List<GroupMember> lstGroupMemberTemp = new List<GroupMember>();
        objGroupMember = new GroupMember();
        Integer Index = 0;    
        List<SelectOption> lstAddTemp = New List<SelectOption>();
        lstAddTemp.AddAll(lstSelectedUser);
        system.debug('idOfSelectedGroup:'+idOfSelectedGroup);
       try{
        //if(idOfSelectedGroup != null && idOfSelectedGroup != ''){
            For(SelectOption objAdd: lstAddTemp){
                If(strSelectedUser.contains(objAdd.getvalue().Trim()) == true){                
                    system.debug('objAdd.getvalue():'+objAdd.getvalue());
                    system.debug('idOfSelectedGroup:'+idOfSelectedGroup);
                    
                    objGroupMember = new GroupMember();
                    objGroupMember.GroupId = idOfSelectedGroup;   
                    objGroupMember.UserOrGroupId = objAdd.getvalue();
                    lstGroupMemberTemp.add(objGroupMember);  
                    
                    lstSelectedUser.remove(Index);
                    lstSelectedToAddUser.Add(New selectOption(objAdd.getvalue(),objAdd.getlabel()));                 
                   
                }Else{
                    Index++;
                }
            }
            if(lstGroupMemberTemp.size() > 0) upsert lstGroupMemberTemp;
            } Catch(exception exc){
                /*ApexPages.Message myMsg;
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error:'+exc);  
                ApexPages.addMessage(myMsg);*/
                return null;
            }
        //}
       return null;
    }
}