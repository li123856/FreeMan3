ACT::ClearLine(line[],types)
{
	if(types==LINE_DYNAMICOBJECT)strdel(line, 0, 20);
	if(types==LINE_OBJECT)strdel(line, 0, 13);
	if(types==LINE_DOOR)strdel(line, 0, 11);
	if(types==LINE_MOVEDOOR)strdel(line, 0, 15);
	if(types==LINE_SPAWN)strdel(line, 0, 6);
	return 1;
}
ACT::IsObjectCode(line[])
{
	if(strfind(line,"CreateDynamicObject", false)!=-1)return LINE_DYNAMICOBJECT;
	if(strfind(line,"CreateObject",false)!=-1)return LINE_OBJECT;
	if(strfind(line,"CreateDoor",false)!=-1)return LINE_DOOR;
	if(strfind(line,"CreateMoveDoor",false)!=-1)return LINE_MOVEDOOR;
	if(strfind(line,"Sapwn",false)!=-1)return LINE_SPAWN;
	return 0;
}
ACT::ReloadHouseTemplate(index,houseid)
{
    foreach(new i:hobj[houseid])
	{
		if(hobj[houseid][i][ho_type]==MOVEDOOR_TYPE)DestroyDynamicArea(hobj[houseid][i][ho_area]);
		DestroyDynamicObject(hobj[houseid][i][ho_id]);
	}
	Iter_Clear(hobj[houseid]);
	switch(LoadHouseTemplate(index,houseid))
	{
		case 0:printf("无房产 %i.pwn 模版文件",house[houseid][h_hid]);
		case 1:
		{
			house[houseid][h_ox]=hobjdoor[houseid][0];
			house[houseid][h_oy]=hobjdoor[houseid][1];
			house[houseid][h_oz]=hobjdoor[houseid][2];
			house[houseid][h_oa]=hobjdoor[houseid][3];
			DeleteHouseFace(houseid);
			CreateHouseFace(houseid);
			printf("加载房产模版, %i.pwn 成功",house[houseid][h_hid]);
		}
		case 2:printf("加载房产模版,%.pwn 未发现门定位代码",house[houseid][h_hid]);
	}
	return 1;
}
ACT::LoadHouseTemplate(index,houseid)
{
	new string[80],line=0,doors=0;
	format(string,sizeof(string),TEMPLATES_FILE,index);
	if(fexist(string))
	{
		new File:housesFile=fopen(string,io_read),str[256],mid,speeds,Float:diss,Float:xx,Float:yy,Float:zz,Float:rxx,Float:ryy,Float:rzz,Float:xx1,Float:yy1,Float:zz1,Float:rxx1,Float:ryy1,Float:rzz1;
		while(fread(housesFile,str)>0)
		{
		    if(line<MAX_HOUSES_OBJ)
		    {
				switch(IsObjectCode(str))
				{
				    case LINE_DYNAMICOBJECT:
				    {
				        ClearLine(str,LINE_DYNAMICOBJECT);
				        if(sscanf(str,"P<(),>iffffff",mid,xx,yy,zz,rxx,ryy,rzz))printf("LINE_DYNAMICOBJECT 错误在%i.pwn,%i行",index,line+1);
						else
						{
						    hobj[houseid][line][ho_model]=mid;
						    hobj[houseid][line][ho_x]=xx;
						    hobj[houseid][line][ho_y]=yy;
						    hobj[houseid][line][ho_z]=zz;
						    hobj[houseid][line][ho_rx]=rxx;
						    hobj[houseid][line][ho_ry]=ryy;
						    hobj[houseid][line][ho_rz]=rzz;
						    hobj[houseid][line][ho_id]=CreateDynamicObject(mid,xx,yy,zz,rxx,ryy,rzz);
							Iter_Add(hobj[houseid],line);
						}
				    }
				    case LINE_OBJECT:
				    {
				        ClearLine(str,LINE_OBJECT);
				        if(sscanf(str,"P<(),>iffffff",mid,xx,yy,zz,rxx,ryy,rzz))printf("LINE_OBJECT 错误在%i.pwn,%i行",index,line+1);
						else
						{
						    hobj[houseid][line][ho_model]=mid;
						    hobj[houseid][line][ho_x]=xx;
						    hobj[houseid][line][ho_y]=yy;
						    hobj[houseid][line][ho_z]=zz;
						    hobj[houseid][line][ho_rx]=rxx;
						    hobj[houseid][line][ho_ry]=ryy;
						    hobj[houseid][line][ho_rz]=rzz;
						    hobj[houseid][line][ho_id]=CreateDynamicObject(mid,xx,yy,zz,rxx,ryy,rzz);
						    hobj[houseid][line][ho_type]=OBJECT_TYPE;
						    Iter_Add(hobj[houseid],line);
						}
				    }
				    case LINE_DOOR:
				    {
				        ClearLine(str,LINE_DOOR);
				        if(sscanf(str,"P<(),>ffff",xx,yy,zz,rxx))printf("LINE_DOOR 错误在%i.pwn,%i行",index,line+1);
						else
						{
                            hobjdoor[houseid][0]=xx;
                            hobjdoor[houseid][1]=yy;
                            hobjdoor[houseid][2]=zz;
                            hobjdoor[houseid][3]=rxx;
						}
						doors=1;
				    }
				    case LINE_MOVEDOOR:
				    {
				        ClearLine(str,LINE_MOVEDOOR);
				        if(sscanf(str,"P<(),>iifffffffffffff",mid,speeds,diss,xx,yy,zz,rxx,ryy,rzz,xx1,yy1,zz1,rxx1,ryy1,rzz1))printf("LINE_MOVEDOOR 错误在%i.pwn,%i行",index,line+1);
						else
						{
						    hobj[houseid][line][ho_model]=mid;
						    hobj[houseid][line][ho_speed]=speeds;
						    hobj[houseid][line][ho_dis]=diss;
						    hobj[houseid][line][ho_x]=xx;
						    hobj[houseid][line][ho_y]=yy;
						    hobj[houseid][line][ho_z]=zz;
						    hobj[houseid][line][ho_rx]=rxx;
						    hobj[houseid][line][ho_ry]=ryy;
						    hobj[houseid][line][ho_rz]=rzz;
						    
						    hobj[houseid][line][ho_mx]=xx1;
						    hobj[houseid][line][ho_my]=yy1;
						    hobj[houseid][line][ho_mz]=zz1;
						    hobj[houseid][line][ho_mrx]=rxx1;
						    hobj[houseid][line][ho_mry]=ryy1;
						    hobj[houseid][line][ho_mrz]=rzz1;
							hobj[houseid][line][ho_id]=CreateDynamicObject(mid,xx,yy,zz,rxx,ryy,rzz);
							hobj[houseid][line][ho_area]=CreateDynamicSphere(xx,yy,zz,hobj[houseid][line][ho_dis]);
							hobj[houseid][line][ho_type]=MOVEDOOR_TYPE;
						    Iter_Add(hobj[houseid],line);
						}
				    }
					default:printf("错误在%i.pwn,%i行",index,line+1);
				}
				line++;
			}
			else printf("错误在%i.pwn,房子模组已到极限%i/%i",index,line+1,MAX_HOUSES_OBJ);
		}
		fclose(housesFile);
		if(!doors)return 2;
	}
	else return 0;
	return 1;
}
ACT::OnplayerEnterHouseObjDoor(playerid,areaid)
{
	foreach(new x:house)
	{
		if(house[x][h_uid]==pdate[playerid][uid])
		{
			foreach(new i:hobj[x])
			{
			    if(hobj[x][i][ho_area]==areaid)return MoveDynamicObject(hobj[x][i][ho_id],hobj[x][i][ho_mx],hobj[x][i][ho_my],hobj[x][i][ho_mz],hobj[x][i][ho_speed],hobj[x][i][ho_mrx],hobj[x][i][ho_mry],hobj[x][i][ho_mry]);
	 		}
 		}
   	}
   	
	return 1;
}
ACT::OnplayerLeaveHouseObjDoor(playerid,areaid)
{
	foreach(new x:house)
	{
		if(house[x][h_uid]==pdate[playerid][uid])
		{
			foreach(new i:hobj[x])
			{
			    if(hobj[x][i][ho_area]==areaid)return MoveDynamicObject(hobj[x][i][ho_id],hobj[x][i][ho_x],hobj[x][i][ho_y],hobj[x][i][ho_z],hobj[x][i][ho_speed],hobj[x][i][ho_rx],hobj[x][i][ho_ry],hobj[x][i][ho_ry]);
	 		}
 		}
   	}

	return 1;
}

