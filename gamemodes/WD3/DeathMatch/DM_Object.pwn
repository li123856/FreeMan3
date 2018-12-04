ACT::CreateDMTemplate(dmroom)
{
    new index=dm[dmroom][dm_map];
	foreach(new i:dmpobj[index])
	{
	    dmroomobj[dmroom][i][dmr_id]=CreateDynamicObject(dmpobj[index][i][dmo_model],dmpobj[index][i][dmo_x],dmpobj[index][i][dmo_y],dmpobj[index][i][dmo_z],dmpobj[index][i][dmo_rx],dmpobj[index][i][dmo_ry],dmpobj[index][i][dmo_rz],dm[dmroom][dm_wl],dmp[index][dmp_in]);
        Iter_Add(dmroomobj[dmroom],i);
	}
	return 1;
}
ACT::DestroyDMTemplate(dmroom)
{
	foreach(new i:dmroomobj[dmroom])DestroyDynamicObject(dmroomobj[dmroom][i][dmr_id]);
	return 1;
}
ACT::LoadDMTemplate(index,dmfilename[])
{
	new string[80],line=0,scount=0;
	format(string,sizeof(string),DM_TEMPLATES_FILE,dmfilename);
	if(fexist(string))
	{
		new File:DmFile=fopen(string,io_read),str[256],mid,Float:xx,Float:yy,Float:zz,Float:rxx,Float:ryy,Float:rzz;
		while(fread(DmFile,str)>0)
		{
		    if(line<MAX_DM_MAP_OBJ)
		    {
				switch(IsObjectCode(str))
				{
				    case LINE_DYNAMICOBJECT:
				    {
				        ClearLine(str,LINE_DYNAMICOBJECT);
				        if(sscanf(str,"P<(),>iffffff",mid,xx,yy,zz,rxx,ryy,rzz))printf("LINE_DYNAMICOBJECT 错误在%i.pwn,%i行",index,line+1);
						else
						{
						    dmpobj[index][line][dmo_model]=mid;
						    dmpobj[index][line][dmo_x]=xx;
						    dmpobj[index][line][dmo_y]=yy;
						    dmpobj[index][line][dmo_z]=zz;
						    dmpobj[index][line][dmo_rx]=rxx;
						    dmpobj[index][line][dmo_ry]=ryy;
						    dmpobj[index][line][dmo_rz]=rzz;
							Iter_Add(dmpobj[index],line);
						}
				    }
				    case LINE_OBJECT:
				    {
				        ClearLine(str,LINE_OBJECT);
				        if(sscanf(str,"P<(),>iffffff",mid,xx,yy,zz,rxx,ryy,rzz))printf("LINE_OBJECT 错误在%i.pwn,%i行",index,line+1);
						else
						{
						    dmpobj[index][line][dmo_model]=mid;
						    dmpobj[index][line][dmo_x]=xx;
						    dmpobj[index][line][dmo_y]=yy;
						    dmpobj[index][line][dmo_z]=zz;
						    dmpobj[index][line][dmo_rx]=rxx;
						    dmpobj[index][line][dmo_ry]=ryy;
						    dmpobj[index][line][dmo_rz]=rzz;
						    Iter_Add(dmpobj[index],line);
						}
				    }
				    case LINE_SPAWN:
				    {
				        ClearLine(str,LINE_SPAWN);
				        if(sscanf(str,"P<(),>iffff",mid,xx,yy,zz,rxx))printf("LINE_SPAWN 错误在%i.pwn,%i行",index,line+1);
						else
						{
						    if(scount<MAX_DM_ROOM_TEAM)
							{
	                            dmpspawn[index][mid][dms_x]=xx;
	                            dmpspawn[index][mid][dms_y]=yy;
	                            dmpspawn[index][mid][dms_z]=zz;
	                            dmpspawn[index][mid][dms_a]=rxx;
	                            Iter_Add(dmpobj[index],mid);
	                            scount++;
                            }
                            else printf("定位错误,超过2个,错误在%i.pwn,%i行",index,line+1);
						}
				    }
					default:printf("错误在%i.pwn,%i行",index,line+1);
				}
				line++;
			}
			else printf("错误在%i.pwn,DM模组已到极限%i/%i",index,line+1,MAX_DM_MAP_OBJ);
		}
		fclose(DmFile);
	}
	else return 0;
	return 1;
}


