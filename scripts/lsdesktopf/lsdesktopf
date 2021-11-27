#!/usr/bin/env bash
# Version 1.0.7-4
#
# License: GPL3
#
# Author: Andy Crowd
# Tested in Arch Linux
# Search in *.desktop for "Categories" and "Exec"
#

if [[ ! -z "$NO_COLOR" && "${NO_COLOR^^}" == "YES"  ]];then
DISABLE_COLORS="YES";
else
DISABLE_COLORS="NO";
fi

unset IFS
IFS="
"
One="$1"
#Two="$2"
AddCmd=($@);

GlobalArray="/opt/share/ldf/sorted.test"
LocalArray="$HOME/.ldf/sorted.test"
#echo "BBBB " "${DESKTOP_FILES}"
#exit 0
### The DefDskPath variable contains list of default folders
if [[ ! -z "$DESKTOP_FILES"   ]];then
DEP_MAX="-maxdepth";
DEP_LV="1";
#DefDskPath=($(echo "$DESKTOP_FILES" | awk -F';' '{for(I=1;I <= NF-1;I++){TT=$I;gsub(/[0-9]/,"*",TT);gsub(/" "/,"*",TT);print TT} }' |grep -v ^$ ));
	if [[ "$DESKTOP_FILES" =~ ';'  ]];then
		DefDskPath=($(echo "$DESKTOP_FILES" | awk -F';' '{for(I=1;I <= NF-1;I++)print $I }' |grep -v ^$ ));
	else

		DefDskPath=($DESKTOP_FILES);
	fi
else
DefDskPath+=("/etc/dynamic/launchers/scanner")
DefDskPath+=("/etc/xdg/autostart")
DefDskPath+=("/etc/xdg/xfce*/panel/launcher-*")
DefDskPath+=("/lib/gnome-settings-daemon-*/gtk-modules")
DefDskPath+=("/lib/libreoffice/share/xdg")
DefDskPath+=("/usr/etc/xdg/autostart")
DefDskPath+=("/usr/lib/gnome-settings-daemon-*/gtk-modules")
DefDskPath+=("/usr/lib/libreoffice/share/xdg")
DefDskPath+=("/usr/local/share/applications")
DefDskPath+=("/usr/share/applications")
DefDskPath+=("/usr/share/apps/kdm/programs")
DefDskPath+=("/usr/share/apps/kdm/sessions")
DefDskPath+=("/usr/share/apps/solid/actions")
DefDskPath+=("/usr/share/autostart")
DefDskPath+=("/usr/share/dist/desktop-files/default")
DefDskPath+=("/usr/share/gdm/")
#DefDskPath+=("/usr/share/gdm/autostart")
#DefDskPath+=("/usr/share/gdm/autostart/LoginWindow")
#DefDskPath+=("/usr/share/gdm/greeter/autostart")
DefDskPath+=("/usr/share/gnome/autostart")
DefDskPath+=("/usr/share/kde*")
DefDskPath+=("/usr/share/mate/wm-properties")
DefDskPath+=("/usr/share/mga/dm")
DefDskPath+=("/usr/share/mimelnk/application")
DefDskPath+=("/usr/share/mimelnk/chemical")
DefDskPath+=("/usr/share/parole")
#DefDskPath+=("/usr/share/parole/parole-plugins-*")
DefDskPath+=("/usr/share/Thunar/sendto")
DefDskPath+=("/usr/share/wayland-sessions")
DefDskPath+=("/usr/share/xfce*/helpers")
DefDskPath+=("/usr/share/xfce*/panel-plugins")
DefDskPath+=("/usr/share/xfce*/panel/plugins")
DefDskPath+=("/usr/share/xgreeters")
DefDskPath+=("/usr/share/xsessions")
DefDskPath+=("/etc/xdg/autostart")
DefDskPath+=("/opt/teamviewer/tv_bin/desktop")
DefDskPath+=("/opt/wine-staging/share/applications")
DefDskPath+=("/usr/lib/gnome-settings-daemon-*.*/gtk-modules")
DefDskPath+=("/usr/lib/libreoffice/share/xdg")
DefDskPath+=("/usr/local/share/applications")
DefDskPath+=("/usr/share/applications")
DefDskPath+=("/usr/share/applications/inputmethods")
DefDskPath+=("/usr/share/apps/solid/actions")
DefDskPath+=("/usr/share/gnome/autostart")
DefDskPath+=("/usr/share/hedgewars/Data/misc")
DefDskPath+=("/usr/share/J*Z/Desktop/KDE")
DefDskPath+=("/usr/share/J*Z/Desktop/Menu")
DefDskPath+=("/usr/share/kde*/services")
DefDskPath+=("/usr/share/kde*/services/phononbackends")
DefDskPath+=("/usr/share/kde*/services/ServiceMenus")
DefDskPath+=("/usr/share/kservices*")
DefDskPath+=("/usr/share/kservices*/qimageioplugins")
DefDskPath+=("/usr/share/kservicetypes*")
DefDskPath+=("/usr/share/lirc/contrib")
DefDskPath+=("/usr/share/mimelnk/application")
DefDskPath+=("/usr/share/phoronix-test-suite/pts-core/static")
DefDskPath+=("/usr/share/Quamachi/Desktop/Menu")
DefDskPath+=("/usr/share/speech-dispatcher/conf/desktop")
DefDskPath+=("/usr/share/themes/")
DefDskPath+=("/usr/share/Thunar/sendto")
DefDskPath+=("/usr/share/xfce*/helpers")
DefDskPath+=("/usr/share/xfce*/panel-plugins")
DefDskPath+=("/usr/share/xfce*/panel/plugins")
DefDskPath+=("/usr/share/xsessions")
fi
##########################################
AddKorora(){
 DefDskPath+=("/usr/lib64/gnome-settings-daemon-*/gtk-modules")
 DefDskPath+=("/usr/lib64/libreoffice/share/xdg")
 DefDskPath+=("/usr/share/akonadi/agents")
 DefDskPath+=("/usr/share/anaconda/gnome")
 DefDskPath+=("/usr/share/applications")
 DefDskPath+=("/usr/share/applications/kde*")
 DefDskPath+=("/usr/share/carddecks")
# DefDskPath+=("/usr/share/doc")
 DefDskPath+=("/usr/share/gcompris")
 DefDskPath+=("/usr/share/gdm/autostart/LoginWindow")
 DefDskPath+=("/usr/share/kcm_componentchooser")
 DefDskPath+=("/usr/share/kcmsolidactions")
 DefDskPath+=("/usr/share/kf*/kmoretools/presets-kmoretools")
 DefDskPath+=("/usr/share/kf*/locale/countries")
 DefDskPath+=("/usr/share/kf*/locale/currency")
 DefDskPath+=("/usr/share/khelpcenter/plugins")
 DefDskPath+=("/usr/share/khelpcenter/searchhandlers")
 DefDskPath+=("/usr/share/kio_desktop")
 DefDskPath+=("/usr/share/kmines/themes")
 DefDskPath+=("/usr/share/konqsidebartng/virtual_folders/remote")
 DefDskPath+=("/usr/share/konqsidebartng/virtual_folders/services")
 DefDskPath+=("/usr/share/konqueror/dirtree/remote")
 DefDskPath+=("/usr/share/konversation/themes")
 DefDskPath+=("/usr/share/kpackage/kcms/kcm_energyinfo")
 DefDskPath+=("/usr/share/kpackage/kcms/kcm_fileindexermonitor")
 DefDskPath+=("/usr/share/kpackage/kcms/kcm_lookandfeel")
 DefDskPath+=("/usr/share/kpackage/kcms/kcm_splashscreen")
 DefDskPath+=("/usr/share/kpat/themes")
 DefDskPath+=("/usr/share/kservicetypes*")
 DefDskPath+=("/usr/share/ksmserver/screenlocker/org.kde.passworddialog")
 DefDskPath+=("/usr/share/ksmserver/themes")
 DefDskPath+=("/usr/share/ksmserver/windowmanagers")
 DefDskPath+=("/usr/share/ksysguard/scripts/smaps")
 DefDskPath+=("/usr/share/kwin/decorations/kwin*_decoration_qml_plastik")
 DefDskPath+=("/usr/share/kwin/desktoptabbox/previews")
 DefDskPath+=("/usr/share/kwin/effects")
 DefDskPath+=("/usr/share/kwin/scripts")
 DefDskPath+=("/usr/share/kwin/tabbox")
 DefDskPath+=("/usr/share/kxmlgui*/parley/themes")
 DefDskPath+=("/usr/share/lirc/contrib")
 DefDskPath+=("/usr/share/locale/")
 #DefDskPath+=("/usr/share/locale/l10n")
 DefDskPath+=("/usr/share/parley/plugins")
 DefDskPath+=("/usr/share/parley/themes")
 DefDskPath+=("/usr/share/plasma/desktoptheme")
 DefDskPath+=("/usr/share/plasma/kcms/screenlocker_kcm")
 DefDskPath+=("/usr/share/plasma/layout-templates")
 DefDskPath+=("/usr/share/plasma/look-and-feel")
 DefDskPath+=("/usr/share/plasma/packages")
 DefDskPath+=("/usr/share/plasma/plasmoids")
 DefDskPath+=("/usr/share/plasma/shareprovider")
 DefDskPath+=("/usr/share/plasma/shells")
 DefDskPath+=("/usr/share/plasma/wallpapers")
 DefDskPath+=("/usr/share/remoteview")
 DefDskPath+=("/usr/share/sddm/themes")
 DefDskPath+=("/usr/share/services")
 DefDskPath+=("/usr/share/solid/actions")
 DefDskPath+=("/usr/share/solid/devices")
 DefDskPath+=("/usr/share/soprano/plugins")
 DefDskPath+=("/usr/share/templates")
 DefDskPath+=("/usr/share/wallpapers")
 DefDskPath+=("/usr/share/yumex-dnf")
}
##########################################
### Uncomment below to add directories found in Korora Linux
#AddKorora
#####

less_sys(){
	find  /usr /etc /opt -type f \( -name "*.desktop" -o -name "*.directory" \) -exec awk  -v CLR="$DISABLE_COLORS" -v FindIt="$2" -v Trans="$3" -F= '/^create/;{ 
		ToLowerTwo=tolower($2);
		ToLowerFindIt=tolower(FindIt);
			if(Trans)
			{
			split(Trans,ArrayTransLang,",");
			for(ReLangArray in ArrayTransLang )NewArrTrans[ArrayTransLang[ReLangArray]]=1;
			}				
		if(index($1,"]") == 0)
			{
			Var[CountV++]=$1;
			InString[CountS++]=substr($0,index($0,$2));
			if(FindIt)if(index(ToLowerTwo,ToLowerFindIt) != 0)YES="1"; 
			};
		if(index($1,"[") != 0 && index($1,"[") != 1 ){
			split($1,Lang,"[");			
			TmpLang=Lang[2];		
			UniqLang[TmpLang]++;
			sub("]","",TmpLang);
			if(Trans)
			  {
			  if( NewArrTrans[TmpLang] == 1 )
			   {   
			  Var[CountV++]=$1;
			  InString[CountS++]=substr($0,index($0,$2))
		  	   }			  				
			  }						 
			};
			if(index($1,"[") == 1){
			Var[CountV++]=$1;
			InString[CountS++]=$0}			
			}END{
		if(YES == "1" )
			{
				if(CLR == "YES")
				{
				printf "*  " FILENAME "@ Total translations: "length(UniqLang)": ";
				}else{
				printf "* \033[2;32m" FILENAME "\033[0m\n@ Total translations: "length(UniqLang)": ";
				}
			if(length(UniqLang) != 0)for(AllLang in UniqLang){sub("]","",AllLang);printf "%s",AllLang",";}				
			print " ";
			for (I in InString)if(index(Var[I],"[") != 1 && length(Var[I]) != 0 && index(Var[I],"#") != 1 )
				{	
						if(index(InString[I]"=",Var[I]"=") != 1 )
							{
							print Var[I]"="InString[I]
							}
						else
							{	
							print Var[I]"="
							}			
				}
				else
				{
					if(index(Var[I],"[") == 1) 
						
						if(CLR == "YES")
						{
						printf Var[I]"\n"
						}else{
						printf "\033[2;33m"Var[I]"\033[2;0m\n"
						}
				}
			}
		if(length(FindIt) == 0)
			{
				if(CLR == "YES")
				{
				printf "* " FILENAME " \n@ Total translations: "length(UniqLang)": ";
				}else{
				printf "* \033[2;32m" FILENAME "\033[0m \n@ Total translations: "length(UniqLang)": ";
				}
			if(length(UniqLang) != 0)for(AllLang in UniqLang)
				{
					sub("]","",AllLang);printf "%s",AllLang",";
				}
				print " ";
				for (I in InString)
					if(index(Var[I],"[") != 1 && length(Var[I]) != 0 && index(Var[I],"#") != 1  )
						{
							if(index(InString[I]"=",Var[I]"=") != 1 )
								{
								print Var[I]"="InString[I]
								}
							else
								{	
								print Var[I]"="
								}
						}
						else
						{ 
							if(index(Var[I],"[") == 1)
								if(CLR == "YES")
								{
						       		printf Var[I]"\n"
								}else{
						       		printf "\033[2;33m"Var[I]"\033[2;0m \n"
								}
						}
			}
			     }'  "{}"  \;
	}
	
BaseVarUpdate(){

if [[  ! -f "$LocalArray" ]];then
	if [[  -f "$GlobalArray" ]];then
	FilePath="$GlobalArray"

	else
### ADskPath contains list of "decoded" path with command "file"
### command "file" can handle wildcards such as * that is useful when it is multiple or new path with versions number is available
### command "grep" is used to separate available from not existing path
#for FromDDP in "${DefDskPath[@]}";do
#if [[ ! -z "$FromDDP"  ]];then  
#	echo "$FromDDP"
#fi
#done;
#exit 0
#echo "DEF_DSK_PATH ${#DefDskPath[@]}"
#echo "DEF_DSK_PATH LIST:::= ${DefDskPath[@]}"

######

ADskPath=($(for FromDDP in "${DefDskPath[@]}";
	do
if [[ ! -z "$(echo $FromDDP| grep -v -e "^\ " -e ^$ -e ';')" ]];
 then
	file "$FromDDP" 
fi
done |\
	sort -u |\
       	grep -v -e \)$ -e ^$ |\
       	grep ^/ |\
	rev|\
	cut -d: -f2- |\
	rev))

####################
	fi
else
	FilePath="$LocalArray"
fi

#echo "ADSK ==  ${#ADskPath[@]}"
#exit 0

if [[ "${#ADskPath[@]}" == 0 ]]; then

	ADskPath=($(sed -i -e 's/[0-9][0-9]*/*/g' -e 's/"//g' -e 's/\/$//g' -e 's/ /*/g' "$FilePath";
	while read FromFile;do echo "$FromFile"  ; 
	done < "$FilePath"|\
		xargs file|\
		sort -u |\
	       	grep -v \)$ |\
		grep ^/ |\
		rev|\
		cut -d: -f2-|\
		rev));


### $BDskPath is used to add path that depends on such variables as $HOME and $XDG related
 BDskPath+=("$HOME/.local/share/applications")
 BDskPath+=("$HOME/.config/autostart")
 BDskPath+=("/home/$USER/.local/share/applications")
 BDskPath+=("/home/$USER/.config/autostart")

 # BDskPath+=("$XDG_CONFIG_DIRS/autostart")
 BDskPath+=("$XDG_CONFIG_HOME/autostart")
 BDskPath+=("$HOME/.local/share/xfce*/helpers")
 BDskPath+=("/home/$USER/.local/share/xfce*/helpers")
 BDskPath+=("$XDG_DATA_HOME/applications")

fi


for AddWithVariables in "${BDskPath[@]}"; do
	if [ -d "$AddWithVariables" ];then
		ADskPath+=("$AddWithVariables");

	fi
done 
### soring out only unique path in case if $XDG related and $HOME are pointing on a similar destination. || $InDskPath, $ADskPath, NoEmpty
NoEmpty=($(for InDskPath in "${ADskPath[@]}";do echo "$InDskPath";done|sort -u;));
}

### used to find out path that can be used || scan-sys-path, $DskPath, NoEmpty
ReCreateDskPath(){
case "$Opts" in
	OnlyNew1 )
DskPath=($(if [[ ! -z $2 ]]; then  
	 for StartCmdLine in "$@";
	 	do
 		if [[ -d "$StartCmdLine" ]]; then
		  InPath="$StartCmdLine"
 		fi
 		if [[ "$InPath" == "/" ]];then 
  		exit 0
 		fi
	done
else
	find / -type f \( -name "*.desktop" -o -name "*.directory" \) -exec dirname "{}" \; |sort -u
fi))
;;
	scan-sys-path )
		DskPath=($(find "/usr/"  "/etc/" "/opt/"  -type f -name "*\.desktop" -exec dirname "{}" \;|sort -u))
		;;
	*)
	DskPath=(${NoEmpty[@]})
	;;
esac
}
########################################
gdxstdalone(){      		
IFS="
"	
	case $2 in
			g | glob )
				List_XML=($(find "/usr/" "/etc/" "$HOME/.local/" "$HOME/.config"  -type f -name "*\.xml"));
			;;
			l | local )
				List_XML=($(find  "$HOME/.config" "$HOME/.local/" -type f -name "*\.xml"));
			;;
			* )
				List_XML=($(find "/usr/share/mime/packages/" "/usr/share/mime/application/" "$HOME/.local/share/" -type f -name "*\.xml"));     
	    		 ;;
		esac

	case $2 in
	0 )
	 for In_XML_List in "${List_XML[@]}";do
	find "$In_XML_List" -type f -name "*\.xml" -exec grep -e "mime-type" -e "type=" "{}" \;
		done | awk -v CLR="$DISABLE_COLORS"  -F"\"" '{
	if(index($0,"mime-type")){
		if(index($0,"type type=")){
			ContentArray[$2]=1;
			}else{
				if(index($0," type=")){			
		ContentArray[$4]=1}}}}END{for (I in ContentArray)print I}'
	;;
	1 )
	 for In_XML_List in "${List_XML[@]}";do
	find "$In_XML_List" -type f -name "*\.xml" -exec grep -e "mime-type" -e "type=" "{}" \;
		done | awk  -v CLR="$DISABLE_COLORS" -F"\"" '{
	if(index($0,"mime-type")){
		if(index($0,"type type=")){
			A=substr($2,0,index($2,"/")-1);
		ContentArray[A]=1;
			}else{
				if(index($0," type=")){
			B=substr($4,0,index($4,"/")-1);
		ContentArray[B]=1}}}}END{for (I in ContentArray)print I}'
	;;
	2 )
	 for In_XML_List in "${List_XML[@]}";do
	find "$In_XML_List" -type f -name "*\.xml" -exec grep -e "mime-type" -e "type=" "{}" \;
		done | awk - -v CLR="$DISABLE_COLORS" F"\"" '{
	if(index($0,"mime-type")){
		if(index($0,"type type=")){
			A=substr($2,index($2,"/")+1);
		ContentArray[A]=1;
			}else{
				if(index($0," type=")){
			B=substr($4,index($4,"/")+1);
		ContentArray[B]=1}}}}END{for (I in ContentArray)print I}'
	;;
	3 )
	 for In_XML_List in "${List_XML[@]}";do
	find "$In_XML_List" -type f -name "*\.xml" -exec grep "pattern=" "{}" \;
		done | awk  -v CLR="$DISABLE_COLORS" -F"\"" '{
			if(index(tolower($0),"pattern="))ContentArray[$2]=1;			
			}END{
				for (I in ContentArray)print I
				}'
	;;
	-gfx)
	for In_XML_List in "${List_XML[@]}";do
	find "$In_XML_List" -type f -name "*\.xml" -exec awk  -v CLR="$DISABLE_COLORS" -v ShowItems="$3" '{		
	if(index($0,"<mime-type") != 0)
		{
			Astop=1;		
		MimeTag=$0;
		NumMtag=split(MimeTag,GetMIMEinTag,"type=\"");	
	};
	if(index($0,"</mime-type>") != 0){Astop=2;YES=0;
ShowMIME="";
ShowSubClass="";
ShowGenericIcon="";
ShowAcronym="";
ShowEAcronym="";
ShowAlias="";
GAcal=0;
};
	if(Astop == 1)
		{
			if(index($0,"<magic") == 0 && index($0,"magic>") == 0 && index($0,"<match") == 0 )
			{
				SP=SP sprintf( "%s",$0);
				AltFix=SP;
			}
		}
	else
		{ShowMIME=substr(GetMIMEinTag[2],0,index(GetMIMEinTag[2],"\"")-1);
		NumPatt=split(SP,GG,"pattern");
			if(index(SP,"<comment>") != 0)
				{
					Acomment=substr(SP,index(SP,"<comment>")+9);
					Bcomment=substr(Acomment,0,index(Acomment,"</comment>")-1);	
				}
			else
				{
					Acomment=substr(SP,index(SP,"<comment ")+9);
					TMPcomment=substr(Acomment,0,index(Acomment,"</comment>")-1);		
					Bcomment=substr(TMPcomment,index(Acomment,">")+1);					
				};
			if(index(SP,"<sub-class-of") != 0)
				{
					StartTagSSC=substr(SP,index(SP,"sub-class-of")+12)
					EndTagSSC=substr(StartTagSSC,0,index(StartTagSSC,">")-2);
					gsub(/ type=/,"Sub class of: ",EndTagSSC);
					ShowSubClass=EndTagSSC;				
				}
			if(index(SP,"<generic-icon") != 0)
				{
					StartTagGI=substr(SP,index(SP,"generic-icon")+12)
					EndTagGI=substr(StartTagGI,0,index(StartTagGI,">")-2);
					gsub(/ name=/,"Icon: ",EndTagGI);
					ShowGenericIcon=EndTagGI;				
				}
				if(index(SP,"<acronym>") != 0)
				{
					StartTagAcr=substr(SP,index(SP,"<acronym>")+9)
					EndTagAcr=substr(StartTagAcr,0,index(StartTagAcr,"/")-2);				
					ShowAcronym=EndTagAcr;				
				}
				if(index(SP,"<expanded-acronym>") != 0)
				{
					StartTagEAcr=substr(SP,index(SP,"<expanded-acronym>")+18)
					EndTagEAcr=substr(StartTagEAcr,0,index(StartTagEAcr,"/")-2);				
					ShowEAcronym=EndTagEAcr;				
				}
			if(index(SP,"<alias") != 0)
				{
					StartTagAlias=substr(SP,index(SP,"<alias")+6)
					EndTagAlias=substr(StartTagAlias,0,index(StartTagAlias,">")-2);
					gsub(/ type=/,"Alias: ",EndTagAlias);
					ShowAlias=EndTagAlias;				
				};			
				for(I=0; I <= NumPatt;I++)
			{
				GetStr=substr(GG[I],0,index(GG[I],"\"/>"));
				if(index(GetStr,"=") == 1 ){printf substr(GetStr,2);					
					if(length(Bcomment) == 0){printf " ----- %s",ShowMIME}else{printf " ----- %s",Bcomment};
					if(length(ShowMIME) == 0 && length(Bcomment) == 0)
						{
							AnewMIME=substr(AltFix,index(AltFix,"mime-type")+1);
							BnewMIME=substr(AnewMIME,0,index(AnewMIME,">")-1);
							CnewMIME=substr(BnewMIME,index(BnewMIME,"type=\"")+5);
							printf CnewMIME;		
						};
						NumberItems=split(ShowItems,ArrayItems,",");						
						ShowFileName=FILENAME;
						for( getItem in ArrayItems){	
					if(ArrayItems[getItem] == "sf" && ShowFileName ){
		if(CLR == "YES"){
			if(CLR == "YES")
			{
			printf " @* %s",ShowFileName;ShowFileName="";
			}else{
			printf " @*\033[2;32m %s",ShowFileName"\033[0m";ShowFileName="";
			}
		}else{
		printf " @* %s",ShowFileName"";ShowFileName="";
		}

	}	
					if(ArrayItems[getItem] == "sm" && ShowMIME )
	{
		if(CLR == "YES"){
		printf " @* %s",ShowMIME;
		}else{
		printf " @*\033[2;93m %s",ShowMIME"\033[0m";
		}
	}
					if(ArrayItems[getItem] == "ssc" && ShowSubClass)
	{
		if(CLR == "YES"){
		printf " @* " %s",ShowSubClass;ShowSubClass="";
		}else{
		printf " @*\033[2;53m %s",ShowSubClass"\033[0m";ShowSubClass="";
		}
	}
					if(ArrayItems[getItem] == "sgi" && ShowGenericIcon)
	{
		if(CLR == "YES"){
		printf " @* %s",ShowGenericIcon;ShowGenericIcon=""
		}else{
		printf " @*\033[2;49m %s",ShowGenericIcon"\033[0m";ShowGenericIcon=""
		}
	}
					if(ArrayItems[getItem] == "sa" && ShowAcronym)
	{
		if(CLR == "YES"){
		printf " @* %s",ShowAcronym;ShowAcronym=""
		}else{
		printf " @*\033[2;49m %s",ShowAcronym"\033[0m";ShowAcronym=""
		}
	}
					if(ArrayItems[getItem] == "sea" && ShowEAcronym)
	{
		if(CLR == "YES"){
		printf " @* %s",ShowEAcronym;ShowEAcronym=""
		}else{
		printf " @*\033[2;49m %s",ShowEAcronym"\033[0m";ShowEAcronym=""
		}
	}
					if(ArrayItems[getItem] == "sal" && ShowAlias)
						{							
							TotalAliases=split(SP,GetAliasStart,"<alias")-1;			
							if(CLR == "YES")
							{
							printf " @* Alias:";
							}else{
							printf " @*\033[2;49m Alias:";
							}
								for(T in GetAliasStart)
									{
									GetAls[GAcal++]=substr(GetAliasStart[T],0,index(GetAliasStart[T],">")-2);
									};
									if(TotalAliases >= 0)for (II in GetAls)
									 if(index(GetAls[II],"<") <= index(GetAls[II],"/>") )
									 printf substr(GetAls[II],index(GetAls[II],"=")+1)";";
									delete GetAls;						
							if(CLR != "YES")printf "\033[0m"
						}
					}
				printf "\n";}
		}
		SP=1}		
	}' "{}" \;
	done
	;;
	-gx ) if [[ ! -z "$3" ]];then
		for In_XML_List in "${List_XML[@]}";do
	find "$In_XML_List" -type f -name "*\.xml" -exec grep -e "mime-type" -e "type=" "{}" \;
		done | awk  -v CLR="$DISABLE_COLORS" -F"\"" -v FindForType="$3" '{
	if(index($0,"mime-type")){
		if(index($0,"type type=")){
			A=substr($2,index($2,"/")+1);
			if(FindForType ==  substr($2,0,index($2,"/")-1))
				ContentArray[A]=1;
			}else{
				if(index($0," type=")){
			B=substr($4,index($4,"/")+1);
			if(FindForType ==  substr($2,0,index($2,"/")-1))
				ContentArray[B]=1
		}}}}END{for (I in ContentArray)print I}'
			else
			echo 'Missing options! Use first part of MIME-type,e.g. inode'
			fi
		;;
	*) 
	  for In_XML_List in "${List_XML[@]}";do
		find "$In_XML_List" -type f -name "*\.xml" -print0 | xargs -0 awk  -v CLR="$DISABLE_COLORS" -F"\"" '{YesM=0;
		if(index($0,"mime-type")){if(index($0,"type type=")){ContentArray[Count++]=$2" == ";YesM=1}else{if(index($0," type=")){
			ContentArray[Count++]=$4" == "}}}				
		if(index($0,"<comment>")){
			GetString=substr($0,index($0,">")+1)
			GetTMP=" "substr(GetString,0,index(GetString,"</")-1)" \n";			
			ContentArray[Count++]=GetTMP;
			YesC=1
			};
		if(index(tolower($0),"pattern="))
		{
		ContentArray[Count++]=$2" ;\n";		
		}
			}END{
			if(CLR == "YES"){
			printf "\n@ "FILENAME"\n";
			}else{
			printf "\n@ \033[2;32m"FILENAME"\033[0m\n";
			};
		for(GetContent in ContentArray){
			if(index(ContentArray[GetContent],"==") != 0 )printf "\n";
			if(split(ContentArray[GetContent],TMP,"/") != 1  && index(ContentArray[GetContent],"==") == 0)
				{
				printf "\n %s",ContentArray[GetContent];
			}else{
				printf "%s",ContentArray[GetContent];
				};
			};
				}' ;			
				done	
		;;
		esac
}
### ListDefault listing or searching in default output for content of Name, Exec, Comment. || awk, DskPath, fdPath
ListDefault(){
for fdPath in "${DskPath[@]}";do
	if [[ ! -z "$1"   ]];then
 if [[ "$One" ==  "--all-sys-path" || "$1" == --asc ]];then
	 One="$2"
 fi
fi
if [[ -d "${DskPath[Count]}" || -f "${DskPath[Count]}"  ]];
then
	if [[ "$DISABLE_COLORS" == "YES" ]];then	
		printf "# %s ${fdPath} \n";
	else
		printf "#\e[1;36m %s ${fdPath} \e[0m \n";	
	fi;
  if [ ! -z "$One" ] && [[ -d "${fdPath}" || -f "${fdPath}" ]] ;
    then
     find "${fdPath}" $DEP_MAX $DEP_LV  -iname "*\.desktop" -exec awk  -v CLR="$DISABLE_COLORS" -v Fil="{}"  -v Seek="$One" -F"=" '//{
if(index($0,"Categories=") >= 1) Ctgr=substr($0,index($0,"=")+1);
if(index($0,"Name=")       == 1) inNm=substr($0,index($0,"=")+1);
if(index($0,"Comment=")    == 1) inComment=substr($0,index($0,"=")+1);
if(index($0,"Command")     == 1) inCmd=substr($0,index($0,"=")+1) ;
if(index($0,"Module=")     == 1) inExc=substr($0,index($0,"=")+1);
if(index($0,"Exec=")       == 1) inExc=substr($0,index($0,"=")+1);
if(index($0,"Category=") >= 1) Ctgr=substr($0,index($0,"=")+1);
if(index($0,"X-XFCE-Binaries=") >= 1) inExc=substr($0,index($0,"=")+1);
     }END{
if(! Ctgr ){E=inNm}else{E=Ctgr};
if(! inExc){CmdLine=inCmd}else{CmdLine=inExc};
if(! E)E=inComment;
 Z=CmdLine" # "E" #  "Fil;
if( index(tolower(Z),tolower(Seek)) && CmdLine  )  print Z;}' "{}" \;
    else
[[ -d "${fdPath}" || -f "${fdPath}" ]] && find "${fdPath}" -iname "*.desktop" -exec awk  -v CLR="$DISABLE_COLORS" -v Fil="{}"  -F"=" '//{
if(index($0,"Categories") == 1) Ctgr=substr($0,index($0,"=")+1);
if(index($0,"Name=")      == 1) inNm=substr($0,index($0,"=")+1);
if(index($0,"Exec=")      == 1) inExc=substr($0,index($0,"=")+1);
if(index($0,"Comment=")   == 1) inComment=substr($0,index($0,"=")+1);
if(index($0,"Command=")   == 1) inCmd=substr($0,index($0,"=")+1) ;
if(index($0,"Category=") >= 1) Ctgr=substr($0,index($0,"=")+1);
if(index($0,"X-XFCE-Binaries=") >= 1) inExc=substr($0,index($0,"=")+1);
}END{
if(! Ctgr ){E=inNm}else{E=Ctgr};
if(! inExc){CmdLine=inCmd}else{CmdLine=inExc};
if(! E)E=inComment;
 Z=CmdLine" # "E" # "Fil" # "XFCEb;
if(CmdLine)print Z;}' "{}" \;
 fi;
fi
done
}
###################  Search specific ####
OffPrint="no";
SearchContentOfVariable(){
for fdPath in "${DskPath[@]}";do
if [[ -d "${DskPath[Count]}" || -f "${DskPath[Count]}"  ]];
 then
if [[ "$OffPrint" == "no" ]]; then
 	if [[ "$DISABLE_COLORS" == "YES" ]];then 
		printf "# %s ${fdPath} \n";
 	else
		printf "#\e[1;36m %s ${fdPath} \e[0m \n";
	fi
fi
   if [ ! -z "$One" ] && [[ -d "${fdPath}" || -f "${fdPath}" ]] ;
    then 
	case $Opts in
### "$var" is used to search for variable names with "grep" in *.desktop
	var )
		grep -e ^"$Var" "${AddCmd[@]:2}" -H -E -R --include "*\.desktop" "${fdPath}"  

		;;
### "ddp" is used to raw dump cotent of all *.desktop found in default path. || grep
	ddp ) 
[[ -z "$DESKTOP_FILES" ]] && grep ^ -H -R --include "*\.desktop" "${fdPath}"  ;
[[ ! -z "$DESKTOP_FILES" ]] &&  find "${fdPath}" $DEP_MAX $DEP_LV  -type f -iname "*\.desktop" -exec cat "{}" \;
		;;
### "sud" showing unique variables found in default path. || grep, cut
	sud )
[[ -z "$DESKTOP_FILES" ]] && grep '=' -R -h --include "*\.desktop" --include "*\.directory" "${fdPath}" | cut -d= -f 1|grep -v -e "\[" -e ^\# |sort -u

[[ ! -z "$DESKTOP_FILES" ]] &&	find "${fdPath}" $DEP_MAX $DEP_LV  -type f \( -name "*.desktop" -o -name "*.directory" \) -exec grep '=' "{}" \; | cut -d= -f 1|grep -v -e "\[" -e ^\# |sort -u
		;;
### "sude"  show unique variables with examples
  	sude )
	[[ -z "$DESKTOP_FILES" ]] &&  grep '=' -R -h --include "*\.desktop" "${fdPath}" | awk -F= '//{if(index($1,"]") == 0 && index($1,"#") == 0)if(length($2) != 0)GetVars[$1]=substr($0,index($0,$2));}END{for(II in GetVars)print II "="GetVars[II] }' | sort
	[[ ! -z "$DESKTOP_FILES" ]] &&  find "${fdPath}" $DEP_MAX $DEP_LV  -type f -iname "*\.desktop" -exec grep '=' "{}" \;| awk -F= '//{if(index($1,"]") == 0 && index($1,"#") == 0)if(length($2) != 0)GetVars[$1]=substr($0,index($0,$2));}END{for(II in GetVars)print II "="GetVars[II] }' | sort

		;;
### "no-var" showing all *.desktop except them that contains contains specified string. || grep, find
	no-var )
		find "${fdPath}" $DEP_MAX $DEP_LV  -type f -iname "*\.desktop" -exec grep -H -L -e "$Var" "${AddCmd[@]:2}" "{}" \;
		;;
### "dsn" showing only unique section names found in default path. || grep, sed 
	dsn )
[[ -z "$DESKTOP_FILES" ]] && 	grep '\[*\]'$ -R -h --include "*\.desktop" --include "*\.directory" "${fdPath}" | sed 's/ * //m' |grep ^'\[' |grep -v -e ^'#' -e '\]=' |sort -u
[[ ! -z "$DESKTOP_FILES" ]] &&  find "${fdPath}" $DEP_MAX $DEP_LV  -type f \( -name "*.desktop" -o -name "*.directory" \) -exec grep '\[*\]'$ "{}" \; | sed 's/ * //m' |grep ^'\[' |grep -v -e ^'#' -e '\]=' |sort -u 
		;;
	upfd )
		if [[ ! -z "$2"  ]];then FLang="$2";
		else
			FLang="";
		fi

		find "${fdPath}" $DEP_MAX $DEP_LV  -type f \( -name "*.desktop" -o -name "*.directory" \) -exec awk  -v CLR="$DISABLE_COLORS" -v GetLang="$FLang" -v ShowAvailableLanguages="$3"  -F= '//{
		if(index($1,"[") != 0 && index($1,"[") != 1 ){split($1,Lang,"[")UniqLang[Lang[2]]++};
		if(index($1,"["GetLang"]") != 0 ){Item[cnt++]=$0}else { if(index($1,"]") == 0)Item[cnt++]=$0}
		}END{
			if (CLR == "YES")
			{
			printf "* %s",FILENAME"\n";
			}else{
			printf "* \033[2;32m %s",FILENAME"\033[2;0m \n";
			};
		print "@ Total translations: "length(UniqLang);
		if(ShowAvailableLanguages)if(ShowAvailableLanguages == "all")if(length(UniqLang) != 0 )
			{
			for(AllLang in UniqLang){sub("]","",AllLang);
				printf "%s",AllLang","};print "."
			};
		for (ItemNumber in Item)print Item[ItemNumber];			
		}' "{}" \; | grep -v ^"\#"
		;;
	description ) 
		find "${fdPath}" -type f \( -name "*.desktop" -o -name "*.directory" \) -exec awk  -F= -v CLR="$DISABLE_COLORS" '{
			if($2)if($1 == "Name")VName=substr($0,index($0,$2));
			if($2)if($1 == "Icon")VIcon=substr($0,index($0,$2));
			if($2)if($1 == "Comment")VComment=substr($0,index($0,$2))
		}END{
			FName=FILENAME;
			gsub(/[^*]*\//,"",FName);
			if(VName && VIcon && VComment)
				if(CLR == "YES")
				{
				printf "%s", VName " | "VIcon" | "VComment" | "FILENAME"\n"
				}else{
				printf "%s", VName " |\033[1;33m "VIcon"\033[0m | "VComment" | \033[1;30m"FILENAME"\033[0m\n"
				}
		}' "{}" \; 2> /dev/null
		;;	
	empty-ctg )

#	find  "${fdPath}" $DEP_MAX $DEP_LV -type f -name "*\.desktop" -exec awk -F= '{if($1 == "Categories")if(length($2) == 0)print FILENAME}' "{}" \;
	;;
	empty-ctg-with-exec | ece )
	find  "${fdPath}" $DEP_MAX $DEP_LV -type f -name "*\.desktop" -exec awk -F= -v CLR="$DISABLE_COLORS" '
		{
			if($1)
			{
				if($1 == "Categories")			
					GetEmptyCtg=$1;
				if($2 && index(tolower($1),"exec"))
					GetAllExec[aec++]=$2
				if($2 && $1 == "Name")
					GetName=$2
			} 
		}END{
		if(length(GetAllExec) != 0 && length(GetEmptyCtg) != 0 )
			{
				if(CLR == "YES")
				{
					printf "* %s", FILENAME "\t!!!"GetEmptyCtg"=\n";
				}else{
					printf "* %s", FILENAME "\t!!!\033[31m"GetEmptyCtg"=\033[0m\n";
				}
				for(ShowExec in GetAllExec )
					if(CLR == "YES")
					{
						printf GetName"%s", " | " GetAllExec[ShowExec]"\n";		
					}else{
						printf "\033[1;91m"GetName"\033[0m%s", " | " GetAllExec[ShowExec]"\n";	
					}
					
			 }
		}' "{}" \;
	;;
	exec-with-empty-variables )
	find  /usr/ -type f -name "*\.desktop" -exec awk -F= '{if($1){if(index($0,"=") != 0 && index($1,"#") == 0 )if(length($2) == 0)GetEmptyVar[ec++]=$1;if($2 && index(tolower($1),"exec"))GetAllExec[aec++]=$2} }END{if(length(GetAllExec) != 0){ print "* "FILENAME;for(ShowExec in GetAllExec )print GetAllExec[ShowExec];for(ShowEV in GetEmptyVar )print GetEmptyVar[ShowEV]"=" }}' "{}" \;

	;;
	more )
		find "${fdPath}" $DEP_MAX $DEP_LV   -type f -name "*\.desktop" -exec awk  -v CLR="$DISABLE_COLORS" -v FindIt="$2"  -F= '/^create/;{ 
		ToLowerOne=tolower($1);
		ToLowerFindIt=tolower(FindIt);
		ToLowerTwo=tolower($2);
		if(index($1,"]") == 0 && index($1,"#") != 1  && index($1,";") != 1 )
		if( index(ToLowerOne,"exec") != 0 || index(ToLowerOne,"name") != 0  || index(ToLowerOne,"comment") != 0  || index(ToLowerOne,"categories") != 0  || index(ToLowerOne,"command") != 0 || index(ToLowerOne,"module") != 0 || index(ToLowerOne,"x-xfce-binaries") != 0 )	{Var[CountV++]=$1;InString[CountS++]=substr($0,index($0,$2));
		if(FindIt)if( index($1,"Exec") != 0 || index($1,"Exec") != 0  || index($1,"Name") != 0  || index($1,"Comment") != 0  || index($1,"Categories") != 0  || index($1,"Command") != 0 || index($1,"Module") != 0 || index($1,"X-XFCE-Binaries") != 0 )if(index(ToLowerTwo,ToLowerFindIt) != 0 )YES="1"; };
		}END{
		if(YES == "1" )
		{
			if(CLR == "YES")
			{
			printf "* "FILENAME"\n";
			}else{
			printf "* \033[2;32m"FILENAME"\033[2;0m \n";
			};
	        for(I in InString)if(length(Var[I]) != 0)print Var[I]"="InString[I]
		};
		if(length(FindIt) == 0)
			{
				if(CLR == "YES")
				{
				printf "*  "FILENAME" \n";
				}else{
				printf "* \033[2;32m "FILENAME"\033[2;0m \n";
				};
	
			for(I in InString)if(length(Var[I]) != 0)print Var[I]"="InString[I]
			}
		}'  "{}"  \;|grep -v -e ^"#" -e ^$
		;;
	smc )
		find "${fdPath}" $DEP_MAX $DEP_LV   -type f \( -name "*.desktop" -o -name "*.directory" \) -exec awk  -v CLR="$DISABLE_COLORS" -v FindIt="$2"  -F= '/^create/;{ 
		ToLowerOne=tolower($1);
		ToLowerFindIt=tolower(FindIt);
		ToLowerTwo=tolower($2);
		if(index($1,"]") == 0 && index($1,"#") != 1  && index($1,";") != 1 )
		if( index(ToLowerOne,"exec") != 0 || index(ToLowerOne,"name") != 0  || index(ToLowerOne,"comment") != 0  || index(ToLowerOne,"categories") != 0  || index(ToLowerOne,"command") != 0 || index(ToLowerOne,"module") != 0 || index(ToLowerOne,"x-xfce-binaries") != 0 )	{Var[CountV++]=$1;InString[CountS++]=substr($0,index($0,$2));
		if(FindIt)if( index($1,"Categories") != 0 )if(index(ToLowerTwo,ToLowerFindIt) != 0 )YES="1"; };
		}END{
		if(YES == "1" )
		{
			if(CLR == "YES")
			{
			printf "* "FILENAME"\n";
			}else{
			printf "* \033[2;32m"FILENAME"\033[2;0m \n";
			};
	        for(I in InString)if(length(Var[I]) != 0)print Var[I]"="InString[I]
		};
		if(length(FindIt) == 0)
			{
				if(CLR == "YES")
				{
				printf "*  "FILENAME" \n";
				}else{
				printf "* \033[2;32m "FILENAME"\033[2;0m \n";
				};
	
			for(I in InString)if(length(Var[I]) != 0)print Var[I]"="InString[I]
			}
		}'  "{}"  \;|grep -v -e ^"#" -e ^$
		;;
	sce )
		find "${fdPath}" $DEP_MAX $DEP_LV   -type f \( -name "*.desktop" -o -name "*.directory" \) -exec awk  -v CLR="$DISABLE_COLORS" -v SFName=$3 -v FindIt="$2" -v CLR=$DISABLE_COLORS -F= '/^create/;{ 
		ToLowerOne=tolower($1);
		ToLowerFindIt=tolower(FindIt);
		ToLowerTwo=tolower($2);
		if(index($1,"]") == 0 && index($1,"#") != 1  && index($1,";") != 1 )
			{
			if( index(ToLowerOne,"exec") != 0 ||  index(ToLowerOne,"module") != 0 || index(ToLowerOne,"x-xfce-binaries") != 0 || index(ToLowerOne,"categories") != 0 )
			{
				if(index(ToLowerOne,"categories") != 0)
				{
				GetCtg=substr($0,index($0,$2));
				}
				else
				{
				Var[CountV++]=$1;
				InString[CountS++]=substr($0,index($0,$2));
				}
			if(FindIt)if( index($1,"Categories") != 0 )
				if(index(ToLowerTwo,ToLowerFindIt) != 0 )YES="1"; 

			}
			
		};
			
		}END{
		if(SFName == "sf" || SFName == "filename"){FName=" # "FILENAME}else{FName=""};
			if(YES == "1" )
			{
		        for(I in InString)if(length(Var[I]) != 0)
				{
					if(CLR == "YES")
					{
					printf "%s", InString[I]" # "GetCtg FName"\n";
					}else
					{
					printf "%s", InString[I]" # \033[34m"GetCtg"\033[0m"FName"\n";
					}
				};
			}
		if(length(FindIt) == 0)
			{			
			for(I in InString)if(length(Var[I]) != 0)
				if(index(ToLowerOne,"categories") != 0)
				{
					if(CLR == "YES")
					{
					printf "%s", InString[I]" # "GetCtg FName"\n";
					}else
					{
					printf "%s", InString[I]" # \033[34m"GetCtg"\033[0m"FName"\n";
					}
				}
			}
		}'  "{}"  \;|grep -v -e ^"#" -e ^$
		;;
	#	more )
#		find "${fdPath}" $DEP_MAX $DEP_LV  -type f -name "*\.desktop" -exec awk  -v CLR="$DISABLE_COLORS" -v FindIt="$2"  -F= '/^create/;{ 
#	 		  if(index($1,"]") == 0    && index($1,"MimeType") == 0 && index($1,"Keywords") == 0){Var[CountV++]=$1;InString[CountS++]=substr($0,index($0,$2));
#		if(FindIt)if(index($2,FindIt) != 0 && index($1,"MimeType") == 0 && index($1,"Keywords") == 0)YES="1"; };}END{
#		if(YES == "1" ){print " "FILENAME;        for(I in InString)if(length(Var[I]) != 0)print Var[I]"="InString[I]};
#		if(length(FindIt) == 0){print " "FILENAME;for(I in InString)if(length(Var[I]) != 0)print Var[I]"="InString[I]}}'  "{}"  \;|grep -v -e ^"#" -e ^$
#		;;

	less )
		find  "${fdPath}" $DEP_MAX $DEP_LV  -type f \( -name "*.desktop" -o -name "*.directory" \) -exec awk  -v CLR="$DISABLE_COLORS" -v FindIt="$2" -v Trans="$3" -F= '/^create/;{ 
		ToLowerTwo=tolower($2);
		ToLowerFindIt=tolower(FindIt);
			if(Trans)
			{
			split(Trans,ArrayTransLang,",");
			for(ReLangArray in ArrayTransLang )NewArrTrans[ArrayTransLang[ReLangArray]]=1;
			}				
		if(index($1,"]") == 0)
			{
			Var[CountV++]=$1;
			InString[CountS++]=substr($0,index($0,$2));
			if(FindIt)if(index(ToLowerTwo,ToLowerFindIt) != 0)YES="1"; 
			};
		if(index($1,"[") != 0 && index($1,"[") != 1 ){
			split($1,Lang,"[");			
			TmpLang=Lang[2];		
			UniqLang[TmpLang]++;
			sub("]","",TmpLang);
			if(Trans)
			  {
			  if( NewArrTrans[TmpLang] == 1 )
			   {   
			  Var[CountV++]=$1;
			  InString[CountS++]=substr($0,index($0,$2))
		  	   }			  				
			  }						 
			};
			if(index($1,"[") == 1){
			Var[CountV++]=$1;
			InString[CountS++]=$0}			
			}END{
		if(YES == "1" )
			{
				if(CLR == "YES")
				{
				printf "*  " FILENAME "@ Total translations: "length(UniqLang)": ";
				}else{
				printf "* \033[2;32m" FILENAME "\033[0m\n@ Total translations: "length(UniqLang)": ";
				}
			if(length(UniqLang) != 0)for(AllLang in UniqLang){sub("]","",AllLang);printf "%s",AllLang",";}				
			print " ";
			for (I in InString)if(index(Var[I],"[") != 1 && length(Var[I]) != 0 && index(Var[I],"#") != 1 )
				{	
						if(index(InString[I]"=",Var[I]"=") != 1 )
							{
							print Var[I]"="InString[I]
							}
						else
							{	
							print Var[I]"="
							}			
				}
				else
				{
					if(index(Var[I],"[") == 1) 
						
						if(CLR == "YES")
						{
						printf Var[I]"\n"
						}else{
						printf "\033[2;33m"Var[I]"\033[2;0m\n"
						}
				}
			}
		if(length(FindIt) == 0)
			{
				if(CLR == "YES")
				{
				printf "* " FILENAME " \n@ Total translations: "length(UniqLang)": ";
				}else{
				printf "* \033[2;32m" FILENAME "\033[0m \n@ Total translations: "length(UniqLang)": ";
				}
			if(length(UniqLang) != 0)for(AllLang in UniqLang)
				{
					sub("]","",AllLang);printf "%s",AllLang",";
				}
				print " ";
				for (I in InString)
					if(index(Var[I],"[") != 1 && length(Var[I]) != 0 && index(Var[I],"#") != 1  )
						{
							if(index(InString[I]"=",Var[I]"=") != 1 )
								{
								print Var[I]"="InString[I]
								}
							else
								{	
								print Var[I]"="
								}
						}
						else
						{ 
							if(index(Var[I],"[") == 1)
								if(CLR == "YES")
								{
						       		printf Var[I]"\n"
								}else{
						       		printf "\033[2;33m"Var[I]"\033[2;0m \n"
								}
						}
			}
			     }'  "{}"  \;
		;;
	iov )
		find  "${fdPath}" $DEP_MAX $DEP_LV  -type f \( -name "*.desktop" -o -name "*.directory" \) -exec awk  -v CLR="$DISABLE_COLORS" -v FindIt="$2" -v Fname="$3" -F= '//{ 
			if(FindIt){
			SizeArray=split(FindIt,ArrayFindIt,",");
			if (index($0,"[") == 1 ) 
				YesFoundIt[CountFinds++]=$0;
			for(CountFindItArray in ArrayFindIt )
				NewArrFindIt[ArrayFindIt[CountFindItArray]]=1;
			if(NewArrFindIt[$1] == 1 )
				{
				YesFoundIt[CountFinds++]=$0;
				UniqFound[$1]=1;
				}	
			}
			}END{
			if( length(UniqFound) == SizeArray )
			{
				if(Fname == "filename" || Fname == "fn" || Fname == "sf" || Fname == "--sf" )
					if(CLR == "YES")
					{
					printf "* "FILENAME" \n";
					}else{
					printf "* \033[2;32m"FILENAME"\033[0m \n";
					}
				for (GotFound in YesFoundIt )
				{
					if(index(YesFoundIt[GotFound],"[") == 1 )
					{
						if(CLR == "YES")
						{
						printf YesFoundIt[GotFound]"\n"
						}else{
						printf "\033[2;33m"YesFoundIt[GotFound]"\033[0m \n"
						}
					}
					else
					{
						print YesFoundIt[GotFound];
					}
				};
			}
		}' "{}" \;

		;;
		* ) 
		BaseVarUpdate "$@"
		ReCreateDskPath "$@"
		ListDefault "$@"
		;;
	esac

    fi;
fi
done

case  "$Opts" in
### "sys-unique" showing unique variable names found in /usr /etc /opt path. || find, cut, grep
	sys-uniq )
	find "/usr" "/etc" "/opt"  -type f \( -name "*.desktop" -o -name "*.directory" \) -exec grep ^ "{}"  \; | cut -d= -f1 | grep -v -e "\[" -e ^\#  | sort -u
		;;
### "var-sys" searching for variable name in system path /usr /etc /opt
	var-sys )
		grep -e ^"$Var" "${AddCmd[@]:2}" -H -E -R --include "*\.desktop" --include "\.directory"  /usr /etc /opt
		;;
esac
}
########################################

RawView(){
for fdPath in "${DskPath[@]}";do
if [[ -d "${DskPath[Count]}" || -f "${DskPath[Count]}"  ]];
 then
	if [[ "$OffPrint" == "no" ]];then
		if [[ "$DISABLE_COLORS" == "YES" ]];then 
		printf "# %s ${fdPath} \e \n";
		else
		printf "#\e[1;36m %s ${fdPath} \e[0m \n";
		fi
	fi
   if [ ! -z "$One" ] && [[ -d "${fdPath}" || -f "${fdPath}" ]] ;
    then 
#[[ "$Opts" == "suo" || "$Opts" == "suoe" ]] &&  grep ^ -R -h --include "*\.desktop" "${fdPath}" ;

[[ "$Opts" == "suo" || "$Opts" == "suoe" ]] &&  find "${fdPath}" $DEP_MAX $DEP_LV -type f -name "*\.desktop" -exec cat "{}" \;

    fi;
fi
done | case $Opts in
	suo )
		grep = |cut -d= -f1 |grep -v -e "\[" -e ^\#|sort -u
		;;
	suoe )
		grep '=' | awk -F= '//{if(index($1,"]") == 0 && index($1,"#") == 0)if(length($2) != 0)GetVars[$1]=substr($0,index($0,$2));}END{for(II in GetVars)print II "="GetVars[II] }' | sort
		;;
esac
}

ShowOrStartXsession(){
for FileName in /usr/share/xsessions/*;do
	X_Sessions+=("$(grep ^'Exec=' $FileName| cut -d= -f2-)");
	X_Names+=("$(grep ^'Name=' $FileName| cut -d= -f2-)"' ');
	X_Comment+=("$(grep ^'Comment=' $FileName| cut -d= -f2-)"' ');
	X_DesktopNames+=("$(grep ^'DesktopNames=' $FileName| cut -d= -f2-)"' ');
done
CC=0;

case $ToShowPart in
	n | name )
 for ReadSessions in "${X_Names[@]}";do
	echo $CC $ReadSessions
	 ((CC++))
 done
	;;
	c | comment )
 for ReadSessions in "${X_Comment[@]}";do
	echo $CC $ReadSessions
	 ((CC++))
 done
	;;
	dn | desktopname )
 for ReadSessions in "${X_DesktopNames[@]}";do
	echo $CC $ReadSessions
	 ((CC++))
 done
	;;
	a | all )
	echo 'Number Name # Comment # Exec';
 for ReadSessions in "${X_Sessions[@]}";do
	echo $CC ${X_Names[CC]} '#' ${X_Comment[CC]} '#' $ReadSessions;
	 ((CC++))
 done
	;;
	*)
 for ReadSessions in "${X_Sessions[@]}";do
	echo $CC $ReadSessions
	 ((CC++))
 done
	;;
esac

if [[ "$StartIt" == "1"  ]];then
echo 'Enter a session number:';
       	read Session_Number;
	 if [[  "$Session_Number" =~ [0-9]+$ &&  "$Session_Number" -le "${#X_Sessions[@]}" ]];then

		 if [[  "${X_Sessions[Session_Number]/\//}" == "${X_Sessions[Session_Number]}" ]];then
			 startx /usr/bin/${X_Sessions[Session_Number]}
		 else
			 startx ${X_Sessions[Session_Number]}
		 fi
	 fi
fi
}

###################
# Disabled options
###################
#By using option "all" as 3rd option will show all available translations in a *.desktop file, 
# without it will show only amount of translations or additional variables with a chosen translation.
# --uniq-per-file-default (lang) ("all") | --upfd : list variables found in default path
# --uniq-per-file-sys (lang) ("all")  | --upfs : list variables found in /usr /etc /opt'
# --uniq-per-file-default | --upfd : show uniq entries per file in default path
# --uniq-per-file-sys | --upfs : show uniq entries per file found in /usr /etc /opt'		
############################
# dump	-	dump content of *.desktop files
#	dump ) 
#		echo '
#	Dump RAW content of *.desktop files to stdout
# --dump-all | --da : search in  / (may need root rights)
# --dump-default-path | --ddp : from default path
# --dump-sys-path | --dsp : dump content from /usr /etc /opt'
#		;;
# Update a file that contains list of path
#	--upf filename
#  --update-path-file | --upf [file name]	: replacing all numbers and spaces with * in a file then sorting and leaving only uniq path'

help_def(){
	echo 'Showing all basic searchable content in a single line per file.
	Without any options it will list from all default path.
	All extended supported options begins with --
	Deafult output to search in: Name/Comment,Exec,Category, path to the file
 --all-sys-path | --asc (options)
 	using system path /usr /etc /opt

       VERTICAL OUTPUT
 ___________________________
	Search text in all available variables
 --more | --m (text)
 	using default path
 --more-sys | --ms (text)
 	using system path 

	List detailed description of content
 --list | --l (text) (translation)
 	using default path
 --list-sys | --ls (text) (translation)
 	using system path /usr /etc /opt
 ___________________________
 
 --description | --d 
 	list content of variables by pattern: Name # Icon # Comment # FILENAME'
	}
help_debug(){
	echo '--show-me | --sm (options)		
		without options will show content of script.
		will search for text string and will show line numbers where it was found
		other options:
		 beta - showing options that are not currently in help description'
	}
help_var(){
echo 'Search a value of the variables. 
	
      SUPPORTING grep SYNTAX
 ________________________________
 --var [variable] 
 	using default path
 --var-sys | --vs [variable]
	using system path /usr /etc /opt

	Show file names that does not contain a string 
 --no-var-sys|--nvs [xx]
 	using system path /usr /etc /opt
 --no-var | --nv [text]
 	using default path
 ________________________________

	Show all unique base variable names 
 --show-uniq-def | --sud
 	using default path
 --show-uniq-def-example | --sude
 	using default path

 --show-sys-uniq | --ssu
 	using system path /usr /etc /opt

	Show RAW output of the unique variables
 --show-uniq-only | --suo
 	using default path 
 --show-uniq-only-example | --suoe
 	using default path

 Not supporting grep syntax, using awk
	show content of choosen variables only if all them are present in the file. To show path to file use "sf" as last option.
 --including-only-var	   | --iov [var1,var2] sf
	using default path
 --including-only-var-sys  | --iovs [var1,var2] sf
	using system path /usr /etc /opt'
	}
help_sec(){
echo 'Search section names in .desktop files

	Search for unique section names
 --sys-section-name	| --ssn
 	using system path /usr /etc /opt
 --default-section-name | --dsn
 	using default path'

	}
help_ctg(){
echo ' --list-categories | --lc
	Show all categories found in "/usr/share/applications/" and "$HOME/.local/share/applications/" 

 --more-category | --mc [text]
 	output is similar to option --more but searching text only in categories
 --categories-exec | --c [text] (sf)
	searching only in categories.
       	showing result by one line per exec found in a single file. 
	use "sf" as the last option to show filename
 --empty-categories-exec | --ece
 	list content of "Exec" variables that doesn'"'"'t belong to a group' 	

}
help_config(){
echo 'Configuration
 --create-global-list | --cgl
 	scan system and save dirs into /opt/share/ldf/sorted.test
 --create-local-list  | --cll
 	scan system and save dirs into $HOME/.ldf/sorted.test

 --show-local-defaults	| --sld
 	show content of $HOME/.ldf/sorted.test
 --show-global-defaults	| --sgd
 	show content of /opt/share/ldf/sorted.test

 --show-default-directories | --sdd
 	show internal dirs defined in array DefDskPath 

 --remove-local-config
 	removing $HOME/.ldf/sorted.test
 --remove-global-config
 	removing /opt/share/ldf/sorted.test

     Find path to directories with .desktop files, default is "/"

 --find-path | --fp [path1] [path2]
 	all path with *.desktop files	
 --formated-path-output | --fpo  [path1] [path2]
 	replacing numbers and spaces with *

 --find-path-exec | --fpe [path1] [path2]
	shows only directories that contains variable Exec
 --formated-path-output-exec | --fpoe [path1] [path2]
	shows only directories that contains variable Exec

 --format-path-file | --fpf [filename]
 	replace all spaces and numbers with * 	'
	}
help_info(){
echo 'https://specifications.freedesktop.org/desktop-entry-spec/latest/
	Short overview:
"f" - File name with full path
"u" - URL to website
"d" - Directory
"n" - Name of the file without path
	Single source:
%f %u %d %n
	Multiple sources:
%F %U %D %N
	Other:
%k URI/location of desktop file 
%v name of the device'	
	}
help_usage(){
echo 'Usage examples
 List content with default options:
	 lsdesktopf
 Search only for specific text in default output:
	 lsdesktopf gtk
	 lsdesktopf game
	 lsdesktopf --more 
	 lsdesktopf --more kde
	 lsdesktopf --list
	 lsdesktopf --list gnome 
	 lsdesktopf --list gtk zh_CN,zh_TW

 Use --var option (supporting grep syntax):
	--var-sys has same syntax as --var
	--var Name=
	--var "Name\[zn_CN\]" -e "^Exec="
 Reverse search (supporting grep syntax)
	--no-var Exec=
	--no-var-sys "Name\[en_GB\]"
 
 Use --including-only-var option to show content of choosen and optionaly show filename
 	NOTE: filename is an option and not path to existing file.
 	--iov Exec,MimeType filename
	--iov Exec,MimeType | grep -v ^#

 Use --gm option that shows various information about MIME-types in *.desktop files
	--gm 1
	--gm 
	--gm 0
	--gm -gx video
	--gm -gx text
	--gm -fm application/oxps,application/vnd.ms-xpsdocument,application/x-brasero

 Scan for all *.desktop files in /usr /etc /opt
 has same syntax as without supported options
	--asc 
	--asc gtk
	Use --find-path or --fp 
	--fp 
	--fp /usr /etc
	export DESKTOP_FILES="$(lsdesktopf --fp / ";")"'
	}
help_tips(){
	echo 'The script is based around commands: "grep", "awk", "find" 
	and a loop: for Line in "${Array[@]}";do ..;done
	command "rev" is used to reverse text that is useful to show or exclude last column
 to show only specfic column can be used commands such as awk,cut. 
	The "awk" command can use more than one symbol as delimer but "cut" supports only one
	awk -F"AB" "{print $1}"
	awk "{print substr($0,0,index($0,"AB")-2) }"
	cut -dA -f1
	to show everything after specified column
	cut -dA -f2-
	awk "{print substr($0,index($0,"AB")+2) }"
 to show amount columns in a string
 	awk -F"AB" "{print NF}"
 	awk "{print split($0,A,"AB") }"
 command "basename" is used to show only the filename but cutting away path to it.
	find / -type f -exec basename "{}" \;
	find / -type f | xargs basename
 command "dirname" is used to show only path to file.
	find / -type f -exec dirname "{}" \;
	find / -type f | xargs dirname
 hide error messages from stderr, such as e.g. "permission denied"
 	find / -type f 2> /dev/null | grep desktop'
}
help_mimetypes(){
echo 'Show list of mimetypes with associated *.desktop files. 
 --gen-mimeapps | --gm [options]
	Output is similar that is used in "mimeapps.list" file under section [Added Associations]
	Options:
		0 
	       		show only MIME-types
		1 
	       		show type of mime. First part of MIME-type 
		2 
	       		show extension. Second part of MIME-type
		3 
	       		show only filenames that can open same MIME-type
		-gx [type of MIME] 
	       		shows all extensions in your systems *.desktop files that belongs to type of MIME
		-gdx [options]
			shows MIME-types with their descriptions found in *.xml files
			by default searching only in /usr/share/mime/packages/ $HOME/.local/share/mime/packages/
			g
				search in /etc /usr $HOME/.local $HOME/.config
			l
				search in  $HOME/.local $HOME/.config
		-fm [options]
			find .desktop files only for comma separated MIME types
 
 --gdx [options]
	same as --gm -gdx [options]
	search in *.xml configuration files
	additional options
		0 
	       		show only MIME-types
		1 
	       		show type of mime. First part of MIME-type 
		2 
	       		show extension. Second part of MIME-type
		3 
	       		show only filename extenstions
	 -gfx [options]	
				list available file name extensions with their description found in ".xml" configuration or database files.
			additional comma separated options:
				sf 
				 show path to .xml file where was found file name extension.
				sm
				 show MIME type
				sa
				 show acronym
				sea
				 show extended acronym
				ssc
				 show sub class
				sal
				 show alias
				sgi
				 show general icon description

 --list-mimeapps | --lm 
 	List available "*mimeapps.list" with colored path and their content
' 
}

help_Sessions(){
	echo ' --sxs	
 list numbered content of Exec in .desktop files located at /usr/share/xsessions/
 additional options:
	n
	name
  	 show content of "Name="
	c
	comment
	 show content of "Comment="
	dn
	desktopname
	 show content of "DesktopName="
	a
	all
	 show content by pattern "Number Name # Comment # Exec"
 --rxs
 as above but also asking to choose number of a session to start.'
}

help_env(){
echo 'Environment variables
NO_COLORS 	- if value is YES then no colors will be used
DESKTOP_FILES 	- must contain path to folders with 
		  desktop files separated with ";"
		  overriding default preset path'

}

help_sinfile(){
echo '--in-file | --if [text] [language]
		output is similar to option "--list" 
		by default showing base content of a .desktop with a list of available translations
		searching for the "text" in both - variable name and content
		 showing only lines where the text was found but ignoring translated
		if language is choosen then it will show all available translation'	
}

case "$1" in
--help )
	if [[ -z "$2" ]];then
	echo 'use additional options with --help'
	echo ' all	-	show all help sections
 def	-	options that are using default output
 var	-	list available variables or search a value
 sec	-	list available sections 
 usage	-	show usage of commands	
 config	-	configuration  
 debug	-	view or search in content of this script
 info	-	show short info about *.desktop specified Exec
 tips	-	show some tips about commands used in this script
 mime	-	list available mimetypes
 ses	-	list or run sessions
 env	-	enviroment variables
 sinf	-	show options for viewing single file
 ctg	-	list availabe or search only in categories'
	else
		case "$2" in
	sinf )
		help_sinfile
		;;	
	mime )
		help_mimetypes
		;;
	def )
		help_def
		;;
	debug ) 
		help_debug
		;;
	var )
		help_var
		;;
	sec ) 
		help_sec
		;;
	config ) 
		help_config
		 ;;
	info ) 
		help_info	
		;;
	ctg )
		help_ctg
		;;
	usage ) 
		help_usage
		;;
	tips )
		help_tips
		;;
	ses )
		help_Sessions
		;;
	env )
		help_env
		;;
	all )
	help_def
	help_var
	help_sec
	help_sinfile
	help_mimetypes
	help_Sessions
	help_env
	help_usage
	help_config
	help_debug
	help_info
	help_tips
		;;
		esac
	fi
		;;
--var )
	BaseVarUpdate "$@"
	ReCreateDskPath "$@"

	if [[  ! -z "$2"    ]];then  
		Var="$2"
 	if [[ "$#" -gt 2  ]];then 
	AddCmd=($@);
#	Additional="${AddCmd[@]:2}"  ;
 	fi;
		Opts="var"
	echo "${AddCmd[@]:2}"	
		SearchContentOfVariable "$@"
	else
		echo "Error, parameter to --var is missing
	example: --var MimeType"
 	fi	 	
 	;;
#--uniq-per-file-default | --upfd )
#	Opts="upfd"	
# 	ReCreateDskPath "$@"
#	SearchContentOfVariable "$@"
#	;;
#--uniq-per-file-sys | --upfs )

#	find /usr /etc /opt -type f -name "*\.desktop" -exec awk  -v CLR="$DISABLE_COLORS" -v GetLang="ru" -F"=" '{if (index($1,"[") == 1)  printf "  "FILENAME"\n" $1"\n";if(index($1,"["GetLang"]")){print $0}else{if(index($1,"]") == 0) print $0}}' "{}" \; | grep -v ^"\#"
#		find /usr /etc /opt -type f -name "*\.desktop" -exec awk  -v CLR="$DISABLE_COLORS" -v GetLang="$FLang" -v ShowAvailableLanguages="$3"  -F= '//{
#		if(index($1,"[") != 0 && index($1,"[") != 1 ){split($1,Lang,"[")UniqLang[Lang[2]]++};
#		if(index($1,"["GetLang"]") != 0 ){Item[cnt++]=$0}else { if(index($1,"]") == 0)Item[cnt++]=$0}
#		}END{
#		printf "  %s",FILENAME"\n";
#		print " ** Total translations: "length(UniqLang);
#		if(ShowAvailableLanguages)if(ShowAvailableLanguages == "all")if(length(UniqLang) != 0 ){
#			for(AllLang in UniqLang){sub("]","",AllLang);printf "%s",AllLang","};print "."	
#			};
#		for (ItemNumber in Item)print Item[ItemNumber];			
#		}' "{}" \; | grep -v ^"\#"
#		;;
--more | --m )
	BaseVarUpdate "$@"
	Opts="more"
	ReCreateDskPath "$@"
        SearchContentOfVariable "$@"
	;;
--show-more-category | --smc | --mc | --more-category )
	BaseVarUpdate "$@"
	Opts="smc"
	ReCreateDskPath "$@"
        SearchContentOfVariable "$@"
	;;
--show-category-exec | --sce | --c)
	OffPrint="yes";
	BaseVarUpdate "$@"
	Opts="sce"
	ReCreateDskPath "$@"
        SearchContentOfVariable "$@"
	;;
--more-sys | --ms )
	find /usr /etc /opt -type f -name "*\.desktop" -exec awk  -v CLR="$DISABLE_COLORS" -v FindIt="$2"  -F= '/^create/;{ 
		if(index($1,"]") == 0)
			{
			Var[CountV++]=$1;
			InString[CountS++]=substr($0,index($0,$2));
			if(FindIt)if(index($2,FindIt) != 0)YES="1"; };
			}END{
		if(YES == "1" )
			{
				if(CLR == "YES"){
				printf "* "FILENAME" \n";
				}else{
				printf "* \033[2;32m"FILENAME" \033[2;0m\n";				
				}
			for (I in InString)print Var[I]"="InString[I]}
			};
		if(length(FindIt) == 0)
			{
				if(CLR == "YES")
				{
				printf "* "FILENAME"\n";
				}else{
				printf "* \033[2;32m"FILENAME"\033[2;0m\n";
				}
			for(I in InString)print Var[I]"="InString[I]
			}
			     }'  "{}"  \;|grep -v ^"#"
	;;
--including-only-var  | --iov )
	BaseVarUpdate "$@"

	if [[ -z "$2" ]];then
		echo 'Use options!
		Example: --iov Exec,Type filename'
		exit 1
	fi
	Opts="iov"
	ReCreateDskPath "$@"
        SearchContentOfVariable "$@"
	;;
--including-only-var-sys  | --iovs)
	if [[ -z "$2" ]];then
		echo 'Use options!
		Example: --iovs Exec,Type filename'
		exit 1
	fi
	find  /usr /etc /opt -type f -name "*\.desktop" -exec awk  -v CLR="$DISABLE_COLORS" -v FindIt="$2" -v Fname="$3" -F= '//{ 
		if(FindIt){
		SizeArray=split(FindIt,ArrayFindIt,",");
		if (index($0,"[") == 1 ) YesFoundIt[CountFinds++]=$0;
		for(CountFindItArray in ArrayFindIt )NewArrFindIt[ArrayFindIt[CountFindItArray]]=1;
			if(NewArrFindIt[$1] == 1 )
				{
				YesFoundIt[CountFinds++]=$0;
				UniqFound[$1]=1;
				}	
		}}END{
		if( length(UniqFound) == SizeArray )
		{	if(Fname == "filename")
				if(CLR == "YES")
				{
				printf "*  %s"FILENAME"\n";
				}else{
				printf "* \033[2;32m %s"FILENAME"\033[2;32m\n";
				}
			for (GotFound in YesFoundIt )
			{
					print YesFoundIt[GotFound];
			};
		}
	}' "{}" \;
	;;	
--list | --less | --l )
	BaseVarUpdate "$@"

	Opts="less"
	ReCreateDskPath "$@"
        SearchContentOfVariable "$@"
	;;
--list-sys | --less-sys | --ls )
	BaseVarUpdate "$@";
	less_sys "$@"
	;;
--no-var | --nv )
	BaseVarUpdate "$@"

	ReCreateDskPath "$@"

	if [[  ! -z "$2"    ]];then  
		Var="$2"
		Opts="no-var"
		SearchContentOfVariable "$@"
	else
		echo "Error, parameter to --no-var is missing
	example: --no-var MimeType"
 	fi	 	
 	;;
--var-sys | --vs)
	BaseVarUpdate "$@"

#	ReCreateDskPath
	if [[  ! -z "$2"    ]];then  
	Var="$2"
# 	if [[ "$#" -gt 2  ]];then 
#	Additional="${AddCmd[@]:2}"  ;
# 	 fi;
	Opts="var-sys"
	SearchContentOfVariable "$@"
	else
		echo "Error, parameter to --var-sys is missing
	example: --var-sys MimeType"
 	fi	
	;;
--no-var-sys | --nvs )

	if [[ ! -z "$2" ]];then
		find /usr /etc /opt -type f -name "*\.desktop" -exec grep -i -H -L "$2" \;
	else
		echo 'No options are given.'
	fi
	;;
#--dump-all | --da ) 
#	grep -i ^ -H -R --include \*.desktop "/"
#	;;
#--dump-sys-path | --dsp )
#	grep -i ^ -H -R --include \*.desktop "/usr /etc /opt"
#	;;
#--dump-default-path | --ddp )
#	Opts="ddp"
#  	ReCreateDskPath "$@"
#     	SearchContentOfVariable
#	;;
--show-uniq-def | --sud )
	BaseVarUpdate "$@"
	OffPrint="no"
	Opts="sud"
 	ReCreateDskPath "$@"
      	SearchContentOfVariable "$@"
	;;
--show-uniq-def-example | --sude )
	BaseVarUpdate "$@"
	OffPrint="no"
	Opts="sude"
 	ReCreateDskPath "$@"
      	SearchContentOfVariable "$@"
	;;
--show-uniq-only | --suo )
	BaseVarUpdate "$@"
	OffPrint="yes"
	Opts=suo
	ReCreateDskPath "$@"
	RawView
	;;
--show-uniq-only-example | --suoe )
	BaseVarUpdate "$@"
	OffPrint="yes"
	Opts=suoe
	ReCreateDskPath "$@"
	RawView
	;;
--show-sys-uniq | --ssu )
		Opts="sys-uniq"
		SearchContentOfVariable "$@"
	;;
--find-path | --fp )
	BaseVarUpdate "$@"
	if [[ ! -z "$2" ]]; then  
	for (( Ipath=2; Ipath <= ${#@};Ipath++ )) ;do
	GetPathList="${@:Ipath:1}"
	if [[ -d "$GetPathList" ]]; then
		InPath="$GetPathList"
	fi
	find "$InPath" -type f \( -name "*.desktop" -o -name "*.directory" \) -exec dirname "{}" \; 2> /dev/null | sort -u 
	 if [[ "$InPath" == "/" ]];then 
	  	exit 0
 		fi
	done
	else
		find / -type f \( -name "*.desktop" -o -name "*.directory" \) -exec dirname "{}" \; 2> /dev/null | sort -u 

	fi
	;;
--find-path-exec | --fpe)
	BaseVarUpdate "$@"
	if [[ ! -z "$2" ]]; then  
	for (( Ipath=2; Ipath <= ${#@};Ipath++ )) ;do
	GetPathList="${@:Ipath:1}"
	if [[ -d "$GetPathList" ]]; then
		InPath="$GetPathList"
	fi
		find "$InPath" -type f -name "*\.desktop" -exec grep -H ^Exec "{}" \; 2> /dev/null | awk -F: '
		{
		A=$1;
		NumbArr=split(A,SArr,"/");
		for(InArr=2; InArr <= NumbArr-1;InArr++ )
		 printf  "/"SArr[InArr] ;
		printf "\n"  ;
		delete SArr ;
		}' | sort -u
	 if [[ "$InPath" == "/" ]];then 
	  	exit 0
 		fi
	done
	else
		find / -type f -name "*\.desktop"  -exec grep -H ^Exec "{}" \; 2> /dev/null | awk -F: '
		{
		A=$1;
		NumbArr=split(A,SArr,"/");
		for(InArr=3; InArr <= NumbArr-1;InArr++ )
		 printf  "/"SArr[InArr] ;
		printf "\n"  ;
		delete SArr ;
		}' | sort -u 
	fi
	;;
--formated-path-output-exec | --fpoe )
	BaseVarUpdate "$@"
	if [[ "${#@}" -ge 2 ]]; then  
	for (( Ipath=2; Ipath <= ${#@};Ipath++ )) ;do
	GetPathList="${@:Ipath:1}"
	if [[ -d "$GetPathList" ]]; then
		InPath="$GetPathList"
	fi
	find "$InPath" -type f \( -name "*.desktop" -o -name "*.directory" \)  -exec grep -H ^Exec "{}" \; 2> /dev/null | awk -F: '
		{
		A=$1;
		NumbArr=split(A,SArr,"/");
		for(InArr=2; InArr <= NumbArr-1;InArr++ )
		 printf  "/"SArr[InArr] ;
		printf "\n"  ;
		delete SArr ;
		}' |\
	       	sed -e 's/[0-9][0-9]*/*/g' -e 's/"//g' -e 's/\/$//g' -e 's/ /*/g' -e 's/[0-9]\.[0-9]*/*/g'  -e 's/\.\*/*/g' -e 's/**\*/*/g' |\
	       	sort -u 
	done
	else
		find "$InPath" -type f \( -name "*.desktop" -o -name "*.directory" \)  -exec grep -H ^Exec "{}" \; 2> /dev/null | awk -F: '
		{
		A=$1;
		NumbArr=split(A,SArr,"/");
		for(InArr=2; InArr <= NumbArr-1;InArr++ )
		 printf  "/"SArr[InArr] ;
		printf "\n"  ;
		delete SArr ;
		}' |\
		      	sed -e 's/[0-9][0-9]*/*/g' -e 's/"//g' -e 's/\/$//g' -e 's/ /*/g' -e 's/[0-9]\.[0-9]*/*/g' -e 's/\.\*/*/g' -e 's/\*\**/*/g' |\
			sort -u 
	fi

	;;

--formated-path-output | --fpo )
	BaseVarUpdate "$@"
	if [[ ! -z "$2" ]]; then  
	for (( Ipath=2; Ipath <= ${#@};Ipath++ )) ;do
	GetPathList="${@:Ipath:1}"
	if [[ -d "$GetPathList" ]]; then
		InPath="$GetPathList"
	fi
	find "$InPath" -type f \( -name "*.desktop" -o -name "*.directory" \) -exec dirname "{}" \; 2> /dev/null |\
	       	sed -e 's/[0-9][0-9]*/*/g' -e 's/"//g' -e 's/\/$//g' -e 's/ /*/g' -e 's/[0-9]\.[0-9]*/*/g'  -e 's/\.\*/*/g' -e 's/**\*/*/g' |\
	       	sort -u 
	       	#| sed "s/$/$3/g"
	 if [[ "$InPath" == "/" ]];then 
	  	exit 0
 		fi
	done
	else
		find / -type f \( -name "*.desktop" -o -name "*.directory" \) -exec dirname "{}" \; 2> /dev/null |\
		      	sed -e 's/[0-9][0-9]*/*/g' -e 's/"//g' -e 's/\/$//g' -e 's/ /*/g' -e 's/[0-9]\.[0-9]*/*/g' -e 's/\.\*/*/g' -e 's/\*\**/*/g' |\
			sort -u 
			#| sed "s/$/$3/g"
	fi
	;;
--all-sys-path | --asc)
	BaseVarUpdate "$@"
	Opts="scan-sys-path"
	ReCreateDskPath "$@"
	ListDefault "$@"
	;;
--create-local-list | --cll)
	mkdir -p "$(dirname "$LocalArray")"
	find / -type f -name "*\.desktop" -exec dirname "{}" \; | sort -u > "$LocalArray"
	;;
#--update-path-file | --upf)
#	if [[ "$UID" != 0 ]];then  
#		echo 'You must start it as user root'
#		exit 1
#	else
#		if [[ -z "$2"  ]];then
#			echo 'path to file is missing'
#		else
#			if [[ -f "$2" ]];then
#				mkdir -p "$(dirname $GlobalArray)"
#				find /usr /etc /opt -type f -name "*\.desktop" -exec dirname "{}" \; | sort -u >> "$2";
#				sed -i -e 's/[0-9][0-9]*/*/g' -e 's/"//g' -e 's/\/$//g' -e 's/ /*/g' -e 's/[0-9]\.[0-9]*/*/g' -e 's/**\*/*/g' "$2";
#				uniq -u "$2" /tmp/uniq-tmp.txt
#				cp "/tmp/uniq-tmp.txt" "$2"
#			else
#				echo "Destion is not a file"
#			fi
#		fi
#	fi
#	;;

--format-path-file | --fpf )
	BaseVarUpdate "$@"
	if [[ ! -z "$2" ]];then 
	 if [[ -f "$2" ]];then
	  if [[ $(grep -c -v ^/  "$2" ) != "0" ]];then
	   echo 'The file should contain only full path per line. ( all should begin with / )'
	  else
	   sed -i -e 's/[0-9][0-9]*/*/g' -e 's/"//g' -e 's/\/$//g' -e 's/ /*/g' -e 's/[0-9]\.[0-9]*/*/g' -e 's/\.\*/*/g' -e 's/\*\**/*/g' "$2"
	   sort -u -o "$2" "$2"
	  fi
	 else
	  echo 'Path to file is missing!'	 
	 fi 
	fi
	;;
--create-global-list | --cgl)
	BaseVarUpdate "$@"
	if [[ "$UID" != 0 ]];then  
		echo 'You must start it as user root'
		exit 1
	else
		mkdir -p "$(dirname $GlobalArray)"
		find / -type f -name "*\.desktop" -exec dirname "{}" \; | sort -u > "$GlobalArray"
	fi
	;;

--show-local-defaults | --sld)
	if [[ -f "$HOME/.ldf/sorted.test" ]];then
		cat "$HOME/.ldf/sorted.test"
	else
		echo 'Does not exist $HOME/.ldf/sorted.test'
	fi
	;;
--show-global-defaults | --sgd)
	if [[ -f "/opt/share/ldf/sorted.test" ]];then
		cat "/opt/share/ldf/sorted.test"
	else
		echo 'Does not exist /opt/share/ldf/sorted.test'
	fi
	;;
--show-default-directories | --sdd)
	BaseVarUpdate "$@"
	for SDD in "${DefDskPath[@]}"; do
		echo "$SDD"
	done
	;;
--remove-local-config) 
	rm -i "$HOME/.ldf/sorted.test"
	;;
--remove-global-config) 
	if [[ "$UID" -eq "0" ]];then
		rm -i "/opt/share/ldf/sorted.test"
	else
		echo 'You must be root!'
	fi
	;;
--show-me | --sm)
	if [[ -z $2 ]];then
		cat "$0"
		echo '# my path: '" $0"
	else
		case "$2" in
			beta )
		grep "^\-\-" "$0" | grep -v -e "IGNORE" -e ^"# "
			;;
			* )
		grep -n "$2" "$0" | grep -v -e "IGNORE" -e ^"# "
			;;
		esac
	fi
	;;
--sys-section-name | --ssn)
	grep -e ^"\[" -h -R --include "*\.desktop"  /usr /etc /opt | sort -u
	;;
--default-section-name | --dsn)
	BaseVarUpdate "$@"
	OffPrint="no"
	Opts='dsn'
	ReCreateDskPath "$@"

	SearchContentOfVariable
	;;	
--generate-mimeapps.list | --gen-mimeapps | --gm )
	BaseVarUpdate "$@"

if [[  -z "$XDG_CONFIG_HOME" ]];	then
PName="$HOME/.local/share/applications"
else
	if [[  "${XDG_CONFIG_HOME/#\//}" == "$XDG_CONFIG_HOME"   ]];	then
		PName="$HOME/$XDG_CONFIG_HOME/.local/share/applications"
	else
		PName="$XDG_CONFIG_HOME/.local/share/applications"
	fi
fi

IFS="
"
MimePathArray+=("$(
find "/usr/local/share/applications" "/usr/share/applications" "$PName" -type f -name "*\.desktop" -exec dirname "{}" \; | 
sort -u |
sed "s/$/\/\*.desktop/" )")

	case $2 in
      		-gdx | -get-description-xdg )
IFS="
"
		case $3 in
			g | glob )
				List_XML=($(find "/usr/" "/etc/" "$HOME/.local/" "$HOME/.config"  -type f -name "*\.xml"));
			;;
			l | local )
				List_XML=($(find  "$HOME/.config" "$HOME/.local/" -type f -name "*\.xml"));
			;;
			* )
				List_XML=($(find "/usr/share/mime/packages/" "/usr/share/mime/application/" "$HOME/.local/share/" -type f -name "*\.xml"));     
	    		 ;;
		esac
 for In_XML_List in "${List_XML[@]}";do
find "$In_XML_List" -type f -name "*\.xml" -print0 | xargs -0 awk  -v CLR="$DISABLE_COLORS" -F"\"" '{YesM=0;
	if(index($0,"mime-type")){if(index($0,"type type=")){ContentArray[Count++]=$2" == ";YesM=1}else{if(index($0," type=")){
		ContentArray[Count++]=$4" == "}}}		
		
	if(index($0,"<comment>")){
		GetString=substr($0,index($0,">")+1)
		GetTMP=" "substr(GetString,0,index(GetString,"</")-1)" \n";			
		ContentArray[Count++]=GetTMP;
		YesC=1
		};
	if(index(tolower($0),"pattern="))
	{
	ContentArray[Count++]=$2" ;\n";		
	}
		}END{
		if(CLR == "YES")
		{
		printf "\n@ "FILENAME"\n";
		}else{
		printf "\n@ \033[2;32m"FILENAME"\033[0m\n";
		}
	for(GetContent in ContentArray){
		if(index(ContentArray[GetContent],"==") != 0 )printf "\n";
		if(split(ContentArray[GetContent],TMP,"/") != 1  && index(ContentArray[GetContent],"==") == 0)
		 	 {
			 printf "\n %s",ContentArray[GetContent];
		 }else{
			 printf "%s",ContentArray[GetContent];
			  };
		};
			}' ;

			
		done
	;;
	-fm)
	if [[ ! -z "$3" ]];then	
		for inMime in "${MimePathArray[@]}" ;do
	[[ ! -d "$inMime" ]] && awk  -v CLR="$DISABLE_COLORS" -F= -v MimeToList="$3"  '//{	
  if($1 == "MimeType"){SizeArr=split($2,MimeArray,";");
	for (inArray in MimeArray)
		if(MimeArray[inArray])
			{
				inMA=MimeArray[inArray];
				FName=FILENAME;
				GetTypeMime=substr(inMA,0,index(inMA,"/")-1)
				GetExtMime=substr(inMA,index(inMA,"/")+1)
				UniqMimeTypes[GetTypeMime]=inMA;
				UniqMimeExts[inMA]=GetExtMime;
				gsub(/[^*]*\//,"",FName);
		if(UniqMimeArray[inMA])	{
				UniqMimeArray[inMA]=UniqMimeArray[inMA]";"FName;
					}
					else
					{
				UniqMimeArray[inMA]=FName;
				NameCollect[FName]=inMA
					}
			};	
	
		}
	}END{
		if(length(MimeToList) != 0)
			{
				split(MimeToList,MimeArray,",");
			for(MiAr in MimeArray)
				MimeToShow[MimeArray[MiAr]]=1;
			for ( inMime in UniqMimeArray)
				{
					if(MimeToShow[inMime] == 1)print inMime"="UniqMimeArray[inMime]";";
				}
			}
		}' ${inMime} ;
			done | sort --field-separator=\= --key=1,1
		else
			echo "List of comma separated MIME types is missing.";
		fi;	

	;;
		* )
		for inMime in "${MimePathArray[@]}" ;do
	[[ ! -d "$inMime" ]] && awk  -v CLR="$DISABLE_COLORS" -F= -v MimeParts="$2" -v MimeExt="$3"  '//{
  if($1 == "MimeType"){SizeArr=split($2,MimeArray,";");
	for (inArray in MimeArray)
		if(MimeArray[inArray])
			{
				inMA=MimeArray[inArray];
				FName=FILENAME;
				GetTypeMime=substr(inMA,0,index(inMA,"/")-1)
				GetExtMime=substr(inMA,index(inMA,"/")+1)
				UniqMimeTypes[GetTypeMime]=inMA;
				UniqMimeExts[inMA]=GetExtMime;
				gsub(/[^*]*\//,"",FName);
		if(UniqMimeArray[inMA])	{
				UniqMimeArray[inMA]=UniqMimeArray[inMA]";"FName;
					}
					else
					{
				UniqMimeArray[inMA]=FName;
				NameCollect[FName]=inMA
					}
			};
		}
		}END{
		if(length(MimeParts) == 0)
			{
			for ( inMime in UniqMimeArray)
				{
				print inMime"="UniqMimeArray[inMime]";";
				}
			}
		else
			{
			if( MimeParts == "1" || MimeParts == "type" || MimeParts == "t")
				{
					for ( inMimeType in UniqMimeTypes )
						print inMimeType;
				};
			if( MimeParts == "2" || MimeParts == "ext" || MimeParts == "e" )
				{
					for ( inMimeExt in UniqMimeExts )
						print  UniqMimeExts[inMimeExt];
				};
			if(MimeParts == "3" || MimeParts == "files" || MimeParts == "f")
				{
					for(GetNames in UniqMimeArray)
						{
						TMPfilelist=UniqMimeArray[GetNames]
						NameCollect[TMPfilelist]="1";
						};
					for ( inMimeFile in NameCollect )
						print inMimeFile;
				};
			if(MimeParts == "0" || MimeParts == "mime" || MimeParts == "m")
				{
					for(GetMIME in UniqMimeArray)
						{
							print GetMIME
						;
						};										
				};
				if(MimeParts == "-gx" || MimeParts == "-g" || MimeParts == "-getext")
				if( length(MimeExt) != 0 )
					{
					for(GetMIME in UniqMimeArray)
						{GetType=substr(GetMIME,0,index(GetMIME,"/")-1)							
							if(MimeExt == GetType )print substr(GetMIME,index(GetMIME,"/")+1)
						;
						};										
					}
				else
					{print "No option are given. Use first part of MIME-type!"};

			}
		}' ${inMime} ;
			done | sort --field-separator=\= --key=1,1
			;;
			esac
		;;
--list-mime | --lm )

	List_Dirs+=("$HOME/.config/")
	List_Dirs+=("/etc/xdg/")
	List_Dirs+=("$HOME/.local/share/applications/")
	List_Dirs+=("/usr/local/share/applications/")
	List_Dirs+=("/etc/gnome/")
	List_Dirs+=("/usr/share/applications/")

	List_Dirs+=("/usr/share/mime/packages/")
	List_Dirs+=("/usr/share/mime-info/")
	if [[ -z "$2"  ]];then
		for In_List in "${List_Dirs[@]}";do
[[ -d "${In_List}" ]]	&& find "${In_List}" -type f  \( -name "*mimeapps.list" -o -name "defaults.list"  -o -name "*.keys" -o -name "*.xml" -o -name "*.mime"  \) -print0 | \
				xargs -0 awk  -v CLR="$DISABLE_COLORS" -v GetType="$2"  '{GetListName=length(FILENAME)-4;
			if(index(FILENAME,".list") == GetListName ){
				GetContentList[CountItems++]=$0;YesFN=FILENAME
				};
			if(index(FILENAME,".keys") == GetListName){
				if(index($0,"[") == 0 && index($0,"#") == 0 && index($0,"]description") == 0 &&  index($0,"]category") == 0 && index($0,"_") == 0 )
					{
					GetContentList[CountItems++]=$0;YesFN=FILENAME;
					};
				};
			if(index(FILENAME,".xml")-1 == GetListName )
				{			
					if(index($0,"<comment>") != 0)
					{
							C=substr($0,0,index($0,"/")-2);
							GetContentList[CountItems++]=substr(C,index($0,">")+1);
							YesFN=FILENAME
					};
					if(index($0,"mime-type type=") != 0)
					{
							AA=substr($0,index($0,"\"")+1);
							GetContentList[CountItems++]=substr(AA,0,index(AA,"\"")-1)" # ";
							YesFN=FILENAME;
					}
				};
			}END{if(length(YesFN) != 0)print "* "YesFN ;for(GetList in GetContentList )print GetContentList[GetList];
		}' ;
		
		done;

	else

		for In_List in "${List_Dirs[@]}";do

		[[ -d  "${In_List}"  ]]	&&	find "${In_List}" -type f  \( -name "*mimeapps.list" -o -name "defaults.list" \) -exec awk  -v CLR="$DISABLE_COLORS"  '{ 
		       	CollectMIMEContent[count++]=$0 
			}END{
				if(CLR == "YES")
				{	
				printf "#  "FILENAME "\n";
				}else{
				printf "# \033[1;36m "FILENAME "\033[0m \n";
				}
			for (GotMIME in CollectMIMEContent)print CollectMIMEContent[GotMIME] }' "{}" \;
		done
	fi
		;;
--list-categories | --lc )
	BaseVarUpdate "$@"
#	grep ^Categories -h -R "/usr/share/applications/" "$HOME/.local/share/applications/" | awk  -v CLR="$DISABLE_COLORS" -F= '//{A[$2]=1}END{for(E in A)ZZ=ZZ E;split(ZZ,YY,";");asort(YY);for(I in YY)HH[YY[I]];for(QQ in HH)print QQ}'
#		#\ awk  -v CLR="$DISABLE_COLORS" -F= '//{A[$2]=1}END{for(E in A){gsub(";","\n",E);printf E}}' | sort -u
List_Dirs=("/usr/share/applications/")
List_Dris+=("$HOME/.local/share/applications/")
List_Dris+=("/usr/local/share/applications/")
for In_List in "${List_Dirs[@]}" ;do
[[ -d "${In_List}" ]] && find "${In_List}" -exec grep ^Categories -h -R "{}" \;
done | awk  -v CLR="$DISABLE_COLORS" -F= '//{A[$2]=1}END{for(E in A)ZZ=ZZ E;split(ZZ,YY,";");asort(YY);for(I in YY)HH[YY[I]];for(QQ in HH)print QQ}'
		#\ awk  -v CLR="$DISABLE_COLORS" -F= '//{A[$2]=1}END{for(E in A){gsub(";","\n",E);printf E}}' | sort -u
		;;
--gdx | --get-description-xdg )
	gdxstdalone "$@"
	;;
--sxs | --show-x-sessions )	
	StartIt=0;
	ToShowPart="$2";
	ShowOrStartXsession "$@"
	;;
--rxs | --run-x-session )
	StartIt=1;
	ToShowPart="$2";
	ShowOrStartXsession "$@"
	;;
--in-file | --if )
	if [[ ! -z "$2" && -e "$2" && -f "$2" ]];
	then 
		awk  -v CLR="$DISABLE_COLORS" -v FindIt="$3" -v Trans="$4" -F= '/^create/;{ 
		ToLowerTwo=tolower($2);
		ToLowerOne=tolower($1);
		ToLowerFindIt=tolower(FindIt);
			if(Trans)
			{
			split(Trans,ArrayTransLang,",");
			for(ReLangArray in ArrayTransLang )NewArrTrans[ArrayTransLang[ReLangArray]]=1;
			}				
		if(index($1,"]") == 0)
			{
			Var[CountV++]=$1;
			if(length($2) != 0)
				  {
				  InString[CountS++]=substr($0,index($0,$2));
			  	  }else{
				  InString[CountS++]="";
			   	  }
			if(FindIt)if(index(ToLowerTwo,ToLowerFindIt) != 0){YES="1";GotItAll[Cgot++]=$0 }
				if(FindIt && length($2) != 0)if(index(ToLowerOne,ToLowerFindIt) != 0){YES="1";GotItAll[Cgot++]=$0 }
			};
		if(index($1,"[") != 0 && index($1,"[") != 1 ){
			split($1,Lang,"[");			
			TmpLang=Lang[2];		
			UniqLang[TmpLang]++;
			sub("]","",TmpLang);
			if(Trans)
			  {
			  if( NewArrTrans[TmpLang] == 1 )
			   {   
			  Var[CountV++]=$1;
			  if(length($2) != 0)
				  {
				  InString[CountS++]=substr($0,index($0,$2))
			  	  }else{
				  InString[CountS++]="";
			   	  }
		  	   }			  				
			  }						 
			};
			if(index($1,"[") == 1){
			Var[CountV++]=$1;
			InString[CountS++]=$0}			
			}END{
		if(YES == "1" )
			{
				if(CLR == "YES")
				{
				printf "*  " FILENAME "@ Total translations: "length(UniqLang)": ";
				}else{
				printf "* \033[2;32m" FILENAME "\033[0m\n@ Total translations: "length(UniqLang)": ";
				}
			if(length(UniqLang) != 0)for(AllLang in UniqLang){sub("]","",AllLang);printf "%s",AllLang",";}
			print " ";
			if(length(UniqLang) != 0)for(GetS in InString )if(index(Var[GetS],"[") != 0 && index(InString[GetS],"[") != 1)print Var[GetS]"="InString[GetS];
				for(TheGotItAll in GotItAll)print GotItAll[TheGotItAll];
			}
		if(length(FindIt) == 0)
			{
				if(CLR == "YES")
				{
				printf "* " FILENAME "\n@ Total translations: "length(UniqLang)": ";
				}else{
				printf "* \033[2;32m" FILENAME "\033[0m\n@ Total translations: "length(UniqLang)": ";
				}
			if(length(UniqLang) != 0)for(AllLang in UniqLang)
				{
					sub("]","",AllLang);printf "%s",AllLang",";
				}
				print " ";
				for (I in InString)
					if(index(Var[I],"[") != 1 && length(Var[I]) != 0 && index(Var[I],"#") != 1  )
						{
							if(index(InString[I]"=",Var[I]"=") != 1 )
								{
								print Var[I]"="InString[I]
								}
							else
								{	
								print Var[I]"="
								}
						}
						else
						{ 
							if(index(Var[I],"[") == 1)
								if(CLR == "YES")
								{
						       		printf Var[I]"\n"
								}else{
						       		printf "\033[2;33m"Var[I]"\033[2;0m \n"
								}
						}
			}
			     }'  "$2"
	 else
		echo 'Use valid path to the .desktop file'

	fi
	;;
--to-null | --tn | --da | --disable-autostart )
	if [[ ! -e /dev/null ]];
	then
		echo "# The /dev/null is not existing! Use the command below to create it:"
		echo 'mknod /dev/null c 1 3 && chmod 666 /dev/null'
	else
		[[ ! -d "$HOME"'/.config/autostart/' ]] && mkdir -p "$HOME"'/.config/autostart';
		[[ ! -d "/etc/xdg/autostart" ]] && echo 'Not existing: "/etc/xdg/autostart"' && exit 1
		for InDir in /etc/xdg/autostart/*;
		do
			echo ln -s /dev/null "$HOME"'/.config/autostart/'"${InDir//*\//}"
			[[ ! -e "$HOME"'/.config/autostart/'"${InDir//*\//}" ]] && ln -s /dev/null "$HOME"'/.config/autostart/'"${InDir//*\//}";
		done
	fi
	;;
--cbf | --create-base-file )
	echo 'Actions
Categories
Comment
DBusActivatable
DocPath
Encoding
Exec
FilePattern
GenericName
Hidden
Icon
InitialPreference
Keywords
MimeType
Name
NoDisplay
NotShowIn
OnlyShowIn
Path
Patterns
ServiceTypes
StartupNotify
StartupWMClass
TargetEnvironment
Terminal
TryExec
Type
Version'
	;;

--empty-categories | --ec )
	BaseVarUpdate "$@"
	Opts="empty-ctg"
	ReCreateDskPath "$@"
        SearchContentOfVariable "$@"
	;;

--empty-categories-exec | --ece )
	BaseVarUpdate "$@"
	Opts="empty-ctg-with-exec"
	ReCreateDskPath "$@"
        SearchContentOfVariable "$@"
	;;

--description | --d )
	BaseVarUpdate "$@"
	Opts="description"
	ReCreateDskPath "$@"
        SearchContentOfVariable "$@"
	;;
 
 * ) 
	BaseVarUpdate "$@"
	ReCreateDskPath "$@"
	ListDefault "$@"
	;;
esac
