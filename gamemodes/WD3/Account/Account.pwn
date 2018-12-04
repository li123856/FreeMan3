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
		format(string, sizeof(string),"欢迎回来%s,请输入密码来登陆",Pname[playerid]);
		Dialog_Show(playerid,dl_login, DIALOG_STYLE_PASSWORD,"登录",string,"登录","取消");
	}
	else Dialog_Show(playerid,dl_register, DIALOG_STYLE_INPUT,"注册账户","你还没有注册账户,请输入密码来注册.","注册","取消");
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
		format(str,sizeof(str),"[管理员LEVEL %i]",pdate[playerid][admin]);
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
	format(string,sizeof(string),"%s %s进入服务器",str,Pname[playerid]);
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
        if(strlen(inputtext)<4||strlen(inputtext)>10)return Dialog_Show(playerid,dl_register,DIALOG_STYLE_PASSWORD, "字符过短", "你还没有注册,请输入密码注册", "注册", "退出");
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
    else Dialog_Show(playerid,dl_register, DIALOG_STYLE_INPUT,"注册账户","你还没有注册账户,请输入密码来注册.","注册","取消");
    return 1;
}
ACT::ChackEmailVerify(playerid)
{
	if(!pdate[playerid][verify])
	{
	    new strs[256];
	    format(strs,sizeof(strs),"NULL");
	    if(!strcmp(pdate[playerid][email],strs,false))Dialog_Show(playerid,dl_enteremail, DIALOG_STYLE_INPUT,"邮箱验证","请输入你的邮箱\n建议:QQ邮箱或163邮箱\n例 123456@qq.com","确定","取消");
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
            format(stry,sizeof(stry),"您好:%s<br/>您的邮箱验证码是[%s],请在游戏内输入括号内文字。",Pname[playerid],pSecurity[playerid]);
			SendMail(playerid,pdate[playerid][email],stry);
			SendClientMessage(playerid,COLOR_TIP,"邮箱验证码发送中....");
			SetPVarInt(playerid,"UID_Current_ID",pdate[playerid][uid]);
        }
	}
	else
	{
	    Login[playerid]=true;
	    SendClientMessage(playerid,COLOR_TIP,"您的邮箱已验证,可以继续游戏！！！");
	    if(pdate[playerid][offlinnotice])
	    {
			new time[3], date[3],times[80];
    		getdate(date[0],date[1],date[2]);
			gettime(time[0], time[1], time[2]);
			format(times,80,"%d/%d/%d-%d:%d:%d:",date[0],date[1],date[2], time[0], time[1], time[2]);
	    	new ipdz[16];
	    	GetPlayerIp(playerid,ipdz,16);
	        new stry[256];
            format(stry,sizeof(stry),"您好:%s<br/>您在%s登陆了游戏,IP:%s",Pname[playerid],times,ipdz);
	    	SendNoticeMail(pdate[playerid][email],stry);
	    }
	}
    return 1;
}

Dialog:dl_enteremail(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strlen(inputtext)<4)return Dialog_Show(playerid,dl_enteremail, DIALOG_STYLE_INPUT,"字符过短","请输入你的邮箱\n建议:QQ邮箱或163邮箱\n例 123456@qq.com","确定","取消");
        if(strfind(inputtext,"@", true)==-1||strfind(inputtext,".com", true)==-1)return Dialog_Show(playerid,dl_enteremail, DIALOG_STYLE_INPUT,"邮箱不支持此格式,请重新输入","请输入你的邮箱\n建议:QQ邮箱或163邮箱\n例 123456@qq.com","确定","取消");

		format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_ACCOUNT"` WHERE `email` = '%s' LIMIT 1",inputtext);
    	mysql_query(mysqlid, Querys);
		if(cache_get_row_count(mysqlid))return Dialog_Show(playerid,dl_enteremail, DIALOG_STYLE_INPUT,"此邮箱已被注册过了","请输入你的邮箱\n建议:QQ邮箱或163邮箱\n例 123456@qq.com","确定","取消");

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
        format(stry,sizeof(stry),"您好:%s<br/>您的邮箱验证码是[%s],请在游戏内输入括号内文字。",Pname[playerid],pSecurity[playerid]);
		SendMail(playerid,pPass[playerid],stry);
		SendClientMessage(playerid,COLOR_TIP,"邮箱验证码发送中....");
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
		    SendClientMessage(playerid,COLOR_TIP,"恭喜你,验证成功,可以继续游戏了！！！");
		    if(pdate[playerid][offlinnotice])
		    {
				new time[3], date[3],times[80];
	    		getdate(date[0],date[1],date[2]);
				gettime(time[0], time[1], time[2]);
				format(times,80,"%d/%d/%d %d:%d:%d:",date[0],date[1],date[2], time[0], time[1], time[2]);
		    	new ipdz[16];
		    	GetPlayerIp(playerid,pdate[playerid][ips],16);
		        new stry[256];
	            format(stry,sizeof(stry),"您好:%s<br/>您在%s登陆了游戏,IP:%s",Pname[playerid],times,ipdz);
		    	SendNoticeMail(pdate[playerid][email],stry);
		    }
		    SpawningPlayer(playerid);
		}
        else
		{
			SendClientMessage(playerid,COLOR_TIP,"对不起,验证失败");
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
			format(string, sizeof(string),"欢迎回来%s,密码错误,请重新输入密码来登陆",Pname[playerid]);
			Dialog_Show(playerid,dl_getpass_login, DIALOG_STYLE_PASSWORD,"登录",string,"继续登录","找回密码");
		}
    }
    else 
    {
		format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_ACCOUNT"` WHERE `name` = '%s' LIMIT 1", Pname[playerid]);
		mysql_query(mysqlid, Querys);
        if(!cache_get_field_content_int(0, "verify"))
        {
        	SendClientMessage(playerid,COLOR_WARNING,"对不起,你没有验证邮箱,无法找回");
			Dialog_Show(playerid,dl_login, DIALOG_STYLE_PASSWORD,"登录","请输入密码登录","登录","取消");
        }
        else
        {
	        if(cache_get_field_content_int(0, "questionid")==-1)
			{
				SendClientMessage(playerid,COLOR_WARNING,"对不起,你没有设置密保,无法找回");
				Dialog_Show(playerid,dl_login, DIALOG_STYLE_PASSWORD,"登录","请输入密码登录","登录","取消");
			}
			else
			{

				format(Querys, sizeof(Querys), "SELECT `questions`  FROM `"SQL_QUESTIONS"` WHERE `id` = '%i' LIMIT 1",cache_get_field_content_int(0, "questionid"));
				mysql_query(mysqlid, Querys);
				new string[80];
			    cache_get_field_content(0,"questions",string,mysqlid,80);
			    Dialog_Show(playerid,dl_get_password, DIALOG_STYLE_PASSWORD,"请输入密保答案",string,"确定","返回");
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
	        format(stry,sizeof(stry),"您好:%s<br/>新密码是[%s],请在游戏内输入括号内文字,请注意不要泄露。",Pname[playerid],pPass[playerid]);
	        SendGetPassMail(playerid,emails,stry);
			SendClientMessage(playerid,COLOR_TIP,"邮箱发送中....");
			SetPVarInt(playerid,"UID_Current_ID",pdate[playerid][uid]);
	    }
	    else
	    {
	        SendClientMessage(playerid,COLOR_WARNING,"密保答案错误,再见！！");
	        DKick(playerid,1000);
	    }
    }
    else Dialog_Show(playerid,dl_login, DIALOG_STYLE_PASSWORD,"登录","请输入密码登录","登录","取消");
	return 1;
}
Dialog:dl_login(playerid, response, listitem, inputtext[])	
{
    if(response)
    {
        if(WrongPass[playerid]>3)
        {
            Dialog_Show(playerid,dl_msg, DIALOG_STYLE_PASSWORD,"提示","你已尝试3次登录无效","再见","");
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
			format(string, sizeof(string),"欢迎回来%s,密码错误,请重新输入密码来登陆",Pname[playerid]);
			Dialog_Show(playerid,dl_getpass_login, DIALOG_STYLE_PASSWORD,"登录",string,"继续登录","找回密码");
			WrongPass[playerid]++;
		}
    }
    else Dialog_Show(playerid,dl_login, DIALOG_STYLE_PASSWORD,"登录","请输入密码登录","登录","取消");
	return 1;
}
Dialog:dl_admin_register(playerid, response, listitem, inputtext[])
{
	if(strlen(inputtext)<4||strlen(inputtext)>10)return Dialog_Show(playerid,dl_admin_register,DIALOG_STYLE_PASSWORD, "字符过短", "请先注册管理密码再登录", "注册", "退出");
    new string[129];
    SHA256_PassHash(inputtext,Salt_ACCOUNT,string,129);
    if(!strcmp(string,pdate[playerid][passwords],false))return Dialog_Show(playerid,dl_admin_register,DIALOG_STYLE_PASSWORD, "管理员密码不能与登陆密码相同", "请先注册管理密码再登录", "注册", "退出");
 	SHA256_PassHash(inputtext,Salt_ACCOUNT,pdate[playerid][adminpasswords],129);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `adminpasswords` =  '%s' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[playerid][adminpasswords],pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	SendClientMessage(playerid,COLOR_TIP,"注册成功,请 /duty 登录管理员");
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
		    SendClientMessage(playerid,COLOR_TIP,"登陆管理员成功");
		}
		else SendClientMessage(playerid,COLOR_WARNING,"管理密码错误,无法登录管理员");
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
    SendClientMessage(playerid,COLOR_WARNING,"对不起,登录超时");
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
                if(pdate[playerid][cash]<100)return SendClientMessage(playerid,COLOR_WARNING,"你的现金不足");
                GiveCash(playerid,-100);
            }
            case 1:
            {
                if(pdate[playerid][cash]<100)return SendClientMessage(playerid,COLOR_WARNING,"你的现金不足");
                GiveCash(playerid,-100);
            }
            case 2:
            {
                if(pdate[playerid][cash]<500)return SendClientMessage(playerid,COLOR_WARNING,"你的现金不足");
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
    	if(pdate[playerid][cash]<10000)return SendClientMessage(playerid,COLOR_WARNING,"你的现金不足");
    	if(strlen(inputtext)<2||strlen(inputtext)>256)return Dialog_Show(playerid,dl_depict_edit,DIALOG_STYLE_INPUT,"签名语","必须大于2字符,小于256个字符","确定","取消");
		SetDepict(playerid,inputtext,1);
		GiveCash(playerid,-10000);
	}
	return 1;
}
Dialog:dl_depict_color(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(pdate[playerid][depictcolorid]==-1)return SendClientMessage(playerid,COLOR_WARNING,"你还没有设置广告语");
    	SetDepict(playerid,pdate[playerid][depict],listitem+1);
    }
	return 1;
}
Dialog:dl_depict_close(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(pdate[playerid][depictcolorid]==-1)return SendClientMessage(playerid,COLOR_WARNING,"你还没有设置广告语");
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
		    case 0:Dialog_Show(playerid,dl_depict_edit,DIALOG_STYLE_INPUT,"签名语","请输入签名语","确定","取消");
		    case 1:Dialog_Show(playerid,dl_depict_color,DIALOG_STYLE_LIST,"我的颜色",ShowColorStr(),"选择","取消");
		    case 2:Dialog_Show(playerid,dl_depict_close,DIALOG_STYLE_MSGBOX,"取消签名","是否取消签名","确定","取消");
		}
    }
	return 1;
}
Dialog:dl_color(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(pdate[playerid][cash]<100)return SendClientMessage(playerid,COLOR_WARNING,"你的现金没有$100");
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
            case 2:return Dialog_Show(playerid,dl_sex,DIALOG_STYLE_TABLIST,"更改性别","男生\t$100\n女生\t$100\n不公开\t$500\n","男","取消");
            case 3:return CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/skin");
            case 4:return 1;
            case 5:return 1;
            case 6:return 1;
            case 7:return 1;
            case 8:return 1;
            case 9:return 1;
            case 10:return Dialog_Show(playerid,dl_color,DIALOG_STYLE_LIST,"我的颜色",ShowColorStr(),"选择","取消");
            case 11:Dialog_Show(playerid,dl_depict,DIALOG_STYLE_TABLIST,"设置签名","设置签名语\t$10000\n设置签名颜色\t免费\n关闭签名","选择","取消");
            case 12:Dialog_Show(playerid,dl_setpos,DIALOG_STYLE_MSGBOX,"出生定位","是否设置此地为出生点","设置出生点","取消出生点");
            case 13:return CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/stats");
            case 14:
            {
                if(!pdate[playerid][verify])return SendClientMessage(playerid,COLOR_WARNING,"你没有验证邮箱,无法操作本项目");
				new str[6],string[36];
				for(new i=0;i<6;i++)
	        	{
	            	format(str,sizeof(str),"%s",codewords[random(sizeof(codewords))]);
	            	strcat(string,str);
	        	}
	        	format(pSecurity[playerid],36,string);
	        	new stry[128];
            	format(stry,sizeof(stry),"您好:%s<br/>您正在操作密保服务,您的验证码是[%s],请在游戏内输入括号内文字完成操作。",Pname[playerid],pSecurity[playerid]);
				SendMailEx(playerid,pdate[playerid][email],stry);
				SendClientMessage(playerid,COLOR_TIP,"验证码发送中....请稍候");
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
				SendClientMessage(playerid,COLOR_TIP,"密保服务已取消");
			}
		}
        else SendClientMessage(playerid,COLOR_TIP,"对不起,验证失败,无法操作本项目");
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
	if(!rows)return SendClientMessage(playerid,COLOR_WARNING,"没有问题内容");
    current_number[playerid]=1;
  	for(new i=0;i<rows;i++)
	{
        current_idx[playerid][current_number[playerid]]=cache_get_field_content_int(i, "id");
        current_number[playerid]++;
	}
	if(pages==0)
	{
		page[playerid]=1;
		SendClientMessage(playerid,COLOR_WARNING,"没有上一页");
	}
	else page[playerid]=pages;
	if(pages>floatround(rows/float(MAX_DILOG_LIST),floatround_ceil))
	{
		SendClientMessage(playerid,COLOR_WARNING,"没有该页");
		page[playerid]=1;
	}

    new string[2048],caption[64];
    new pager = (page[playerid]-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	format(caption,sizeof(caption), "ID\t问题\n");
	strcat(string,caption);
	strcat(string,"{FF8000}上一页\n");
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
	if(!isover)strcat(string, "{FF8000}下一页\n");

	new str[60];
	format(str,sizeof(str),"密保问题列表-共计[%i]",rows);
	Dialog_Show(playerid,dl_player_Question_show,DIALOG_STYLE_TABLIST_HEADERS,str,string, "选择", "返回");
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
            Dialog_Show(playerid,dl_Question_answer_set,DIALOG_STYLE_INPUT,"答案设置","请输入答案","确定","取消");
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
		if(strlen(inputtext)<2||strlen(inputtext)>256)return Dialog_Show(playerid,dl_Question_answer_set,DIALOG_STYLE_INPUT,"答案设置","请输入答案","确定","取消");
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
	    case ADMIN_SMALL:format(str,sizeof(str),"管理员\t后台\n");
		case ADMIN_MIDDLE:format(str,sizeof(str),"管理员\t高级\n");
		case ADMIN_LARGE:format(str,sizeof(str),"管理员\t初级\n");
		case ADMIN_NONE:format(str,sizeof(str),"管理员\t否\n");
	}
	strcat(string,str);
	format(str,sizeof(str),"注册时间\t%s\n",pdate[playerid][regtime]);
	strcat(string,str);
	switch(pdate[playerid][sex])
	{
	    case 0:format(str,sizeof(str),"性别\t男\n");
	    case 1:format(str,sizeof(str),"性别\t女\n");
	    case 2:format(str,sizeof(str),"性别\t不公开\n");
	}
	strcat(string,str);
	format(str,sizeof(str),"皮肤\t%i[%i]\n",pdate[playerid][skinid],GetPlayerSkin(playerid));
	strcat(string,str);
	format(str,sizeof(str),"年龄\t%i\n",pdate[playerid][age]);
	strcat(string,str);
	format(str,sizeof(str),"现金\t%i\n",pdate[playerid][cash]);
	strcat(string,str);
	format(str,sizeof(str),"存款\t%i\n",pdate[playerid][bank]);
	strcat(string,str);
	format(str,sizeof(str),"金币\t%i\n",pdate[playerid][gold]);
	strcat(string,str);
	format(str,sizeof(str),"等级\t%i\n",pdate[playerid][level]);
	strcat(string,str);
	format(str,sizeof(str),"积分\t%i\n",pdate[playerid][levelpoint]);
	strcat(string,str);
	format(str,sizeof(str),"颜色\t%s■■■■■■■■■\n",colorstr[pdate[playerid][colorid]]);
	strcat(string,str);
	if(pdate[playerid][depictcolorid]!=-1)format(str,sizeof(str),"签名\t%s%s\n",colorstr[pdate[playerid][depictcolorid]],pdate[playerid][depict]);
	else format(str,sizeof(str),"签名\t无\n");
	strcat(string,str);
	if(pdate[playerid][location])format(str,sizeof(str),"出生定位\t已设置\n");
	else format(str,sizeof(str),"出生定位\t未设置\n");
	strcat(string,str);
	if(pdate[playerid][verify])format(str,sizeof(str),"邮箱验证\t已验证\n");
	else format(str,sizeof(str),"邮箱验证\t未验证\n");
	strcat(string,str);
	if(pdate[playerid][questionid]==-1)format(str,sizeof(str),"密码保护\t关闭\n");
	else format(str,sizeof(str),"密码保护\t开启\n");
	strcat(string,str);
	if(pdate[playerid][offlinnotice])format(str,sizeof(str),"离线提醒\t开启\n");
	else format(str,sizeof(str),"离线提醒\t关闭\n");
	strcat(string,str);
	
	Dialog_Show(playerid,dl_stats,DIALOG_STYLE_TABLIST,caption,string,"选择","取消");
	return 1;
}

#include WD3/Account/Account_Cmd.pwn
