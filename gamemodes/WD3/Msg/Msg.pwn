#include WD3/Msg/Msg_Define.pwn
#include WD3/Msg/Msg_Custom.pwn
ACT::PlayerSendMsgToPlayer(playerid,uidid,sendstr[],money)
{
	if(IsUidFexist(uidid))
	{
		new time[3], date[3],string[80];
    	getdate(date[0],date[1],date[2]);
		gettime(time[0], time[1], time[2]);
		format(string,80, "%i/%i/%i-%i:%i:%i",date[0],date[1],date[2], time[0], time[1], time[2]);
		format(Querys, sizeof(Querys),"INSERT INTO `"SQL_MSG"`(`sendtime`,`uid`,`senderuid`,`sendername`,`sendstr`,`money`)VALUES ('%s','%i','%i','%s','%s','%i')",string,uidid,pdate[playerid][uid],Pname[playerid],sendstr,money);
		mysql_query(mysqlid,Querys,false);
	    new players=IsUidLogin(uidid);
	    if(players!=-1)
		{
			format(string,sizeof(string),"���յ�һ������ %s ������Ϣ,��/mail�鿴",Pname[playerid]);
			SendClientMessage(players,COLOR_SYSTEM,string);
		}
		else
		{
			format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_ACCOUNT"` WHERE `uid` = '%i' LIMIT 1",uidid);
			mysql_query(mysqlid,Querys,true);
			if(cache_get_field_content_int(0,"offlinnotice")&&cache_get_field_content_int(0,"verify"))
			{
	        	new stry[738],names[80],mailers[256],times[80];
	        	cache_get_field_content(0,"name",names,mysqlid,80);
	        	cache_get_field_content(0,"email",mailers,mysqlid,80);
	        	format(times,80, "%i/%i/%i-%i:%i:%i",date[0],date[1],date[2], time[0], time[1], time[2]);
            	format(stry,sizeof(stry),"����:%s<br/>����%s�յ�һ������%s������Ϣ:<br/>%s<br/>����:$%i",names,times,Pname[playerid],sendstr,money);
	    		SendNoticeMail(mailers,stry);
	    	}
		}
		return 1;
	}
	return 0;
}
ACT::SystemSendMsgToPlayer(uidid,sendstr[],money)
{
	if(IsUidFexist(uidid))
	{
		new time[3], date[3],string[80];
	    getdate(date[0],date[1],date[2]);
		gettime(time[0], time[1], time[2]);
		format(string,80, "%i/%i/%i-%i:%i:%i",date[0],date[1],date[2], time[0], time[1], time[2]);
		format(Querys, sizeof(Querys),"INSERT INTO `"SQL_MSG"`(`sendtime`,`uid`,`senderuid`,`sendername`,`sendstr`,`money`)VALUES ('%s','%i','%i','%s','%s','%i')",string,uidid,-1,SYSTEM_MSG,sendstr,money);
		mysql_query(mysqlid,Querys,false);
	    new players=IsUidLogin(uidid);
	    if(players!=-1)
		{
		    format(string,sizeof(string),"���յ�һ������ %s ������Ϣ,��/mail�鿴",SYSTEM_MSG);
			SendClientMessage(players,COLOR_SYSTEM,string);
		}
		else
		{
			format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_ACCOUNT"` WHERE `uid` = '%i' LIMIT 1",uidid);
			mysql_query(mysqlid,Querys,true);
			if(cache_get_field_content_int(0,"offlinnotice")&&cache_get_field_content_int(0,"verify"))
			{
	        	new stry[738],names[80],mailers[256],times[80];
	        	cache_get_field_content(0,"name",names,mysqlid,80);
	        	cache_get_field_content(0,"email",mailers,mysqlid,80);
	        	format(times,80, "%i/%i/%i-%i:%i:%i",date[0],date[1],date[2], time[0], time[1], time[2]);
            	format(stry,sizeof(stry),"����:%s<br/>����%s�յ�һ������%s������Ϣ:<br/>%s<br/>����:$%i",names,times,SYSTEM_MSG,sendstr,money);
	    		SendNoticeMail(mailers,stry);
	    	}
		}
		return 1;
	}
	return 0;
}
ACT::MailNotSee(playerid)
{
	format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_MSG"` WHERE `uid` = '%i' AND`readed` = '0'",pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,true);
	new rows=cache_get_row_count(mysqlid);
	if(rows>0)
	{
	    new string[80];
	    format(string,sizeof(string),"�㻹�� %i ����Ϣδ��,��/mail�鿴",rows);
		SendClientMessage(playerid,COLOR_SYSTEM,string);
	}
	return 1;
}
public OnPlayerSpawn(playerid)
{
	MailNotSee(playerid);
    return CallLocalFunction("Msg_OnPlayerSpawn", "i",playerid);
}
#if defined _ALS_OnPlayerSpawn
   #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn Msg_OnPlayerSpawn
forward Msg_OnPlayerSpawn(playerid);
ACT::ShowPlayerMsgMenu(playerid,pages)
{
	format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_MSG"` WHERE `uid` = '%i' ORDER BY mid DESC",pdate[playerid][uid]);
    mysql_tquery(mysqlid, Querys, "OnPlayerMsgMenu", "ii",playerid,pages);
	return 1;
}
ACT::OnPlayerMsgMenu(playerid,pages)
{
	new rows=cache_get_row_count(mysqlid);
	if(!rows)return SendClientMessage(playerid,COLOR_WARNING,"��û���ʼ�");
    current_number[playerid]=1;
  	for(new i=0;i<rows;i++)
	{
        current_idx[playerid][current_number[playerid]]=cache_get_field_content_int(i, "mid");
        current_number[playerid]++;
	}
	if(pages==0)
	{
		page[playerid]=1;
		SendClientMessage(playerid,COLOR_WARNING,"û����һҳ");
	}
	else page[playerid]=pages;
	if(pages>floatround(rows/float(MAX_DILOG_LIST),floatround_ceil))
	{
		SendClientMessage(playerid,COLOR_WARNING,"û�и�ҳ");
		page[playerid]=1;
	}

    new string[2048],caption[64];
    new pager = (page[playerid]-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	format(caption,sizeof(caption), "������\t����\tʱ��\n");
	strcat(string,caption);
	strcat(string,"{FF8000}��һҳ\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST;i++)
	{
	    new tmp[128],tmps[80],senders[80],sendertime[80];
		if(i<current_number[playerid])
		{
			format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_MSG"` WHERE `mid` = '%i' LIMIT 1",current_idx[playerid][i]);
    		mysql_query(mysqlid, Querys);
    		if(!cache_get_field_content_int(0,"readed"))
    		{
			    cache_get_field_content(0,"sendername",senders,mysqlid,80);
	            format(tmps,sizeof(tmps),"{00FF00}%s\t",senders);
	            strcat(tmp,tmps);
	            if(cache_get_field_content_int(0,"money")>0)format(tmps,sizeof(tmps),"{00FF00}$%i\t",cache_get_field_content_int(0, "money"));
	            else format(tmps,sizeof(tmps),"{00FF00}��\t");
	            strcat(tmp,tmps);
	            cache_get_field_content(0,"sendtime",sendertime,mysqlid,80);
	            format(tmps,sizeof(tmps),"{00FF00}%s\n",sendertime);
	            strcat(tmp,tmps);
            }
            else
            {
			    cache_get_field_content(0,"sendername",senders,mysqlid,80);
	            format(tmps,sizeof(tmps),"{33AA33}%s\t",senders);
	            strcat(tmp,tmps);
	            if(cache_get_field_content_int(0,"money")>0)format(tmps,sizeof(tmps),"{33AA33}$%i\t",cache_get_field_content_int(0, "money"));
	            else format(tmps,sizeof(tmps),"{33AA33}��\t");
	            strcat(tmp,tmps);
	            cache_get_field_content(0,"sendtime",sendertime,mysqlid,80);
	            format(tmps,sizeof(tmps),"{33AA33}%s\n",sendertime);
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
	if(!isover)strcat(string, "{FF8000}��һҳ\n");
	
	new str[128];
	format(str,sizeof(str),"�ʼ���-����[%i],{00FF00}��ɫ:δ��,{33AA33}��ɫ:�Ѷ�",rows);
	Dialog_Show(playerid,dl_player_msg_show,DIALOG_STYLE_TABLIST_HEADERS,str,string, "����", "����");
	return 1;
}

Dialog:dl_player_msg_show(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowPlayerMsgMenu(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowPlayerMsgMenu(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
            Dialog_Show(playerid,dl_player_msg_main,DIALOG_STYLE_LIST,"�ʼ�����","�Ķ��ʼ�\n�ظ��ʼ�\nɾ�����ʼ�\n����ʼ���","����","����");
            SetPVarInt(playerid,"Msg_Current_ID",listid);
		}
	}
	else
	{

	}
	return 1;
}
ShowMsgStr(playerid,midid)
{
    format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_MSG"` WHERE `mid` = '%i' LIMIT 1", midid);
    mysql_query(mysqlid,Querys);
	new caption[80],senders[80],string[1024],str[512],sendertime[80],sendstr[512],botton[16];
	cache_get_field_content(0,"sendername",senders,mysqlid,80);
	format(caption,sizeof(caption), "������:%s",senders);
	cache_get_field_content(0,"sendtime",sendertime,mysqlid,80);
	format(str,sizeof(str), "�ռ�ʱ��:%s\n",sendertime);
	strcat(string,str);
	cache_get_field_content(0,"sendstr",sendstr,mysqlid,512);
	format(str,sizeof(str), "����:\n%s\n",sendstr);
	strcat(string,str);
	if(cache_get_field_content_int(0,"money")>0)
	{
	    format(str,sizeof(str), "����:\n$%i\n",cache_get_field_content_int(0,"money"));
	    strcat(string,str);
		format(botton,sizeof(botton), "��ȡ");
	}
	else format(botton,sizeof(botton), "�ر�");
	if(!cache_get_field_content_int(0,"readed"))
	{
	    format(Querys, sizeof(Querys),"UPDATE `"SQL_MSG"` SET  `readed` =  '1' WHERE  `"SQL_MSG"`.`mid` ='%i'",midid);
	    mysql_query(mysqlid,Querys,false);
	}
	return Dialog_Show(playerid,dl_player_msg_str_see,DIALOG_STYLE_MSGBOX,caption,string,botton,"����");
}
Dialog:dl_player_msg_main(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"Msg_Current_ID");
	    switch(listitem)
	    {
	        case 0:ShowMsgStr(playerid,listid);
	        case 1:
	        {
	            format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_MSG"` WHERE `mid` = '%i' LIMIT 1", listid);
  				mysql_query(mysqlid,Querys);
	            new string[128];
	            format(string,sizeof(string), "��ʹ��/reply %i �ظ��ʼ�",cache_get_field_content_int(0,"senderuid"));
	            SendClientMessage(playerid,COLOR_TIP,string);
	        }
	        case 2:
	        {
	            format(Querys,sizeof(Querys),"DELETE FROM `"SQL_MSG"` WHERE `mid` = '%i'",listid);
	    		mysql_query(mysqlid,Querys,false);
	    		SendClientMessage(playerid,COLOR_TIP,"ɾ���ʼ��ɹ�");
	    		ShowPlayerMsgMenu(playerid,page[playerid]);
	        }
	        case 3:
	        {
	            format(Querys,sizeof(Querys),"DELETE FROM `"SQL_MSG"` WHERE `uid` = '%i'",pdate[playerid][uid]);
	    		mysql_query(mysqlid,Querys,false);
	    		SendClientMessage(playerid,COLOR_TIP,"����ʼ���ɹ�");
	        }
	    }
	}
	else ShowPlayerMsgMenu(playerid,page[playerid]);
	return 1;
}
Dialog:dl_player_msg_str_see(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"Msg_Current_ID");
		format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_MSG"` WHERE `mid` = '%i' LIMIT 1", listid);
  		mysql_query(mysqlid,Querys);
	    if(cache_get_field_content_int(0,"money")>0)
	    {
	        GiveCash(playerid,cache_get_field_content_int(0,"money"));
	        new string[100];
    		format(string,sizeof(string),"����ȡ���ʼ���ĸ��� $%i",cache_get_field_content_int(0,"money"));
    		SendClientMessage(playerid,COLOR_TIP,string);
	    	format(Querys, sizeof(Querys),"UPDATE `"SQL_MSG"` SET  `money` =  '0' WHERE  `"SQL_MSG"`.`mid` ='%i'",listid);
	    	mysql_query(mysqlid,Querys,false);
	    }
		else ShowPlayerMsgMenu(playerid,page[playerid]);
	}
	else ShowPlayerMsgMenu(playerid,page[playerid]);
	return 1;
}

#include WD3/Msg/Msg_Cmd.pwn
