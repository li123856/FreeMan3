#include WD3/Log/Log_Define.pwn
#include WD3/Log/Log_Custom.pwn
ACT::AddLog(types,datestr[])
{
	new time[3], date[3],string[80];
    getdate(date[0],date[1],date[2]);
	gettime(time[0], time[1], time[2]);
	format(string,80, "%i/%i/%i %i:%i:%i",date[0],date[1],date[2], time[0], time[1], time[2]);
	format(Querys, sizeof(Querys),"INSERT INTO `"SQL_LOG"`(`type`,`logtime`,`logdate`)VALUES ('%i','%s','%s')",types,string,datestr);
	mysql_query(mysqlid,Querys,false);
}

public OnPlayerDisconnect(playerid, reason)
{
	if(Login[playerid])
	{
		new szDisconnectReason[3][] =
	    {
	        "超时/崩溃",
	        "离开",
	        "被T/封禁"
	    };
	    new string[128];
	    format(string,80, "%s离开服务器 %s",Pname[playerid],szDisconnectReason[reason]);
	    AddLog(LOG_TYPE_OUT,string);
	}
	return CallLocalFunction("Log_OnPlayerDisconnect", "ii",playerid,reason);
}
#if defined _ALS_OnPlayerDisconnect
   #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Log_OnPlayerDisconnect
forward Log_OnPlayerDisconnect(playerid,reason);


