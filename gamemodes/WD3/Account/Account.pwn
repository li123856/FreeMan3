#include WD3/Account/Account_Define.pwn
#include WD3/Account/Account_Custom.pwn
#include WD3/Gang/Gang_Define.pwn
#include WD3/Gang/Gang_Custom.pwn
public OnPlayerConnect(playerid)
{
	SetPlayerVirtualWorld(playerid,0);
	SetPlayerInterior(playerid,0);
	Reg[playerid]=false;
	Duty[playerid]=false;
	WrongPass[playerid]=0;
	for(new i;userinfo:i<userinfo;i++)pdate[playerid][userinfo:i]=0;
	pdate[playerid][gid]=-1;
	GetPlayerName(playerid,Pname[playerid],80);
    format(Querys, sizeof(Querys),"SELECT `passwords`  FROM `"SQL_ACCOUNT"` WHERE `name` = '%s' LIMIT 1", Pname[playerid]);
    mysql_tquery(mysqlid, Querys, "OnAccountCheck", "i", playerid);
	return CallLocalFunction("Account_OnPlayerConnect", "i",playerid);
}
#if defined _ALS_OnPlayerConnect
   #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Account_OnPlayerConnect
forward Account_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
	stop pEnteTime[playerid];
	pdate[playerid][gid]=-1;
	return CallLocalFunction("Account_OnPlayerDisconnect", "ii",playerid,reason);
}
#if defined _ALS_OnPlayerDisconnect
   #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Account_OnPlayerDisconnect
forward Account_OnPlayerDisconnect(playerid,reason);

public OnPlayerSpawn(playerid)
{
	SetPlayerHealth(playerid,100.0);
    SetCameraBehindPlayer(playerid);
    return CallLocalFunction("Account_OnPlayerSpawn", "i",playerid);
}
#if defined _ALS_OnPlayerSpawn
   #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn Account_OnPlayerSpawn
forward Account_OnPlayerSpawn(playerid);



ACT::OnAccountCheck(playerid)
{
	if(cache_get_row_count(mysqlid))
	{
		cache_get_field_content(0,"passwords",pdate[playerid][passwords],mysqlid,129);
		new string[128];
		format(string, sizeof(string),"��ӭ����%s,��������������½",Pname[playerid]);
		Dialog_Show(playerid,dl_login, DIALOG_STYLE_PASSWORD,"��¼",string,"��¼","ȡ��");
	}
	else Dialog_Show(playerid,dl_register, DIALOG_STYLE_INPUT,"ע���˻�","�㻹û��ע���˻�,������������ע��.","ע��","ȡ��");
	pEnteTime[playerid]=defer EnteTime[120000](playerid);
	return 1;
}
ACT::OnAccountLoad(playerid)
{
	stop pEnteTime[playerid];
	pdate[playerid][uid]=cache_get_field_content_int(0, "uid");
	pdate[playerid][admin]=cache_get_field_content_int(0, "admin");
    pdate[playerid][age]=cache_get_field_content_int(0, "age");
    cache_get_field_content(0,"depict",pdate[playerid][depict],mysqlid,256);
    cache_get_field_content(0,"regtime",pdate[playerid][regtime],mysqlid,80);
    cache_get_field_content(0,"ips",pdate[playerid][ips],mysqlid,32);
    cache_get_field_content(0,"adminpasswords",pdate[playerid][adminpasswords],mysqlid,129);
    pdate[playerid][depictcolorid]=cache_get_field_content_int(0, "depictcolorid");
    pdate[playerid][skinid]=cache_get_field_content_int(0, "skinid");
    pdate[playerid][cash]=cache_get_field_content_int(0, "cash");
    pdate[playerid][bank]=cache_get_field_content_int(0, "bank");
    pdate[playerid][gold]=cache_get_field_content_int(0, "gold");
    pdate[playerid][level]=cache_get_field_content_int(0, "level");
    pdate[playerid][levelpoint]=cache_get_field_content_int(0, "levelpoint");
    pdate[playerid][location]=cache_get_field_content_int(0, "location");
    pdate[playerid][interior]=cache_get_field_content_int(0, "interior");
    pdate[playerid][world]=cache_get_field_content_int(0, "world");
    pdate[playerid][verify]=cache_get_field_content_int(0, "verify");
    pdate[playerid][questionid]=cache_get_field_content_int(0, "questionid");
    pdate[playerid][sex]=cache_get_field_content_int(0, "sex");
    pdate[playerid][colorid]=cache_get_field_content_int(0, "colorid");
    pdate[playerid][offlinnotice]=cache_get_field_content_int(0, "offlinnotice");
	pdate[playerid][gid]=GetGangID(cache_get_field_content_int(0, "gid"));
    pdate[playerid][glevel]=cache_get_field_content_int(0, "glevel");
    pdate[playerid][gscore]=cache_get_field_content_int(0, "gscore");
    cache_get_field_content(0,"email",pdate[playerid][email],mysqlid,256);
    cache_get_field_content(0,"gsign",pdate[playerid][gsign],mysqlid,64);
    cache_get_field_content(0,"sign",pdate[playerid][sign],mysqlid,64);
	new string[80];
    for(new i;i<4;i++)
    {
    	format(string,sizeof(string),"spawn_%i",i);
    	pdate[playerid][spawn][i]=cache_get_field_content_float(0,string);
    }
    for(new i;i<12;i++)
    {
    	format(string,sizeof(string),"weaponsot_%i",i);
    	pdate[playerid][weaponsot][i]=cache_get_field_content_int(0,string);
    }
	Reg[playerid]=true;
	LoadAccountBag(playerid);
	LoadPlayerAttachs(playerid);
	LoadPlayerFriends(playerid);
	ComeStr(playerid);
	ChackEmailVerify(playerid);
    SpawningPlayer(playerid);
	return 1;
}
ACT::ComeStr(playerid)
{
    new string[512],str[80];
	strcat(string,"[Welcome]");
    if(pdate[playerid][admin]>0)
 	{
		format(str,sizeof(str),"[����ԱLEVEL %i]",pdate[playerid][admin]);
		strcat(string,str);
    }
    if(pdate[playerid][gid]!=-1)
    {
    	format(str,sizeof(str),"%s[%s]%s[%s]",colorstr[gang[pdate[playerid][gid]][g_color]],gang[pdate[playerid][gid]][g_name],colorstr[glevelcolour[pdate[playerid][gid]][pdate[playerid][glevel]]],glevelname[pdate[playerid][gid]][pdate[playerid][glevel]]);
		strcat(string,str);
    }
    format(str,sizeof(str),"%s%s ",colorstr[pdate[playerid][colorid]],Pname[playerid]);
	strcat(string,str);
    if(pdate[playerid][depictcolorid]!=-1)
    {
        format(str,sizeof(str),"%s%s",colorstr[pdate[playerid][depictcolorid]],pdate[playerid][depict]);
		strcat(string,str);
    }
	SendClientMessageToAll(COLOR_LIGHTBLUE,string);
	
	new time[3], date[3];
    getdate(date[0],date[1],date[2]);
	gettime(time[0], time[1], time[2]);
	format(str,80,"%d/%d/%d-%d:%d:%d",date[0],date[1],date[2], time[0], time[1], time[2]);
	format(string,sizeof(string),"%s %s���������",str,Pname[playerid]);
	AddLog(LOG_TYPE_LOGIN,string);
	ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid,pdate[playerid][cash]);
    SetPlayerColor(playerid,colors[pdate[playerid][colorid]]);
    return 1;
}
SpawningPlayer(playerid)
{
    if(!pdate[playerid][location])
    {
        new rand=random(sizeof(RandomSpawns));
        SetSpawnInfo(playerid,NO_TEAM,pdate[playerid][skinid],RandomSpawns[rand][0],RandomSpawns[rand][1],RandomSpawns[rand][2],RandomSpawns[rand][3],0,0,0,0,0,0);
     }
    else
	{
		SetSpawnInfo(playerid,NO_TEAM,pdate[playerid][skinid],pdate[playerid][spawn][0],pdate[playerid][spawn][1],pdate[playerid][spawn][2],pdate[playerid][spawn][3],0,0,0,0,0,0);
		SetPlayerVirtualWorld(playerid,pdate[playerid][world]);
		SetPlayerInterior(playerid,pdate[playerid][interior]);
	}
	SpawnPlayer(playerid);
}
ACT::SpawningPlayerEx(playerid, team, skin, Float:x, Float:y, Float:z, Float:Angle)
{
	SetSpawnInfo(playerid,team,skin,x,y,z,Angle,0,0,0,0,0,0);
	return SpawnPlayer(playerid);
}
Dialog:dl_register(playerid, response, listitem, inputtext[]) 
{
    if(response)
    {
        if(strlen(inputtext)<4||strlen(inputtext)>10)return Dialog_Show(playerid,dl_register,DIALOG_STYLE_PASSWORD, "�ַ�����", "�㻹û��ע��,����������ע��", "ע��", "�˳�");
		stop pEnteTime[playerid];
		SHA256_PassHash(inputtext,Salt_ACCOUNT,pdate[playerid][passwords],129);
		GetPlayerIp(playerid,pdate[playerid][ips],16);
		new time[3], date[3];
    	getdate(date[0],date[1],date[2]);
		gettime(time[0], time[1], time[2]);
		format(pdate[playerid][regtime],80,"%d/%d/%d-%d:%d:%d",date[0],date[1],date[2], time[0], time[1], time[2]);
		format(pdate[playerid][gsign],64,"NULL");
		format(pdate[playerid][sign],64,"NULL");
	    pdate[playerid][age]=0;
	    format(pdate[playerid][depict],256,"NULL");
	    pdate[playerid][skinid]=0;
	    pdate[playerid][cash]=0;
	    pdate[playerid][bank]=0;
	    pdate[playerid][gold]=0;
	    pdate[playerid][level]=0;
	    pdate[playerid][levelpoint]=0;
	    pdate[playerid][location]=0;
	    pdate[playerid][interior]=0;
	    pdate[playerid][world]=0;
	    pdate[playerid][admin]=0;
	    pdate[playerid][verify]=0;
	    pdate[playerid][questionid]=-1;
	    pdate[playerid][sex]=0;
	    pdate[playerid][colorid]=1;
	    pdate[playerid][depictcolorid]=-1;
	    pdate[playerid][offlinnotice]=0;
	    pdate[playerid][gid]=-1;
	    pdate[playerid][glevel]=0;
	    pdate[playerid][gscore]=0;
	    format(pdate[playerid][adminpasswords],129,"NULL");
	    format(pdate[playerid][email],256,"NULL");
	    format(pdate[playerid][answer],256,"NULL");
	    for(new i;i<4;i++)pdate[playerid][spawn][i]=0.0;
	    for(new i;i<12;i++)pdate[playerid][weaponsot][i]=-1;

		format(Querys, sizeof(Querys),"INSERT INTO `"SQL_ACCOUNT"`(`name`,`passwords`,`ips`,`regtime`,`age`,`skinid`)VALUES ('%s','%s','%s','%s','%i','%i')",Pname[playerid],pdate[playerid][passwords],pdate[playerid][ips],pdate[playerid][regtime],pdate[playerid][age],pdate[playerid][skinid],pdate[playerid][spawn][0],pdate[playerid][spawn][1],pdate[playerid][spawn][2],pdate[playerid][spawn][3]);
		mysql_query(mysqlid,Querys);
		pdate[playerid][uid]=cache_insert_id();
		
		format(Querys, sizeof(Querys),"INSERT INTO `"SQL_BAG"`(`uid`)VALUES ('%i')",pdate[playerid][uid]);
		mysql_query(mysqlid,Querys);
		
		format(Querys, sizeof(Querys),"INSERT INTO `"SQL_ATT"`(`uid`)VALUES ('%i')",pdate[playerid][uid]);
		mysql_query(mysqlid,Querys);

		format(Querys, sizeof(Querys),"INSERT INTO `"SQL_FRIEND"`(`uid`)VALUES ('%i')",pdate[playerid][uid]);
		mysql_query(mysqlid,Querys);

		Reg[playerid]=true;
		ChackEmailVerify(playerid);
	}
    else Dialog_Show(playerid,dl_register, DIALOG_STYLE_INPUT,"ע���˻�","�㻹û��ע���˻�,������������ע��.","ע��","ȡ��");
    return 1;
}
ACT::ChackEmailVerify(playerid)
{
	if(!pdate[playerid][verify])
	{
	    new strs[256];
	    format(strs,sizeof(strs),"NULL");
	    if(!strcmp(pdate[playerid][email],strs,false))Dialog_Show(playerid,dl_enteremail, DIALOG_STYLE_INPUT,"������֤","�������������\n����:QQ�����163����\n�� 123456@qq.com","ȷ��","ȡ��");
        else
        {
			new str[6],string[36];
			for(new i=0;i<6;i++)
	        {
	            format(str,sizeof(str),"%s",codewords[random(sizeof(codewords))]);
	            strcat(string,str);
	        }
	        printf("%s",string);
	        format(pSecurity[playerid],36,string);
	        new stry[128];
            format(stry,sizeof(stry),"����:%s<br/>����������֤����[%s],������Ϸ���������������֡�",Pname[playerid],pSecurity[playerid]);
			SendMail(playerid,pdate[playerid][email],stry);
			SendClientMessage(playerid,COLOR_TIP,"������֤�뷢����....");
			SetPVarInt(playerid,"UID_Current_ID",pdate[playerid][uid]);
        }
	}
	else
	{
	    Login[playerid]=true;
	    SendClientMessage(playerid,COLOR_TIP,"������������֤,���Լ�����Ϸ������");
	    if(pdate[playerid][offlinnotice])
	    {
			new time[3], date[3],times[80];
    		getdate(date[0],date[1],date[2]);
			gettime(time[0], time[1], time[2]);
			format(times,80,"%d/%d/%d-%d:%d:%d:",date[0],date[1],date[2], time[0], time[1], time[2]);
	    	new ipdz[16];
	    	GetPlayerIp(playerid,ipdz,16);
	        new stry[256];
            format(stry,sizeof(stry),"����:%s<br/>����%s��½����Ϸ,IP:%s",Pname[playerid],times,ipdz);
	    	SendNoticeMail(pdate[playerid][email],stry);
	    }
	}
    return 1;
}

Dialog:dl_enteremail(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strlen(inputtext)<4)return Dialog_Show(playerid,dl_enteremail, DIALOG_STYLE_INPUT,"�ַ�����","�������������\n����:QQ�����163����\n�� 123456@qq.com","ȷ��","ȡ��");
        if(strfind(inputtext,"@", true)==-1||strfind(inputtext,".com", true)==-1)return Dialog_Show(playerid,dl_enteremail, DIALOG_STYLE_INPUT,"���䲻֧�ִ˸�ʽ,����������","�������������\n����:QQ�����163����\n�� 123456@qq.com","ȷ��","ȡ��");

		format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_ACCOUNT"` WHERE `email` = '%s' LIMIT 1",inputtext);
    	mysql_query(mysqlid, Querys);
		if(cache_get_row_count(mysqlid))return Dialog_Show(playerid,dl_enteremail, DIALOG_STYLE_INPUT,"�������ѱ�ע�����","�������������\n����:QQ�����163����\n�� 123456@qq.com","ȷ��","ȡ��");

        format(pPass[playerid],129,inputtext);
		new str[6],string[36];
		for(new i=0;i<6;i++)
        {
            format(str,sizeof(str),"%s",codewords[random(sizeof(codewords))]);
            strcat(string,str);
        }
        printf("%s",string);
        format(pSecurity[playerid],36,string);
	    new stry[128];
        format(stry,sizeof(stry),"����:%s<br/>����������֤����[%s],������Ϸ���������������֡�",Pname[playerid],pSecurity[playerid]);
		SendMail(playerid,pPass[playerid],stry);
		SendClientMessage(playerid,COLOR_TIP,"������֤�뷢����....");
		SetPVarInt(playerid,"UID_Current_ID",pdate[playerid][uid]);
    }
    else DKick(playerid,1000);
    return 1;
}
Dialog:dl_entersecurity(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new securit[32];
        format(securit,sizeof(securit),inputtext);
        if(!strcmp(securit,pSecurity[playerid],false))
		{
		    stop pEnteTime[playerid];
		    pdate[playerid][verify]=1;
		    format(pdate[playerid][email],256,pPass[playerid]);
			format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `verify` =  '%i',`email` =  '%s'   WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][verify],pdate[playerid][email],pdate[playerid][uid]);
			mysql_query(mysqlid,Querys,false);
			Login[playerid]=true;
		    SendClientMessage(playerid,COLOR_TIP,"��ϲ��,��֤�ɹ�,���Լ�����Ϸ�ˣ�����");
		    if(pdate[playerid][offlinnotice])
		    {
				new time[3], date[3],times[80];
	    		getdate(date[0],date[1],date[2]);
				gettime(time[0], time[1], time[2]);
				format(times,80,"%d/%d/%d %d:%d:%d:",date[0],date[1],date[2], time[0], time[1], time[2]);
		    	new ipdz[16];
		    	GetPlayerIp(playerid,pdate[playerid][ips],16);
		        new stry[256];
	            format(stry,sizeof(stry),"����:%s<br/>����%s��½����Ϸ,IP:%s",Pname[playerid],times,ipdz);
		    	SendNoticeMail(pdate[playerid][email],stry);
		    }
		    SpawningPlayer(playerid);
		}
        else
		{
			SendClientMessage(playerid,COLOR_TIP,"�Բ���,��֤ʧ��");
			DKick(playerid,1000);
		}
    }
    else DKick(playerid,1000);
    return 1;
}
Dialog:dl_getpass_login(playerid, response, listitem, inputtext[])
{
    if(response)
    {
    	new hpass[129];
    	SHA256_PassHash(inputtext,Salt_ACCOUNT,hpass,129);
        if(!strcmp(hpass, pdate[playerid][passwords], false))
	    {
			format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_ACCOUNT"` WHERE `name` = '%s' LIMIT 1", Pname[playerid]);
			mysql_tquery(mysqlid, Querys, "OnAccountLoad", "i", playerid);
		}
		else
		{
			new string[128];
			format(string, sizeof(string),"��ӭ����%s,�������,������������������½",Pname[playerid]);
			Dialog_Show(playerid,dl_getpass_login, DIALOG_STYLE_PASSWORD,"��¼",string,"������¼","�һ�����");
		}
    }
    else 
    {
		format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_ACCOUNT"` WHERE `name` = '%s' LIMIT 1", Pname[playerid]);
		mysql_query(mysqlid, Querys);
        if(!cache_get_field_content_int(0, "verify"))
        {
        	SendClientMessage(playerid,COLOR_WARNING,"�Բ���,��û����֤����,�޷��һ�");
			Dialog_Show(playerid,dl_login, DIALOG_STYLE_PASSWORD,"��¼","�����������¼","��¼","ȡ��");
        }
        else
        {
	        if(cache_get_field_content_int(0, "questionid")==-1)
			{
				SendClientMessage(playerid,COLOR_WARNING,"�Բ���,��û�������ܱ�,�޷��һ�");
				Dialog_Show(playerid,dl_login, DIALOG_STYLE_PASSWORD,"��¼","�����������¼","��¼","ȡ��");
			}
			else
			{

				format(Querys, sizeof(Querys), "SELECT `questions`  FROM `"SQL_QUESTIONS"` WHERE `id` = '%i' LIMIT 1",cache_get_field_content_int(0, "questionid"));
				mysql_query(mysqlid, Querys);
				new string[80];
			    cache_get_field_content(0,"questions",string,mysqlid,80);
			    Dialog_Show(playerid,dl_get_password, DIALOG_STYLE_PASSWORD,"�������ܱ���",string,"ȷ��","����");
			}
		}
    }
	return 1;
}
Dialog:dl_get_password(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new securit[80];
        format(securit,sizeof(securit),inputtext);
        if(!strcmp(securit,pdate[playerid][answer], false))
	    {
			format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_ACCOUNT"` WHERE `name` = '%s' LIMIT 1", Pname[playerid]);
			mysql_query(mysqlid, Querys);
			new emails[256];
			cache_get_field_content(0,"email",emails,mysqlid,80);
			new str[6],string[129];
			for(new i=0;i<10;i++)
	        {
	            format(str,sizeof(str),"%s",codewords[random(sizeof(codewords))]);
	            strcat(string,str);
	        }
	        format(pPass[playerid],129,string);
		    new stry[128];
	        format(stry,sizeof(stry),"����:%s<br/>��������[%s],������Ϸ����������������,��ע�ⲻҪй¶��",Pname[playerid],pPass[playerid]);
	        SendGetPassMail(playerid,emails,stry);
			SendClientMessage(playerid,COLOR_TIP,"���䷢����....");
			SetPVarInt(playerid,"UID_Current_ID",pdate[playerid][uid]);
	    }
	    else
	    {
	        SendClientMessage(playerid,COLOR_WARNING,"�ܱ��𰸴���,�ټ�����");
	        DKick(playerid,1000);
	    }
    }
    else Dialog_Show(playerid,dl_login, DIALOG_STYLE_PASSWORD,"��¼","�����������¼","��¼","ȡ��");
	return 1;
}
Dialog:dl_login(playerid, response, listitem, inputtext[])	
{
    if(response)
    {
        if(WrongPass[playerid]>3)
        {
            Dialog_Show(playerid,dl_msg, DIALOG_STYLE_PASSWORD,"��ʾ","���ѳ���3�ε�¼��Ч","�ټ�","");
            DKick(playerid,1000);
        }
    	new hpass[129];
    	SHA256_PassHash(inputtext,Salt_ACCOUNT,hpass,129);
        if(!strcmp(hpass, pdate[playerid][passwords], false))
	    {
			format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_ACCOUNT"` WHERE `name` = '%s' LIMIT 1", Pname[playerid]);
			mysql_tquery(mysqlid, Querys, "OnAccountLoad", "i", playerid);
		}
		else
		{
			new string[128];
			format(string, sizeof(string),"��ӭ����%s,�������,������������������½",Pname[playerid]);
			Dialog_Show(playerid,dl_getpass_login, DIALOG_STYLE_PASSWORD,"��¼",string,"������¼","�һ�����");
			WrongPass[playerid]++;
		}
    }
    else Dialog_Show(playerid,dl_login, DIALOG_STYLE_PASSWORD,"��¼","�����������¼","��¼","ȡ��");
	return 1;
}
Dialog:dl_admin_register(playerid, response, listitem, inputtext[])
{
	if(strlen(inputtext)<4||strlen(inputtext)>10)return Dialog_Show(playerid,dl_admin_register,DIALOG_STYLE_PASSWORD, "�ַ�����", "����ע����������ٵ�¼", "ע��", "�˳�");
    new string[129];
    SHA256_PassHash(inputtext,Salt_ACCOUNT,string,129);
    if(!strcmp(string,pdate[playerid][passwords],false))return Dialog_Show(playerid,dl_admin_register,DIALOG_STYLE_PASSWORD, "����Ա���벻�����½������ͬ", "����ע����������ٵ�¼", "ע��", "�˳�");
 	SHA256_PassHash(inputtext,Salt_ACCOUNT,pdate[playerid][adminpasswords],129);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `adminpasswords` =  '%s' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][adminpasswords],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	SendClientMessage(playerid,COLOR_TIP,"ע��ɹ�,�� /duty ��¼����Ա");
	return 1;
}
Dialog:dl_admin_login(playerid, response, listitem, inputtext[])
{
    if(response)
    {
	    new hpass[129];
	    SHA256_PassHash(inputtext,Salt_ACCOUNT,hpass,129);
	    if(!strcmp(hpass, pdate[playerid][adminpasswords], false))
		{
		    Duty[playerid]=true;
		    SendClientMessage(playerid,COLOR_TIP,"��½����Ա�ɹ�");
		}
		else SendClientMessage(playerid,COLOR_WARNING,"�����������,�޷���¼����Ա");
	}
	return 1;
}
ACT::GiveCash(playerid,amouts)
{
    pdate[playerid][cash]+=amouts;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid,pdate[playerid][cash]);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `cash` =  '%i' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][cash],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::SetCash(playerid,amouts)
{
    pdate[playerid][cash]=amouts;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid,pdate[playerid][cash]);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `cash` =  '%i' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][cash],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::SetBank(playerid,amouts)
{
    pdate[playerid][bank]=amouts;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `bank` =  '%i' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][bank],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::GiveBank(playerid,amouts)
{
    pdate[playerid][bank]+=amouts;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `bank` =  '%i' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][bank],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::SetGang(playerid,gidd,glevels,scores)
{
    pdate[playerid][gid]=GetGangID(gidd);
    pdate[playerid][glevel]=glevels;
    pdate[playerid][gscore]=scores;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `gid` =  '%i',`glevel` =  '%i',`gscore` =  '%i' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",gidd,pdate[playerid][glevel],pdate[playerid][gscore],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::SetGangSign(playerid,signn[])
{
	format(pdate[playerid][gsign],64,signn);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `gsign` =  '%s' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][gsign],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::SetSign(playerid,signn[])
{
	format(pdate[playerid][sign],64,signn);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `sign` =  '%s' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][sign],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::SetAdmin(playerid,levels)
{
    pdate[playerid][admin]=levels;
    format(pdate[playerid][adminpasswords],129,"NULL");
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `admin` =  '%i',`adminpasswords` =  '%s' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][admin],pdate[playerid][adminpasswords],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::SetSkin(playerid,skin)
{
    pdate[playerid][skinid]=skin;
    SetPlayerSkin(playerid,pdate[playerid][skinid]);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `skinid` =  '%i' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][skinid],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::SetColor(playerid,colord)
{
    pdate[playerid][colorid]=colord;
    SetPlayerColor(playerid,colors[pdate[playerid][colorid]]);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `colorid` =  '%i' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][colorid],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::SetSex(playerid,sexs)
{
    pdate[playerid][sex]=sexs;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `sex` =  '%i' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][sex],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::SetNotice(playerid,notices)
{
    pdate[playerid][offlinnotice]=notices;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `offlinnotice` =  '%i' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][offlinnotice],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::SetDepict(playerid,depicts[],colord)
{
    format(pdate[playerid][depict],256,depicts);
    pdate[playerid][depictcolorid]=colord;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `depict` =  '%s',`depictcolorid` =  '%i' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][depict],pdate[playerid][depictcolorid],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::SetQuest(playerid,qustid,answers[])
{
    pdate[playerid][questionid]=qustid;
    format(pdate[playerid][answer],80,answers);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `questionid` =  '%i',`answer` =  '%s' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][depictcolorid],pdate[playerid][answer],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::SetPosHere(playerid,locationd,Float:spawn_0,Float:spawn_1,Float:spawn_2,Float:spawn_3,inter,worlded)
{
    pdate[playerid][location]=locationd;
    pdate[playerid][spawn][0]=spawn_0;
    pdate[playerid][spawn][1]=spawn_1;
    pdate[playerid][spawn][2]=spawn_2;
    pdate[playerid][spawn][3]=spawn_3;
    pdate[playerid][interior]=inter;
    pdate[playerid][world]=worlded;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `location` =  '%i',`spawn_0` =  '%0.3f',`spawn_1` =  '%0.3f',`spawn_2` =  '%0.3f',`spawn_3` =  '%0.3f',`interior` =  '%i',`world` =  '%i' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][location],pdate[playerid][spawn][0],pdate[playerid][spawn][1],pdate[playerid][spawn][2],pdate[playerid][spawn][3],pdate[playerid][interior],pdate[playerid][world],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
IsAdminLevel(playerid,levels)
{
	if(pdate[playerid][admin]>=levels&&Duty[playerid]==true)return 1;
	return 0;
}
timer EnteTime[1000](playerid)
{
    SendClientMessage(playerid,COLOR_WARNING,"�Բ���,��¼��ʱ");
    DKick(playerid,1000);
}
Dialog:dl_sex(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        switch(listitem)
        {
            case 0:
            {
                if(pdate[playerid][cash]<100)return SendClientMessage(playerid,COLOR_WARNING,"����ֽ���");
                GiveCash(playerid,-100);
            }
            case 1:
            {
                if(pdate[playerid][cash]<100)return SendClientMessage(playerid,COLOR_WARNING,"����ֽ���");
                GiveCash(playerid,-100);
            }
            case 2:
            {
                if(pdate[playerid][cash]<500)return SendClientMessage(playerid,COLOR_WARNING,"����ֽ���");
                GiveCash(playerid,-500);
            }
        }
        SetSex(playerid,listitem);
	}
	return 1;
}
Dialog:dl_depict_edit(playerid, response, listitem, inputtext[])
{
    if(response)
    {
    	if(pdate[playerid][cash]<10000)return SendClientMessage(playerid,COLOR_WARNING,"����ֽ���");
    	if(strlen(inputtext)<2||strlen(inputtext)>256)return Dialog_Show(playerid,dl_depict_edit,DIALOG_STYLE_INPUT,"ǩ����","�������2�ַ�,С��256���ַ�","ȷ��","ȡ��");
		SetDepict(playerid,inputtext,1);
		GiveCash(playerid,-10000);
	}
	return 1;
}
Dialog:dl_depict_color(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(pdate[playerid][depictcolorid]==-1)return SendClientMessage(playerid,COLOR_WARNING,"�㻹û�����ù����");
    	SetDepict(playerid,pdate[playerid][depict],listitem+1);
    }
	return 1;
}
Dialog:dl_depict_close(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(pdate[playerid][depictcolorid]==-1)return SendClientMessage(playerid,COLOR_WARNING,"�㻹û�����ù����");
    	SetDepict(playerid,"NULL",-1);
    }
	return 1;
}
Dialog:dl_depict(playerid, response, listitem, inputtext[])
{
    if(response)
    {
		switch(listitem)
		{
		    case 0:Dialog_Show(playerid,dl_depict_edit,DIALOG_STYLE_INPUT,"ǩ����","������ǩ����","ȷ��","ȡ��");
		    case 1:Dialog_Show(playerid,dl_depict_color,DIALOG_STYLE_LIST,"�ҵ���ɫ",ShowColorStr(),"ѡ��","ȡ��");
		    case 2:Dialog_Show(playerid,dl_depict_close,DIALOG_STYLE_MSGBOX,"ȡ��ǩ��","�Ƿ�ȡ��ǩ��","ȷ��","ȡ��");
		}
    }
	return 1;
}
Dialog:dl_color(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(pdate[playerid][cash]<100)return SendClientMessage(playerid,COLOR_WARNING,"����ֽ�û��$100");
        GiveCash(playerid,-100);
        SetColor(playerid,listitem+1);
    }
	return 1;
}
Dialog:dl_setpos(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new Float:xx,Float:yy,Float:zz,Float:angled;
		GetPlayerPos(playerid,xx,yy,zz);
		GetPlayerFacingAngle(playerid,angled);
		SetPosHere(playerid,1,xx,yy,zz,angled,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid));
    }
    else SetPosHere(playerid,0,0,0,0,0,0,0);
	return 1;
}
Dialog:dl_stats(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        switch(listitem)
        {
            case 0:return CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/duty");
            case 1:return 1;
            case 2:return Dialog_Show(playerid,dl_sex,DIALOG_STYLE_TABLIST,"�����Ա�","����\t$100\nŮ��\t$100\n������\t$500\n","��","ȡ��");
            case 3:return CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/skin");
            case 4:return 1;
            case 5:return 1;
            case 6:return 1;
            case 7:return 1;
            case 8:return 1;
            case 9:return 1;
            case 10:return Dialog_Show(playerid,dl_color,DIALOG_STYLE_LIST,"�ҵ���ɫ",ShowColorStr(),"ѡ��","ȡ��");
            case 11:Dialog_Show(playerid,dl_depict,DIALOG_STYLE_TABLIST,"����ǩ��","����ǩ����\t$10000\n����ǩ����ɫ\t���\n�ر�ǩ��","ѡ��","ȡ��");
            case 12:Dialog_Show(playerid,dl_setpos,DIALOG_STYLE_MSGBOX,"������λ","�Ƿ����ô˵�Ϊ������","���ó�����","ȡ��������");
            case 13:return CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/stats");
            case 14:
            {
                if(!pdate[playerid][verify])return SendClientMessage(playerid,COLOR_WARNING,"��û����֤����,�޷���������Ŀ");
				new str[6],string[36];
				for(new i=0;i<6;i++)
	        	{
	            	format(str,sizeof(str),"%s",codewords[random(sizeof(codewords))]);
	            	strcat(string,str);
	        	}
	        	format(pSecurity[playerid],36,string);
	        	new stry[128];
            	format(stry,sizeof(stry),"����:%s<br/>�����ڲ����ܱ�����,������֤����[%s],������Ϸ������������������ɲ�����",Pname[playerid],pSecurity[playerid]);
				SendMailEx(playerid,pdate[playerid][email],stry);
				SendClientMessage(playerid,COLOR_TIP,"��֤�뷢����....���Ժ�");
				SetPVarInt(playerid,"UID_Current_ID",pdate[playerid][uid]);
            }
            case 15:
            {
                if(!pdate[playerid][offlinnotice])SetNotice(playerid,1);
                else SetNotice(playerid,0);
            }
        }
    }
    return 1;
}
Dialog:dl_entersecurity_quest(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new securit[32];
        format(securit,sizeof(securit),inputtext);
        if(!strcmp(securit,pSecurity[playerid],false))
		{
			if(pdate[playerid][questionid]==-1)ShowPlayerQuestions(playerid,1);
            else
			{
				SetQuest(playerid,-1,"NULL");
				SendClientMessage(playerid,COLOR_TIP,"�ܱ�������ȡ��");
			}
		}
        else SendClientMessage(playerid,COLOR_TIP,"�Բ���,��֤ʧ��,�޷���������Ŀ");
    }
    return 1;
}
ACT::ShowPlayerQuestions(playerid,pages)
{
	format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_QUESTIONS"`");
    mysql_tquery(mysqlid, Querys, "OnPlayerQuestionsMenu", "ii",playerid,pages);
	return 1;
}
ACT::OnPlayerQuestionsMenu(playerid,pages)
{
	new rows=cache_get_row_count(mysqlid);
	if(!rows)return SendClientMessage(playerid,COLOR_WARNING,"û����������");
    current_number[playerid]=1;
  	for(new i=0;i<rows;i++)
	{
        current_idx[playerid][current_number[playerid]]=cache_get_field_content_int(i, "id");
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
	format(caption,sizeof(caption), "ID\t����\n");
	strcat(string,caption);
	strcat(string,"{FF8000}��һҳ\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST;i++)
	{
	    new tmp[300],tmps[270],sendertime[256];
		if(i<current_number[playerid])
		{
			format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_QUESTIONS"` WHERE `id` = '%i' LIMIT 1",current_idx[playerid][i]);
    		mysql_query(mysqlid, Querys);
            format(tmps,sizeof(tmps),"{33AA33}%i\t",current_idx[playerid][i]);
            strcat(tmp,tmps);
            cache_get_field_content(0,"questions",sendertime,mysqlid,256);
            format(tmps,sizeof(tmps),"{33AA33}%s\n",sendertime);
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

	new str[60];
	format(str,sizeof(str),"�ܱ������б�-����[%i]",rows);
	Dialog_Show(playerid,dl_player_Question_show,DIALOG_STYLE_TABLIST_HEADERS,str,string, "ѡ��", "����");
	return 1;
}
Dialog:dl_player_Question_show(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowPlayerQuestions(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowPlayerQuestions(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
            Dialog_Show(playerid,dl_Question_answer_set,DIALOG_STYLE_INPUT,"������","�������","ȷ��","ȡ��");
            SetPVarInt(playerid,"Question_Current_ID",listid);
		}
	}
	else
	{

	}
	return 1;
}
Dialog:dl_Question_answer_set(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strlen(inputtext)<2||strlen(inputtext)>256)return Dialog_Show(playerid,dl_Question_answer_set,DIALOG_STYLE_INPUT,"������","�������","ȷ��","ȡ��");
        new listid=GetPVarInt(playerid,"Question_Current_ID");
        SetQuest(playerid,listid,inputtext);
	}
	return 1;
}
ACT::ShowPlayerStats(playerid)
{
	new string[2048],str[100],caption[100];
	format(caption,sizeof(caption),"UID:%i %s",pdate[playerid][uid],Pname[playerid]);
	switch(pdate[playerid][admin])
	{
	    case ADMIN_SMALL:format(str,sizeof(str),"����Ա\t��̨\n");
		case ADMIN_MIDDLE:format(str,sizeof(str),"����Ա\t�߼�\n");
		case ADMIN_LARGE:format(str,sizeof(str),"����Ա\t����\n");
		case ADMIN_NONE:format(str,sizeof(str),"����Ա\t��\n");
	}
	strcat(string,str);
	format(str,sizeof(str),"ע��ʱ��\t%s\n",pdate[playerid][regtime]);
	strcat(string,str);
	switch(pdate[playerid][sex])
	{
	    case 0:format(str,sizeof(str),"�Ա�\t��\n");
	    case 1:format(str,sizeof(str),"�Ա�\tŮ\n");
	    case 2:format(str,sizeof(str),"�Ա�\t������\n");
	}
	strcat(string,str);
	format(str,sizeof(str),"Ƥ��\t%i[%i]\n",pdate[playerid][skinid],GetPlayerSkin(playerid));
	strcat(string,str);
	format(str,sizeof(str),"����\t%i\n",pdate[playerid][age]);
	strcat(string,str);
	format(str,sizeof(str),"�ֽ�\t%i\n",pdate[playerid][cash]);
	strcat(string,str);
	format(str,sizeof(str),"���\t%i\n",pdate[playerid][bank]);
	strcat(string,str);
	format(str,sizeof(str),"���\t%i\n",pdate[playerid][gold]);
	strcat(string,str);
	format(str,sizeof(str),"�ȼ�\t%i\n",pdate[playerid][level]);
	strcat(string,str);
	format(str,sizeof(str),"����\t%i\n",pdate[playerid][levelpoint]);
	strcat(string,str);
	format(str,sizeof(str),"��ɫ\t%s������������������\n",colorstr[pdate[playerid][colorid]]);
	strcat(string,str);
	if(pdate[playerid][depictcolorid]!=-1)format(str,sizeof(str),"ǩ��\t%s%s\n",colorstr[pdate[playerid][depictcolorid]],pdate[playerid][depict]);
	else format(str,sizeof(str),"ǩ��\t��\n");
	strcat(string,str);
	if(pdate[playerid][location])format(str,sizeof(str),"������λ\t������\n");
	else format(str,sizeof(str),"������λ\tδ����\n");
	strcat(string,str);
	if(pdate[playerid][verify])format(str,sizeof(str),"������֤\t����֤\n");
	else format(str,sizeof(str),"������֤\tδ��֤\n");
	strcat(string,str);
	if(pdate[playerid][questionid]==-1)format(str,sizeof(str),"���뱣��\t�ر�\n");
	else format(str,sizeof(str),"���뱣��\t����\n");
	strcat(string,str);
	if(pdate[playerid][offlinnotice])format(str,sizeof(str),"��������\t����\n");
	else format(str,sizeof(str),"��������\t�ر�\n");
	strcat(string,str);
	
	Dialog_Show(playerid,dl_stats,DIALOG_STYLE_TABLIST,caption,string,"ѡ��","ȡ��");
	return 1;
}

#include WD3/Account/Account_Cmd.pwn
