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
			if(strfind(data,"K", true) != -1)Dialog_Show(index,dl_entersecurity_quest, DIALOG_STYLE_INPUT,"���ͳɹ�","����������,��ȡ��֤��,�����·�����","ȷ��","ȡ��");
			else SendClientMessage(index,COLOR_TIP,"�Բ���,����ʧ��,�޷���������Ŀ");
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
				Dialog_Show(index,dl_entersecurity, DIALOG_STYLE_INPUT,"���ͳɹ�","����������,��ȡ��֤��,�����·�����","ȷ��","ȡ��");
				pEnteTime[index]=defer EnteTime[60000](index);
			}
			else Dialog_Show(index,dl_enteremail, DIALOG_STYLE_INPUT,"����ʧ��","�������������������֧�ִ�����,����������������������","ȷ��","ȡ��");
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
			    Dialog_Show(index,dl_login, DIALOG_STYLE_PASSWORD,"��¼","�������ѷ����������,�������������¼","��¼","ȡ��");
			}
			else
			{
	            SendClientMessage(index,COLOR_TIP,"�Բ���,�һ�����ʧ��,�볢�����µ�¼");
				DKick(index,1000);
			}
		}
	}
	printf("%s",data);
    return 1;
}

