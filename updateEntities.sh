#!/bin/bash
SHELL=/bin/bash
echo "Empezó a escribir"
file="./ReadFile"
COUNT=0
while IFS='|' read -r entidad domain periodicidad ult_act prioridad || [ -n "$entidad" ];
do
	COUNT=`expr $COUNT + 1`
	echo Este es el valor de count $COUNT
	TODAY=`date +%Y-%m-%d`
	echo Este es el valor de TODAY $TODAY
	TARGET_DATE=`date --date "-$periodicidad days" +%Y-%m-%d`
	echo Este es el valor de TARGET_DATE $TARGET_DATE
	LAST_MOD=`date --date "$ult_act" +%s` 
	echo Este es el valor de LAST_MOD $LAST_MOD
	TARGET_DAY_NUMBER=`date --date "$TARGET_DATE" +%s`
	echo Este es el valor de TARGET_DAY_NUMBER $TARGET_DAY_NUMBER
	DIFFERENCE=`expr $TARGET_DAY_NUMBER - $LAST_MOD`
	echo Este es el valor de DIFFERENCE $DIFFERENCE
	if [ $DIFFERENCE -eq 0 ]
	then
		echo `date` : Iniciando invocación de la entidad $entidad >> /updateEntitiesLog/EntityMembersSyncLog.txt
		STATUS_CODE=$(curl --noproxy "*" -s -o /dev/null -w "%{http_code}" -H "entityName:EstadoCivil" -H "domain:CLASIFICACIONES" http://10.88.36.33:8095/invoke) 
		#STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -H "entityName:$entidad" -H "domain:$domain" http://localhost:8090/invoke) 
		if [ $STATUS_CODE -eq "200" ]
		then
			LINE_TO_REPLACE="$entidad|$domain|$periodicidad|$TODAY|$prioridad"
			sed -i "${COUNT}s/.*/$LINE_TO_REPLACE/" ./ReadFile
			echo `date` : Invocacion exitosa de la entidad $entidad >> /updateEntitiesLog/EntityMembersSyncLog.txt
		else
			echo `date` : Invocacion fallida de la entidad $entidad >>  /updateEntitiesLog/EntityMembersSyncLog.txt
		fi
	fi
done < "$file"