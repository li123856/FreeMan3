#include WD3/Mail/Mail_Define.pwn
#include WD3/Mail/Mail_Custom.pwn
ACT::SendMail(playerid,ToMail[],Body[])
{
	new string[2048];
	format(string,sizeof(string),MAILER_URL,Body,ToMail);
  	HTTP(playerid,HTTP_GET,string,"","MailResponse");
	return 1;
}
ACT::SendMailEx(playerid,ToMail[],Body[])
{
	new string[2048];
	format(string,sizeof(string),MAILER_URL,Body,ToMail);
  	HTTP(playerid,HTTP_GET,string,"","MailResponseEx");
	return 1;
}
ACT::MailResponseEx(index, response_code, data[])
{
	if(IsPlayerConnected(index))
	{
	    new uidid=GetPVarInt(index,"UID_Current_ID");
	    if(pdate[index][uid]==uidid)
	    {
			if(strfind(data,"K", true) != -1)Dialog_Show(index,dl_entersecurity_quest, DIALOG_STYLE_INPUT,"发送成功","请打开你的邮箱,获取验证码,并在下方输入","确定","取消");
			else SendClientMessage(index,COLOR_TIP,"对不起,发送失败,无法操作本项目");
		}
	}
    return 1;
}
ACT::MailResponse(index, response_code, data[])
{
	if(IsPlayerConnected(index))
	{
	    new uidid=GetPVarInt(index,"UID_Current_ID");
	    if(pdate[index][uid]==uidid)
	    {
			if(strfind(data,"K", true) != -1)
			{
				Dialog_Show(index,dl_entersecurity, DIALOG_STYLE_INPUT,"发送成功","请打开你的邮箱,获取验证码,并在下方输入","确定","取消");
				pEnteTime[index]=defer EnteTime[60000](index);
			}
			else Dialog_Show(index,dl_enteremail, DIALOG_STYLE_INPUT,"发送失败","可能你的邮箱输入错误或不支持此邮箱,请重新输入或更换邮箱输入","确定","取消");
		}
	}
	printf("%s",data);
    return 1;
}
ACT::SendNoticeMail(ToMail[],Body[])
{
	new string[2048];
	format(string,sizeof(string),NOTICE_URL,Body,ToMail);
  	HTTP(11,HTTP_GET,string,"","NoticeMailResponse");
  	printf("%s",string);
	return 1;
}
ACT::NoticeMailResponse(index, response_code, data[])
{
    printf("%s",data);
    return 1;
}
ACT::SendGetPassMail(playerid,ToMail[],Body[])
{
	new string[2048];
	format(string,sizeof(string),GETKEY_URL,Body,ToMail);
  	HTTP(playerid,HTTP_GET,string,"","GetPassMailResponse");
  	printf("%s",string);
	return 1;
}
ACT::GetPassMailResponse(index, response_code, data[])
{
	if(IsPlayerConnected(index))
	{
	    new uidid=GetPVarInt(index,"UID_Current_ID");
	    if(pdate[index][uid]==uidid)
	    {
			if(strfind(data,"K", true) != -1)
			{
		    	SHA256_PassHash(pPass[index],Salt_ACCOUNT,pdate[index][passwords],129);
				format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `passwords` =  '%s' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",pdate[index][passwords],pdate[index][uid]);
				mysql_query(mysqlid,Querys,false);
			    Dialog_Show(index,dl_login, DIALOG_STYLE_PASSWORD,"登录","新密码已发入你的邮箱,请输入新密码登录","登录","取消");
			}
			else
			{
	            SendClientMessage(index,COLOR_TIP,"对不起,找回密码失败,请尝试重新登录");
				DKick(index,1000);
			}
		}
	}
	printf("%s",data);
    return 1;
}

