#include WD3/Mysql/Mysql_Define.pwn
#include WD3/Mysql/Mysql_Custom.pwn
public OnGameModeInit()
{
	mysqlid = mysql_connect(HOST,USER_NAME,DB,PASSWARD);
	mysql_set_charset("gbk",mysqlid);
	if(mysql_errno(mysqlid) != 0)print("无法连接数据库!");
	else printf("数据库连接成功%s",DB);
	return CallLocalFunction("Mysql_OnGameModeInit", "");
}
#if defined _ALS_OnGameModeInit
   #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Mysql_OnGameModeInit
forward Mysql_OnGameModeInit();
public OnGameModeExit()
{
	mysql_close(mysqlid);
	return CallLocalFunction("Mysql_OnGameModeExit", "");
}
#if defined _ALS_OnGameModeExit
   #undef OnGameModeExit
#else
    #define _ALS_OnGameModeExit
#endif
#define OnGameModeExit Mysql_OnGameModeExit
forward Mysql_OnGameModeExit();
ACT::IsUidFexist(uid)
{
	format(Querys, sizeof(Querys), "SELECT `name` FROM `"SQL_ACCOUNT"` WHERE `uid` = '%i' LIMIT 1",uid);
	mysql_query(mysqlid,Querys);
	new rows=cache_get_row_count(mysqlid);
	if(rows)return 1;
	return 0;
}
GetUidName(uid)
{
	format(Querys, sizeof(Querys), "SELECT `name` FROM `"SQL_ACCOUNT"` WHERE `uid` = '%i' LIMIT 1",uid);
	mysql_query(mysqlid,Querys);
	new names[80];
	cache_get_field_content(0,"name",names,mysqlid,80);
	return names;
}

