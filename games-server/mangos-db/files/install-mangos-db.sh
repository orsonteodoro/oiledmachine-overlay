PREFIX="$1"
USER="$2"
PASSWORD="$3"
ENGINE="$4" #can be mangos or cmangos
ACID_TYPE="$5" #0=classic, 1=tbc, 2=wotlk, 3=cata 4=no_acid
MODE="$6" #can be new safe_update unsafe_update

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

check_success() {
        if [[ "$?" == "0" ]]; then
                echo "Success adding $f"
        else
            	echo "Failed adding $f"
        fi
}

add_db() {
	f="${1}"
        mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${2} < "$f"
        check_success
}

debug_msg() {
	#echo $1
	#echo "$1" >> debug.log
	true
}

ID_CHARACTERS="characters"
ID_WORLD="mangos"
ID_AUTH="realmd"
ID_SCRIPTDEV_VERSION="2"
ID_SCRIPTDEV="scriptdev${ID_SCRIPTDEV_VERSION}" #todo?

source make_full_WorldDB.sh

if [[ "$MODE" == "new" ]]; then
	TF=`tempfile`
	f="World/Setup/mangosdCreateDB.sql"
	if [ -f "$f" ] ; then
		cat "$f" | sed -r -e "s|\`character[s0-9]*\`|\`${PREFIX}_${ID_CHARACTERS}\`|g" -e "s|\`realmd\`|\`${PREFIX}_${ID_AUTH}\`|g" -e "s|\`mangos[0]?\`|\`${PREFIX}_${ID_WORLD}\`|g" > $TF
		cat $TF > cdb1.sql
		mysql --user="$USER" --password="$PASSWORD" < $TF
		check_success
	else
		mysql --user="$USER" --password="$PASSWORD" -e "CREATE DATABASE \`${PREFIX}_${ID_WORLD}\`"
		f="CREATE DATABASE \`${PREFIX}_${ID_WORLD}\`" check_success
		mysql --user="$USER" --password="$PASSWORD" -e "CREATE DATABASE \`${PREFIX}_${ID_CHARACTERS}\`"
		f="CREATE DATABASE \`${PREFIX}_${ID_CHARACTERS}\`" check_success
		mysql --user="$USER" --password="$PASSWORD" -e "CREATE DATABASE \`${PREFIX}_${ID_AUTH}\`"
		f="CREATE DATABASE \`${PREFIX}_${ID_AUTH}\`" check_success
	fi

	f="World/Setup/mangosdLoadDB.sql"
	if [ -f "$f" ] ; then
		mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_WORLD} < "$f"
		check_success
	fi

	f="Character/Setup/characterCreateDB.sql"
	if [ -f "$f" ] ; then
		cat "$f" | sed -r -e "s|\`character[s0-9]*\`|\`${PREFIX}_${ID_CHARACTERS}\`|g" > $TF
		cat $TF > cdb2.sql
		mysql --user="$USER" --password="$PASSWORD" < $TF
		check_success
	fi

	f="Character/Setup/characterLoadDB.sql"
	if [ -f "$f" ] ; then
		mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_CHARACTERS} < "$f"
		check_success
	fi

	f="Realm/Setup/realmdCreateDB.sql"
	if [ -f "$f" ] ; then
		cat "$f" | sed -r -e "s|\`${ID_AUTH}\`|\`${PREFIX}_${ID_AUTH}\`|g" > $TF
		mysql --user="$USER" --password="$PASSWORD" < $TF
		cat $TF > cdb3.sql
		check_success
	fi

	f="Realm/Setup/realmdLoadDB.sql"
	if [ -f "$f" ] ; then
		mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_AUTH} < "$f"
		check_success
	fi
fi

if [[ "$MODE" == "new" || "$MODE" == "unsafe_update" ]]; then
	if [ -f "full_db.sql" ] ; then
		add_db "full_db.sql" "${ID_WORLD}"
	elif [ -d "_full_db" ] ; then
		find _full_db -name "*.sql" -print0 | sort -z | while read -d $'\0' f
		do
			add_db "$f" "${ID_WORLD}"
		done
	fi
fi

VERSIONING_SCHEME="" #can be 3column, 5digit, 4digit
get_mangos_version() {
	local FOUND="0"

	mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_WORLD} -e "SHOW COLUMNS FROM db_version" | grep -P "required_[rcz]?[0-9]+_[0-9]+"
	if [[ "$?" == "0" ]] ; then
		#required_20000_11_Creature_Template_repair scheme
		MANGOS_VERSION=$(mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_WORLD} -e "SHOW COLUMNS FROM db_version" | grep "required_" | sed -r -e "s|required_[rcz]?([0-9]+)_([0-9]+).*|\1.\2|g")
		FOUND="1"
	fi

	IS_NEW_VERSIONING_SCHEME=$(mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_WORLD} -e "SHOW COLUMNS FROM db_version LIKE \"structure\"" | sed "s|\t|.|g" | wc -l)
	if [[ "${FOUND}" == "0" && "${IS_NEW_VERSIONING_SCHEME}" != "0" ]] ; then
		#yes use 3 column versioning
		MANGOS_VERSION=$(mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_WORLD} -e "SELECT version,structure,content FROM db_version ORDER BY version, structure, content" | sed "s|\t|.|g" | tail -n 1)
		VERSIONING_SCHEME="3column"
		FOUND="1"
	fi

	mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_WORLD} -e "SELECT version FROM db_version ORDER BY version" | sed "s|\t|.|g" | grep "for" | grep -o -P "MaNGOS[Zero ]* [zs]*[0-9]+" | grep -P -o "[0-9]+"
	if [[ "${FOUND}" == "0" && "$?" == "0" ]]; then
		#new 5 digit versioning
		MANGOS_VERSION=$(mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_WORLD} -e "SELECT version FROM db_version ORDER BY version" | sed "s|\t|.|g" | grep "for" | grep -o -P "MaNGOS[Zero ]* [zs]*[0-9]+" | grep -P -o "[0-9]+")
		VERSIONING_SCHEME="5digit"
		FOUND="1"
	fi

	if [[ "${FOUND}" == "0" ]] ; then
		#old 4 digit versioning before 0.20
		MANGOS_VERSION=$(mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_WORLD} -e "SELECT version FROM db_version ORDER BY version" | sed "s|\t|.|g" | grep Rev | sed -r -e "s|.*Rev ([0-9)]+)|\1|g" -e "s|_|.|g")
		VERSIONING_SCHEME="4digit"
		FOUND="1"
	fi
}

#Base Install of 21000_00 to Rel21_5_3; it will return 21.5.3
get_characters_version() {
	local FOUND="0"

	mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_CHARACTERS} -e "SHOW COLUMNS FROM character_db_version" | grep -P "required_[rcz]?[0-9]+_[0-9]+"
	if [[ "${FOUND}" == "0" && "$?" == "0" ]] ; then
		CHARACTERS_VERSION=$(mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_CHARACTERS} -e "SELECT * FROM character_db_version" | grep "required" | sed -r -e "s|.*required_[rcz]?([0-9_]+)_([0-9]+).*|\1.\2|g" -e "s|[_]?$||g" -e "s|_|.|g")
		FOUND="1"
	fi

	mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_CHARACTERS} -e "SHOW COLUMNS FROM character_db_version" | grep -P "required_[rcz]?[0-9]+_[A-Za-Z]+"
	if [[ "${FOUND}" == "0" && "$?" == "0" ]] ; then
		CHARACTERS_VERSION=$(mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_CHARACTERS} -e "SELECT * FROM character_db_version" | grep "required" | sed -r -e "s|.*required_[rcz]?([0-9_]+).*|\1|g" -e "s|[_]?$||g" -e "s|_|.|g")
		FOUND="1"
	fi

	if [[ "${FOUND}" == "0" ]] ; then
		CHARACTERS_VERSION=$(mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_CHARACTERS} -e "SELECT version,structure,content FROM db_version ORDER BY version, structure, content" | sed "s|\t|.|g" | tail -n 1)
		FOUND="1"
	fi
}

#Base Install of 21000_00 to Rel21_5_3; it will return 21000.00
get_characters_begin_version()
{

	CHARACTERS_BEGIN_VERSION=$(mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_CHARACTERS} -e "SELECT comment FROM db_version ORDER BY comment" | sed -r -e "s|.* [a-z]+ ([0-9_]+) to.*|\1|g")
}

#Base Database from 20150409 to Rel21_1_3;  it will return 21.1.3
get_realmd_version() {
	local FOUND="0"
	mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_AUTH} -e "SHOW COLUMNS FROM ${ID_AUTH}_db_version" | grep -P "required_[rcz]?[0-9]+_[0-9]+"
	if [[ "$?" == "0" ]] ; then
		#required_20000_11_Creature_Template_repair scheme
		MANGOS_VERSION=$(mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_AUTH} -e "SHOW COLUMNS FROM ${ID_AUTH}_db_version" | grep "required_" | sed -r -e "s|required_[rcz]?([0-9]+)_([0-9]+).*|\1.\2|g")
		FOUND="1"
	fi

	mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_AUTH} -e "SHOW COLUMNS FROM ${ID_AUTH}_db_version" | grep -P "required_"
	if [[ "${FOUND}" == "0" && "$?" == "0" ]] ; then
		REALMD_VERSION=$(mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_AUTH} -e "SELECT * FROM ${ID_AUTH}_db_version" | grep "required" | sed -r -e "s|.*required_[rcz]?([0-9_]+).*|\1|g" -e "s|[_]?$||g" -e "s|_|.|g")
		FOUND="1"
	fi

	if [[ "${FOUND}" == "0"  ]] ; then
		REALMD_VERSION=$(mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_AUTH} -e "SELECT version,structure,content FROM db_version ORDER BY version, structure, content" | sed "s|\t|.|g" | tail -n 1)
		FOUND="1"
	fi
}

#Base Database from 20150409 to Rel21_1_3;  it will return 20150409
get_realmd_begin_verison() {
	REALMD_BEGIN_VERSION=$(mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_AUTH} -e "SELECT comment FROM db_version ORDER BY comment" | sed -r -e "s|.* [a-z]+ ([0-9_]+) to.*|\1|g")
}

get_head_revision() {
	REVISION=$(basename $(find World/Updates -maxdepth 1 -type d | sort | tail -n1))
}

get_walking_revision() {
	WALKING_REVISION=$($(basename "$1") | grep -o -P "/Rel[0-9]+/" | sed -r -e "s|/||g")
}

get_current_revision() {
	get_mangos_version
	REV_PATH=$(find "$1" -name "*${MANGOS_VERSION//./_}*" | tail -n 1)
	REVISION=$(echo "${REV_PATH}" | grep -o -P "/Rel[0-9]+/" | sed -r -e "s|/||g")
	debug_msg "REVISION is ${REVISION}"
}


version_lt() { # x < y      1 < 2 true
	RESULT=$(echo -e "$1\n$2" | sort -V | head -n 1)
	if [[ "${RESULT}" == "$1" ]] ; then
		return 0 #true/success
	else
		return 1 #false
	fi
}

version_gt() { # x > y      2 > 1 true
	RESULT=$(echo -e "$1\n$2" | sort -Vr | head -n 1)
	if [[ "${RESULT}" == "$1" ]] ; then
		return 0 #true/success
	else
		return 1 #false
	fi
}

get_mangos_version
find World/Updates/ -name "*.sql" -print0 | sort -z | while read -d $'\0' f
do
	FOUND="0"
	echo $(basename "$f") | grep -P "^Rel[0-9]+_" > /dev/null
	if [[ "$?" == "0" ]]; then
		debug_msg "variant 1"
		FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|[Rel]*([0-9]+_[0-9]+_[0-9]+).*|\1|g" -e "s|_|.|g") #Rel21_11_12_quest1222.sql
		FOUND="1"
	fi

	echo $(basename "$f") | grep -P "^[zrs][0-9]+_" > /dev/null
	if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
		debug_msg "variant 2"
		FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|^[zrs]([0-9]+).*|\1|g")
		FOUND="1"
	fi

	echo $(basename "$f") | grep -P "^[0-9]+-[0-9]+" > /dev/null
	if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
		debug_msg "variant 3"
		FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|^([0-9]+)-.*|\1|g")
		FOUND="1"
	fi

	echo $(basename "$f") | grep -P "[0-9]{8}_" > /dev/null
	if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
		debug_msg "variant 3a"
		FILE_VERSION=$(echo $(basename "$f") | grep -o -P "[0-9]{8}") #date
		FOUND="1"
	fi

	echo $(basename "$f") | grep -P "^[0-9]+_[0-9]+[a-z]?_" > /dev/null
	if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
		debug_msg "variant 4"
		FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|^([0-9]+)_([0-9]+)[a-z]?_.*|\1.\2|g") # 20004_07_spell_chain.sql
		FOUND="1"
	fi

	echo $(basename "$f") | grep -P "^[0-9][0-9][0-9]?_" >/dev/null
	if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
		debug_msg "variant 5"
		FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|^([0-9]+)_.*|\1|g") #2 digit or 3 digit content.  look inside for the database version
		FOUND="1"
		get_current_revision "World/Updates"
		grep -r -e "db_version" "$f" > /dev/null
		if [[ "$?" == "0" ]]; then
			grep -r -e "db_version" "$f" | grep -i "SET" > /dev/null
			RET0="$?"
			if [[ "$RET0" == "0" ]] ; then
				FILE_VERSION=$(grep -r -e "db_version" "$f" | grep -i "SET" | grep " for " | sed -r -e "s|.*MaNGOS[Zero ]*[zs]([0-9]+).*|\1|g")
			else
				grep -r -e "db_version" "$f" | grep -P "MaNGOS[Zero ]*[z]?XXXX" > /dev/null
				RET1="$?"
				if [[ "$RET1" == "0" && "$f" =~ "${REVISION}" ]] ; then
					FILE_VERSION="$((MANGOS_VERSION+1))"
				elif [[ "$RET1" == "0" && ! "$f" =~ "${REVISION}"  ]] ; then
					FILE_VERSION="0"
				else
					FILE_VERSION=$(grep -r -e "db_version" "$f" | grep -P -o -i "required_[rcz]?[0-9]+" | sed -r -e "s|required_[rcz]?||g" | sort | tail -n 1)
				fi
			fi
		else
			if [[ "$f" =~ "${REVISION}" ]] ; then
				FILE_VERSION="$((MANGOS_VERSION+1))" #just merge the current content
			else
				FILE_VERSION="0" #don't merge any old content
			fi
		fi
	fi

	DOTS_LEFT=$(echo "${FILE_VERSION}" | awk -F "." '{ print NF-1 }')
	DOTS_RIGHT=$(echo "${MANGOS_VERSION}" | awk -F "." '{ print NF-1 }')

	debug_msg "current: $f"
	version_gt "${FILE_VERSION}" "${MANGOS_VERSION}"
	R1="$?"

	version_gt "${DOTS_LEFT}" "${DOTS_RIGHT}"
	R2="$?"

	debug_msg "${FILE_VERSION} > ${MANGOS_VERSION} && ${DOTS_LEFT} > ${DOTS_RIGHT}"
	if [[ "${R1}" == "0" && ( "${R2}" == "0" || "${DOTS_LEFT}" == "${DOTS_RIGHT}" ) ]] ; then
		debug_msg "${FILE_VERSION} > ${MANGOS_VERSION} && ${DOTS_LEFT} > ${DOTS_RIGHT} yes"
		add_db "$f" "${ID_WORLD}"
		get_mangos_version
	fi
done

get_characters_version
find Character/Updates/ -name "*.sql" -print0 | sort -z | while read -d $'\0' f
do
	FOUND="0"
	echo $(basename "$f") | grep -P "^Rel[0-9]+_" > /dev/null
	if [[ "$?" == "0" ]]; then
		debug_msg "variant 6"
		FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|[Rel]*([0-9]+_[0-9]+_[0-9]+).*|\1|g" -e "s|_|.|g")
		FOUND="1"
	fi

	echo $(basename "$f") | grep -P "^[0-9]+_[0-9]+[a-z]?_" > /dev/null
	if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
		debug_msg "variant 7"
		FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|^([0-9]+)_([0-9]+)[a-z]?_.*|\1.\2|g")
		FOUND="1"
	fi

	echo $(basename "$f") | grep -P "^[0-9]+_" > /dev/null
	if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
		debug_msg "variant 8"
		FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|^([0-9]+).*|\1|g")
		FOUND="1"
	fi

	DOTS_LEFT=$(echo "${FILE_VERSION}" | awk -F "." '{ print NF-1 }')
	DOTS_RIGHT=$(echo "${CHARACTERS_VERSION}" | awk -F "." '{ print NF-1 }')

	debug_msg "current: $f"
	version_gt "${FILE_VERSION}" "${CHARACTERS_VERSION}"
	R1="$?"

	version_gt "${DOTS_LEFT}" "${DOTS_RIGHT}"
	R2="$?"

	debug_msg "${FILE_VERSION} > ${CHARACTERS_VERSION} && ${DOTS_LEFT} > ${DOTS_RIGHT}"
	if [[ "${R1}" == "0" && ( "${R2}" == "0" || "${DOTS_LEFT}" == "${DOTS_RIGHT}" ) ]] ; then
		debug_msg "${FILE_VERSION} > ${CHARACTERS_VERSION} && ${DOTS_LEFT} > ${DOTS_RIGHT} yes"
		add_db "$f" "${ID_CHARACTERS}"
		get_characters_version
	fi
done

get_realmd_version
find Realm/Updates/ -name "*.sql" -print0 | sort -z | while read -d $'\0' f
do
	FOUND="0"
	echo $(basename "$f") | grep -P "^Rel[0-9]+_" > /dev/null
	if [[ "$?" == "0" ]]; then
		debug_msg "variant 9"
		FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|[Rel]*([0-9]+_[0-9]+_[0-9]+).*|\1|g" -e "s|_|.|g")
		FOUND="1"
	fi

	echo $(basename "$f") | grep -P "^[zrs][0-9]+_" > /dev/null
	if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
		debug_msg "variant 10"
		FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|^[zrs]([0-9]+).*|\1|g")
		FOUND="1"
	fi

	echo $(basename "$f") | grep -P "[0-9]{8}_" > /dev/null
	if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
		debug_msg "variant 11"
		FILE_VERSION=$(echo $(basename "$f") | grep -o -P "[0-9]{8}") #date
		FOUND="1"
	fi

	echo $(basename "$f") | grep -P "^[0-9]+_" > /dev/null
	if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
		debug_msg "variant 12"
		FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|^([0-9]+)_.*|\1|g" -e "s|_|.|g") #20004_dbDocs_Update.sql
		FOUND="1"
	fi

	DOTS_LEFT=$(echo "${FILE_VERSION}" | awk -F "." '{ print NF-1 }')
	DOTS_RIGHT=$(echo "${REALMD_VERSION}" | awk -F "." '{ print NF-1 }')

	debug_msg "current: $f"
	version_gt "${FILE_VERSION}" "${REALMD_VERSION}"
	R1="$?"

	version_gt "${DOTS_LEFT}" "${DOTS_RIGHT}"
	R2="$?"

	debug_msg "${FILE_VERSION} > ${REALMD_VERSION} && ${DOTS_LEFT} > ${DOTS_RIGHT}"
	if [[ "${R1}" == "0" && ( "${R2}" == "0" || "${DOTS_LEFT}" == "${DOTS_RIGHT}" ) ]] ; then
		debug_msg "${FILE_VERSION} > ${REALMD_VERSION} && ${DOTS_LEFT} > ${DOTS_RIGHT} yes"
		add_db "$f" "${ID_AUTH}"
		get_realmd_version
	fi
done

#for mangosfour
get_realmd_version
find _updates -name "*.sql" -print0 | sort -z | while read -d $'\0' f
do
	add_db "$f" "${ID_WORLD}"
done

echo "FINAL VERSIONS"
get_mangos_version
get_characters_version
get_realmd_version
echo "MANGOS_VERSION is ${MANGOS_VERSION}"
echo "CHARACTERS_VERSION is ${CHARACTERS_VERSION}"
echo "REALMD_VERSION is ${REALMD_VERSION}"

if [[ "${ACID_TYPE}" == "0" ]] ; then
	if [ -f "/usr/share/acid/0/acid_classic.sql" ] ; then
		add_db "/usr/share/acid/0/acid_classic.sql" "${ID_WORLD}"
	fi
fi
if [[ "${ACID_TYPE}" == "1" ]] ; then
	if [ -f "/usr/share/acid/1/acid_tbc.sql" ] ; then
		add_db "/usr/share/acid/1/acid_tbc.sql" "${ID_WORLD}"
	fi
fi
if [[ "${ACID_TYPE}" == "2" ]] ; then
	if [ -f "/usr/share/acid/2/acid_wotlk.sql" ] ; then
		add_db "/usr/share/acid/2/acid_wotlk.sql" "${ID_WORLD}"
	fi
fi
if [[ "${ACID_TYPE}" == "3" ]] ; then
	if [ -f "/usr/share/acid/3/acid_cata.sql" ] ; then
		add_db "/usr/share/acid/3/acid_cata.sql" "${ID_WORLD}"
	fi
fi

unset PASSWORD
