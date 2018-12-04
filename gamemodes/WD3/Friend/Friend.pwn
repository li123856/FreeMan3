#include WD3/Friend/Friend_Define.pwn
#include WD3/Friend/Friend_Custom.pwn

public OnGameModeInit()
{
	Iter_Init(friends);
	return CallLocalFunction("Friend_OnGameModeInit", "");
}
#if defined _ALS_OnGameModeInit
   #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Friend_OnGameModeInit
forward Friend_OnGameModeInit();

ACT::LoadPlayerFriends(playerid)
{
	format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_FRIEND"` WHERE `uid` = '%i' LIMIT 1",pdate[playerid][uid]);
    mysql_tquery(mysqlid, Querys, "OnPlayerFriendsLoad", "i", playerid);
	return 1;
}
ACT::OnPlayerFriendsLoad(playerid)
{
	new string[80],str[512],friendid,friendlys,fshows;
	for(new i=0;i<MAX_PLAYER_FRIENDS;i++)
	{
	    format(string, sizeof(string),"slot_%i",i);
	    cache_get_field_content(0,string,str,mysqlid,1024);
	    sscanf(str, "p<&>iii",friendid,fshows,friendlys);
	    if(friendid!=-1)
	    {
			friends[playerid][i][fuid]=friendid;
			friends[playerid][i][fshow]=fshows;
			friends[playerid][i][friendly]=friendlys;
	        Iter_Add(friends[playerid],i);
	    }
	}
	return 1;
}

ACT::ShowMyFriends(playerid,pages)
{
	if(!Iter_Count(friends[playerid]))return SendClientMessage(playerid,COLOR_WARNING,"没有好友");
    current_number[playerid]=1;
  	foreach(new i:friends[playerid])
	{
        current_idx[playerid][current_number[playerid]]=i;
        current_number[playerid]++;
	}
	if(pages==0)
	{
		page[playerid]=1;
		SendClientMessage(playerid,COLOR_WARNING,"没有上一页");
	}
	else page[playerid]=pages;
	if(pages>floatround(Iter_Count(friends[playerid])/float(MAX_DILOG_LIST),floatround_ceil))
	{
		SendClientMessage(playerid,COLOR_WARNING,"没有该页");
		page[playerid]=1;
	}
	new string[60];
	format(string,sizeof(string),"我的好友-共计[%i],{00FF00}黄色:在线,{33AA33}绿色:离线",current_number[playerid]-1);
	Dialog_Show(playerid,dl_myfriends,DIALOG_STYLE_TABLIST_HEADERS,string,Dialog_MyFriends_RetrunStr(playerid,page[playerid]), "使用", "返回");
	return 1;
}
Dialog_MyFriends_RetrunStr(playerid,pager)
{
    new string[2048],caption[64];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	format(caption,sizeof(caption), "UID\t名字\t友好度\t主显\n");
	strcat(string,caption);
	strcat(string,"{FF8000}上一页\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST; i++)
	{
	    new tmp[384],tmps[128];
		if(i<current_number[playerid])
		{
		    if(IsUidLogin(friends[playerid][current_idx[playerid][i]][fuid])!=-1)
		    {
	            format(tmps,sizeof(tmps),"{00FF00}%i\t",friends[playerid][current_idx[playerid][i]][fuid]);
	            strcat(tmp,tmps);
	            format(tmps,sizeof(tmps),"{00FF00}%s\t",GetUidName(friends[playerid][current_idx[playerid][i]][fuid]));
	            strcat(tmp,tmps);
	            format(tmps,sizeof(tmps),"{00FF00}%i\t",friends[playerid][current_idx[playerid][i]][friendly]);
	            strcat(tmp,tmps);
	            if(friends[playerid][current_idx[playerid][i]][fshow])format(tmps,sizeof(tmps),"{00FF00}√\n");
	            else format(tmps,sizeof(tmps),"{00FF00}×\n");
	            strcat(tmp,tmps);
            }
            else
            {
	            format(tmps,sizeof(tmps),"{33AA33}%i\t",friends[playerid][current_idx[playerid][i]][fuid]);
	            strcat(tmp,tmps);
	            format(tmps,sizeof(tmps),"{33AA33}%s\t",GetUidName(friends[playerid][current_idx[playerid][i]][fuid]));
	            strcat(tmp,tmps);
	            format(tmps,sizeof(tmps),"{33AA33}%i\t",friends[playerid][current_idx[playerid][i]][friendly]);
	            strcat(tmp,tmps);
	            if(friends[playerid][current_idx[playerid][i]][fshow])format(tmps,sizeof(tmps),"{33AA33}√\n");
	            else format(tmps,sizeof(tmps),"{33AA33}×\n");
	            strcat(tmp,tmps);
            }
		}
	    if(i>=current_number[playerid])
		{
			isover=1;
			break;
		}
	    else strcat(string,tmp);
	}
	if(!isover)strcat(string, "{FF8000}下一页\n");
    return string;
}
Dialog:dl_myfriends(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowMyFriends(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowMyFriends(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
			new caption[100];
			format(caption,sizeof(caption), "好友 %s 操作",GetUidName(friends[playerid][listid][fuid]));
			Dialog_Show(playerid,dl_myfriend_doing,DIALOG_STYLE_TABLIST,caption,"发送邮件\t\n好友互动\t$100\n好友主显\t$100\n删除好友\t", "确定", "返回");
            SetPVarInt(playerid,"Friend_Current_ID",listid);
		}
	}
	else
	{

	}
	return 1;
}
Dialog:dl_myfriend_doing(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"Friend_Current_ID");
		switch(listitem)
		{
		    case 0:
		    {
		    
		    }
		    case 1:
		    {
		        if(IsUidLogin(friends[playerid][listid][fuid])==-1)return SendClientMessage(playerid,COLOR_WARNING,"对方没有在线");
		        if(pdate[playerid][cash]<100)return SendClientMessage(playerid,COLOR_WARNING,"你的现金没有$100");
		        GiveCash(playerid,-100);
		    }
		    case 2:
		    {
		        if(pdate[playerid][cash]<100)return SendClientMessage(playerid,COLOR_WARNING,"你的现金没有$100");
				foreach(new x:friends[playerid])
    			{
       				if(friends[playerid][x][fuid]==friends[playerid][listid][fuid])
        			{
        			    friends[playerid][x][fshow]=1;
        			    new strs[100];
            			format(strs, sizeof(strs),"%s 的好友",GetUidName(friends[playerid][x][fuid]));
        				UpdateDynamic3DTextLabelText(ftag[playerid],-1,strs);
        				UpdatePlayerFriendDate(playerid,x);
        			}
        			else
        			{
        			    if(friends[playerid][x][fshow])
        			    {
        			        friends[playerid][x][fshow]=0;
        			        UpdatePlayerFriendDate(playerid,x);
        			    }
        			}
        			GiveCash(playerid,-100);
        		}
		    }
		    case 3:
		    {
		        foreach(new x:friends[playerid])
    			{
    			    if(friends[playerid][x][fuid]==friends[playerid][listid][fuid])
        			{
        			    if(friends[playerid][x][fshow])UpdateDynamic3DTextLabelText(ftag[playerid],-1," ");
        			}
    			}
    			friends[playerid][listid][fuid]=-1;
    			friends[playerid][listid][fshow]=0;
    			friends[playerid][listid][friendly]=0;
    			UpdatePlayerFriendDate(playerid,listid);
    			Iter_Remove(friends[playerid],listid);
		    }
		}
	}
	return 1;
}
	
ACT::FriendAdd(playerid,friendindex)
{
    new i1=Iter_Free(friends[playerid]);
    if(i1==-1)return 2;
    friends[playerid][i1][fuid]=pdate[friendindex][uid];
    friends[playerid][i1][fshow]=0;
    friends[playerid][i1][friendly]=0;
    Iter_Add(friends[playerid],i1);
    UpdatePlayerFriendDate(playerid,i1);
    
    new i2=Iter_Free(friends[friendindex]);
    if(i2==-1)return 1;
    friends[friendindex][i2][fuid]=pdate[playerid][uid];
    friends[friendindex][i2][fshow]=0;
    friends[friendindex][i2][friendly]=0;
    Iter_Add(friends[friendindex],i2);
    UpdatePlayerFriendDate(friendindex,i2);
	return 0;
}

ACT::UpdatePlayerTags(playerid)
{
	foreach(new x:friends[playerid])
    {
        if(friends[playerid][x][fshow])
        {
            new strs[100];
            format(strs, sizeof(strs),"%s 的好友",GetUidName(friends[playerid][x][fuid]));
        	UpdateDynamic3DTextLabelText(ftag[playerid],-1,strs);
        }
    }
	return 1;
}
ACT::UpdatePlayerFriendDate(playerid,index)
{
	new string[64],str[512];
 	format(string, sizeof(string),"slot_%i",index);
	format(str, sizeof(str),"%i&%i&%i",friends[playerid][index][fuid],friends[playerid][index][fshow],friends[playerid][index][friendly]);
 	format(Querys, sizeof(Querys),"UPDATE `"SQL_FRIEND"` SET  `%s` =  '%s' WHERE  `"SQL_FRIEND"`.`uid` ='%i'",string,str,pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
public OnPlayerConnect(playerid)
{
    Iter_Clear(friends[playerid]);
    ftag[playerid]=CreateDynamic3DTextLabel(" ",-1,0.0,0.0,0.5,10,playerid);
	return CallLocalFunction("Friend_OnPlayerConnect", "i",playerid);
}
#if defined _ALS_OnPlayerConnect
   #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Friend_OnPlayerConnect
forward Friend_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
	Iter_Clear(friends[playerid]);
	DestroyDynamic3DTextLabel(ftag[playerid]);
	return CallLocalFunction("Friend_OnPlayerDisconnect", "ii",playerid,reason);
}
#if defined _ALS_OnPlayerDisconnect
   #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Friend_OnPlayerDisconnect
forward Friend_OnPlayerDisconnect(playerid,reason);

#include WD3/Friend/Friend_Cmd.pwn

