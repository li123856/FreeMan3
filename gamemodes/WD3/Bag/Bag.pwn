#include WD3/Bag/Bag_Define.pwn
#include WD3/Bag/Bag_Custom.pwn

public OnGameModeInit()
{
	Iter_Init(bag);
	return CallLocalFunction("Bag_OnGameModeInit", "");
}
#if defined _ALS_OnGameModeInit
   #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Bag_OnGameModeInit
forward Bag_OnGameModeInit();

LoadAccountBag(playerid)
{
	format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_BAG"` WHERE `uid` = '%i' LIMIT 1",pdate[playerid][uid]);
    mysql_tquery(mysqlid, Querys, "OnBagLoad", "i", playerid);
	return 1;
}
ACT::OnBagLoad(playerid)
{
	new string[80],str[256],typex,amoutx,modelidx,names[80];
	for(new i;i<MAX_CELL;i++)
	{
	    format(string, sizeof(string),"bag_%i",i);
	    cache_get_field_content(0,string,str,mysqlid,128);
	    sscanf(str, "p<&>iiis[80]",typex,modelidx,amoutx,names);
	    if(typex!=-1)
	    {
	        bag[playerid][i][type]=typex;
	        bag[playerid][i][model]=modelidx;
	        bag[playerid][i][amout]=amoutx;
	        format(bag[playerid][i][name],80,names);
	        Iter_Add(bag[playerid],i);
	    }
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
    Iter_Clear(bag[playerid]);
	return CallLocalFunction("Bag_OnPlayerConnect", "i",playerid);
}
#if defined _ALS_OnPlayerConnect
   #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Bag_OnPlayerConnect
forward Bag_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
	Iter_Clear(bag[playerid]);
	return CallLocalFunction("Bag_OnPlayerDisconnect", "ii",playerid,reason);
}
#if defined _ALS_OnPlayerDisconnect
   #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Bag_OnPlayerDisconnect
forward Bag_OnPlayerDisconnect(playerid,reason);

ACT::RemoveBagItem(playerid,types,models,amouts)
{
    foreach(new i:bag[playerid])
	{
		if(bag[playerid][i][type]==types&&bag[playerid][i][model]==models)
		{
			new string[64],str[128];
	        if(amouts>bag[playerid][i][amout])
	        {
                new strs[100];
				format(strs,sizeof(strs),"��ı�����û����ô�������Ʒ,����Ʒ��ǰ[%i��]",bag[playerid][i][amout]);
       			SendClientMessage(playerid,COLOR_WARNING,strs);
       			return 0;
	        }
	        if(bag[playerid][i][amout]-amouts<=0)
	        {
				bag[playerid][i][type]=-1;
			    bag[playerid][i][model]=-1;
			    bag[playerid][i][amout]=-1;
				format(bag[playerid][i][name],80,"NULL");
	            Iter_Remove(bag[playerid],i);

			    format(string, sizeof(string),"bag_%i",i);
			    format(str, sizeof(str),"%i&%i&%i&%s",bag[playerid][i][type],bag[playerid][i][model],bag[playerid][i][amout],bag[playerid][i][name]);
	            format(Querys, sizeof(Querys),"UPDATE`"SQL_BAG"` SET  `%s` =  '%s' WHERE  `"SQL_BAG"`.`uid` ='%i'",string,str,pdate[playerid][uid]);
				mysql_query(mysqlid,Querys,false);
	         	return 1;
  		     }
			bag[playerid][i][amout]-=amouts;
			format(string, sizeof(string),"bag_%i",i);
			format(str, sizeof(str),"%i&%i&%i&%s",bag[playerid][i][type],bag[playerid][i][model],bag[playerid][i][amout],bag[playerid][i][name]);
	        format(Querys, sizeof(Querys),"UPDATE `"SQL_BAG"` SET  `%s` =  '%s' WHERE  `"SQL_BAG"`.`uid` ='%i'",string,str,pdate[playerid][uid]);
			mysql_query(mysqlid,Querys,false);
			return 1;
		}
	}
    new strs[100];
	format(strs,sizeof(strs),"������û�ж������Ʒ");
    SendClientMessage(playerid,COLOR_WARNING,strs);
	return 0;
}
ACT::UpdateBagItem(playerid,index)
{
    new string[64],str[128];
    format(string, sizeof(string),"bag_%i",index);
    format(str, sizeof(str),"%i&%i&%i&%s",bag[playerid][index][type],bag[playerid][index][model],bag[playerid][index][amout],bag[playerid][index][name]);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_BAG"` SET  `%s` =  '%s' WHERE  `"SQL_BAG"`.`uid` ='%i'",string,str,pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::AddBagItem(playerid,types,models,amouts,names[])
{

	if(amouts<=0)return 0;
	foreach(new i:bag[playerid])
	{
		if(bag[playerid][i][type]==types&&bag[playerid][i][model]==models)
		{
		    new string[64],str[128];
		    if(bag[playerid][i][amout]>=0)
		    {
			    bag[playerid][i][amout]+=amouts;
			    format(bag[playerid][i][name],80,names);
			    format(string, sizeof(string),"bag_%i",i);
			    format(str, sizeof(str),"%i&%i&%i&%s",bag[playerid][i][type],bag[playerid][i][model],bag[playerid][i][amout],bag[playerid][i][name]);
	            format(Querys, sizeof(Querys),"UPDATE `"SQL_BAG"` SET  `%s` =  '%s' WHERE  `"SQL_BAG"`.`uid` ='%i'",string,str,pdate[playerid][uid]);
				mysql_query(mysqlid,Querys,false);
				return 1;
			}
			else
			{
                bag[playerid][i][amout]=amouts;
                format(bag[playerid][i][name],80,names);
			    format(string, sizeof(string),"bag_%i",i);
			    format(str, sizeof(str),"%i&%i&%i&%s",bag[playerid][i][type],bag[playerid][i][model],bag[playerid][i][amout],bag[playerid][i][name]);
	            format(Querys, sizeof(Querys),"UPDATE `"SQL_BAG"` SET  `%s` =  '%s' WHERE  `"SQL_BAG"`.`uid` ='%i'",string,str,pdate[playerid][uid]);
				mysql_query(mysqlid,Querys,false);
				return 1;
			}
		}
	}
	new x=Iter_Free(bag[playerid]);
	if(x==-1)
	{
		new strs[100];
		format(strs,sizeof(strs),"����������,�޷�����");
        SendClientMessage(playerid,COLOR_WARNING,strs);
        return 0;
	}
	bag[playerid][x][type]=types;
    bag[playerid][x][model]=models;
    bag[playerid][x][amout]=amouts;
	format(bag[playerid][x][name],80,names);
	Iter_Add(bag[playerid],x);
	
	new string[64],str[128];
    format(bag[playerid][x][name],80,names);
	format(string, sizeof(string),"bag_%i",x);
	format(str, sizeof(str),"%i&%i&%i&%s",bag[playerid][x][type],bag[playerid][x][model],bag[playerid][x][amout],bag[playerid][x][name]);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_BAG"` SET  `%s` =  '%s' WHERE  `"SQL_BAG"`.`uid` ='%i'",string,str,pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);

	new amoutd=Iter_Count(bag[playerid]);
	if(amoutd>=MAX_CELL-5)
	{
		new strs[100];
		format(strs,sizeof(strs),"������������,�뼰ʱ������,��ǰ[%i/%i]",amoutd,MAX_CELL);
        SendClientMessage(playerid,COLOR_WARNING,strs);
	}
	return 1;
}
ACT::ShowMyBag(playerid,pages)
{
	if(!Iter_Count(bag[playerid]))return SendClientMessage(playerid,COLOR_WARNING,"û����Ʒ��¼");
    current_number[playerid]=1;
  	foreach(new i:bag[playerid])
	{
        current_idx[playerid][current_number[playerid]]=i;
        current_number[playerid]++;
	}
	if(pages==0)
	{
		page[playerid]=1;
		SendClientMessage(playerid,COLOR_WARNING,"û����һҳ");
	}
	else page[playerid]=pages;
	if(pages>floatround(Iter_Count(bag[playerid])/float(MAX_DILOG_LIST),floatround_ceil))
	{
		SendClientMessage(playerid,COLOR_WARNING,"û�и�ҳ");
		page[playerid]=1;
	}
	new string[60];
	format(string,sizeof(string),"����-����[%i]",current_number[playerid]-1);
	Dialog_Show(playerid,dl_mybag,DIALOG_STYLE_TABLIST_HEADERS,string,Dialog_MyBag_RetrunStr(playerid,page[playerid]), "ʹ��", "����");
	return 1;
}
Dialog_MyBag_RetrunStr(playerid,pager)
{
    new string[2048],caption[64];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	format(caption,sizeof(caption), "��Ʒ��\t����\t����\tOBJID\n");
	strcat(string,caption);
	strcat(string,"{FF8000}��һҳ\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST; i++)
	{
	    new tmp[384],tmps[128];
		if(i<current_number[playerid])
		{
            format(tmps,sizeof(tmps),"{FF00FF}%s\t",bag[playerid][current_idx[playerid][i]][name]);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"{FF00FF}%i\t",bag[playerid][current_idx[playerid][i]][amout]);
            strcat(tmp,tmps);
            switch(bag[playerid][current_idx[playerid][i]][type])
            {
                case BAG_NONE:format(tmps,sizeof(tmps),"{33FF00}��Ч\t");
                case BAG_FURN:format(tmps,sizeof(tmps),"{33FF00}�Ҿ�\t");
            }
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"{FF00FF}%i\n",bag[playerid][current_idx[playerid][i]][model]);
            strcat(tmp,tmps);
		}
	    if(i>=current_number[playerid])
		{
			isover=1;
			break;
		}
	    else strcat(string,tmp);
	}
	if(!isover)strcat(string, "{FF8000}��һҳ\n");
    return string;
}
Dialog:dl_mybag_bring(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_mybag_bring,DIALOG_STYLE_INPUT,"�ó�","��ֵ����С��1","ȷ��","ȡ��");
	    if(strval(inputtext)>20)return Dialog_Show(playerid,dl_mybag_bring,DIALOG_STYLE_INPUT,"�ó�","��ֵ���ܴ���20","ȷ��","ȡ��");
	    new listid=GetPVarInt(playerid,"Bag_Current_ID");
	    if(bag[playerid][listid][amout]<strval(inputtext))return Dialog_Show(playerid,dl_mybag_bring,DIALOG_STYLE_INPUT,"�ó�","��ı�����û����ô�������Ʒ","ȷ��","ȡ��");
		new modeled=bag[playerid][listid][model];
		new string[80];
		format(string,sizeof(string),bag[playerid][listid][name]);
		if(RemoveBagItem(playerid,bag[playerid][listid][type],bag[playerid][listid][model],strval(inputtext)))
	    {
			new Float:xx,Float:yy,Float:zz;
			GetPlayerFaceFrontPos(playerid,2,xx,yy,zz);
			for(new i=0;i<strval(inputtext);i++)AddFurn(modeled,xx+randfloat(5.0),yy+randfloat(5.0),zz-0.5,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid),string);
		}
	}
	return 1;
}
Dialog:dl_mybag_doing(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"Bag_Current_ID");
	    switch(listitem)
	    {
	        case 0:
	        {
	            if(bag[playerid][listid][amout]>1)Dialog_Show(playerid,dl_mybag_bring,DIALOG_STYLE_INPUT,"�ó�","�������ó��ĸ���","ȷ��","ȡ��");
	            else
	            {
	                new modeled=bag[playerid][listid][model];
	                new string[80];
					format(string,sizeof(string),bag[playerid][listid][name]);
	            	if(RemoveBagItem(playerid,bag[playerid][listid][type],bag[playerid][listid][model],1))
	            	{
	            	    new Float:xx,Float:yy,Float:zz;
						GetPlayerFaceFrontPos(playerid,2,xx,yy,zz);
						AddFurn(modeled,xx,yy,zz-0.5,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid),string);
	            	}
	            }
	        }
	        case 1:
	        {
	            if(pdate[playerid][cash]<100)return SendClientMessage(playerid,COLOR_WARNING,"����ֽ�û��$100");
	            Dialog_Show(playerid, dl_att_add, DIALOG_STYLE_LIST,"��λѡ��",ShowBonesStr(),"ȷ��","ȡ��");
	        }
	        case 2:Dialog_Show(playerid,dl_mybag_makename,DIALOG_STYLE_INPUT,"��Ʒ����","��������Ʒ������","ȷ��","ȡ��");
	        case 3:
	        {
	            new string[64],str[128];
				bag[playerid][listid][type]=-1;
			    bag[playerid][listid][model]=-1;
			    bag[playerid][listid][amout]=-1;
				format(bag[playerid][listid][name],80,"NULL");
	            Iter_Remove(bag[playerid],listid);
			    format(string, sizeof(string),"bag_%i",listid);
			    format(str, sizeof(str),"%i&%i&%i&%s",bag[playerid][listid][type],bag[playerid][listid][model],bag[playerid][listid][amout],bag[playerid][listid][name]);
	            format(Querys, sizeof(Querys),"UPDATE`"SQL_BAG"` SET  `%s` =  '%s' WHERE  `"SQL_BAG"`.`uid` ='%i'",string,str,pdate[playerid][uid]);
				mysql_query(mysqlid,Querys,false);
				ShowMyBag(playerid,page[playerid]);
	        }
	    }
	}
	return 1;
}
Dialog:dl_mybag_makename(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(pdate[playerid][cash]<200)return SendClientMessage(playerid,COLOR_WARNING,"����ֽ�û��$200");
        if(strlen(inputtext)<2||strlen(inputtext)>20)Dialog_Show(playerid,dl_mybag_makename,DIALOG_STYLE_INPUT,"��Ʒ����","��Ʒ����Ҫ����2���ַ�,С��20���ַ�","ȷ��","ȡ��");
		new listid=GetPVarInt(playerid,"Bag_Current_ID");
		format(bag[playerid][listid][name],80,inputtext);
		UpdateBagItem(playerid,listid);
		GiveCash(playerid,-200);
		ShowMyBag(playerid,page[playerid]);
	}
	return 1;
}
Dialog:dl_mybag(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowMyBag(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowMyBag(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
			new caption[80];
			format(caption,sizeof(caption), "%s ����",bag[playerid][listid][name]);
			Dialog_Show(playerid,dl_mybag_doing,DIALOG_STYLE_TABLIST,caption,"�ó���Ʒ\t\nװ������\t$100\n��Ʒ����\t$200\n������Ʒ", "ȷ��", "����");
            SetPVarInt(playerid,"Bag_Current_ID",listid);
		}
	}
	else
	{

	}
	return 1;
}
#include WD3/Bag/Bag_Cmd.pwn
