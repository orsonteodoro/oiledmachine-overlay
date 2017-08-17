PREFIX="$1"
USER="$2"
PASSWORD="$3"
ENGINE="$4" #can be mangos cmangos trinitycore
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

ID_WORLD="mangos"
ID_AUTH="realmd"
ID_CHARACTERS="characters"
ID_SCRIPTDEV_VERSION="2"
ID_SCRIPTDEV="scriptdev${ID_SCRIPTDEV_VERSION}"
if [[ "$ENGINE" == "mangos" || "$ENGINE" == "cmangos" ]]; then
	ID_WORLD="mangos"
	ID_AUTH="realmd"
elif [[ "$ENGINE" == "trinitycore" ]]; then
	ID_WORLD="world"
	ID_AUTH="auth"
else
	debug_msg "Engine is not supported."
	exit 1
fi

if [[ "$MODE" == "new" ]]; then
	TF=`tempfile`
	f="sql/create/db_create_mysql.sql"
	cat "$f" | sed -e "s|${ID_CHARACTERS}|${PREFIX}_${ID_CHARACTERS}|g" -e "s|${ID_AUTH}|${PREFIX}_${ID_AUTH}|g" -e "s|\`${ID_WORLD}\`|\`${PREFIX}_${ID_WORLD}\`|g" > $TF
	mysql --user="$USER" --password="$PASSWORD" < $TF
	check_success
	add_db "sql/base/${ID_CHARACTERS}.sql" "${ID_CHARACTERS}"
	add_db "sql/base/${ID_AUTH}.sql" "${ID_AUTH}"
	add_db "sql/base/${ID_WORLD}.sql" "${ID_WORLD}"

	find sql/base/dbc/original_data -name "*.sql" -print0 | while read -d $'\0' f
	do
		add_db "$f" "${ID_WORLD}"
	done

	find sql/base/dbc/cmangos_fixes -name "*.sql" -print0 | while read -d $'\0' f
	do
		add_db "$f" "${ID_WORLD}"
	done
fi

if [[ "$MODE" == "new" || "$MODE" == "unsafe_update" ]]; then
	find Current_Release/Full_DB -maxdepth 1 -name "*.sql" -print0 | while read -d $'\0' f
	do
		add_db "$f" "${ID_WORLD}"
	done
fi

DB_REVISION=$(grep -r -e "INTO \`db_version" Current_Release/Full_DB/*.sql | sed -r -e "s|.*\(([0-9]+)\).*|\1|g")
echo "DB_REVISION is ${DB_REVISION}"
find Current_Release/Updates/ -name "*.sql" -print0 | sort -z | while read -d $'\0' f
do
	FILE_REVISION=$(echo $(basename $f) | sed -r -e "s|^([0-9]+).*|\1|g")
	if (( 10#$FILE_REVISION > 10#$DB_REVISION )) ; then
		if [[ "$f" =~ "${ID_WORLD}" ]]; then
			add_db "$f" "${ID_WORLD}"
		elif [[ "$f" =~ "${ID_CHARACTERS}" ]]; then
			add_db "$f" "${ID_CHARACTERS}"
		fi
	fi
done

find Updates -name "*.sql" -print0 | sort -z | while read -d $'\0' f
do
	add_db "$f" "${ID_WORLD}"
done

get_mangos_version() {
	MANGOS_VERSION=$(mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_WORLD} -e "SELECT * FROM db_version" | grep "required_" | sed -r -e "s|.*required_([0-9]+).*|\1|g")
}
get_characters_version() {
	CHARACTERS_VERSION=$(mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_CHARACTERS} -e "SELECT * FROM character_db_version" | grep "required_" | sed -r -e "s|.*required_([0-9]+).*|\1|g")
}
get_realmd_version() {
	REALMD_VERSION=$(mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_AUTH} -e "SELECT * FROM realmd_db_version" | grep "required_" | sed -r -e "s|.*required_([0-9]+).*|\1|g")
}
get_mangos_version
get_characters_version
get_realmd_version
echo "MANGOS_VERSION is ${MANGOS_VERSION}"
echo "CHARACTERS_VERSION is ${CHARACTERS_VERSION}"
echo "REALMD_VERSION is ${REALMD_VERSION}"
find sql/archive/ -name "*.sql" -print0 | sort -z | while read -d $'\0' f
do
	FILE_VERSION=$(echo $(basename $f) | sed -r -e "s|^([0-9]+).*|\1|g")
        if (( 10#$FILE_VERSION >= 10#$MANGOS_VERSION )) ; then
		if [[ "$f" =~ "_${ID_WORLD}_" ]] ; then
			add_db "$f" "${ID_WORLD}"
			get_mangos_version
		fi
	fi
        if (( 10#$FILE_VERSION >= 10#$CHARACTERS_VERSION )) ; then
		if [[ "$f" =~ "_${ID_CHARACTERS}_" ]] ; then
			add_db "$f" "${ID_CHARACTERS}"
			get_characters_version
		fi
	fi
        if (( 10#$FILE_VERSION >= 10#$REALMD_VERSION )) ; then
		if [[ "$f" =~ "_${ID_AUTH}_" ]] ; then
			add_db "$f" "${ID_AUTH}"
			get_realmd_version
		fi
	fi
done

get_mangos_version
get_characters_version
get_realmd_version
echo "MANGOS_VERSION is ${MANGOS_VERSION}"
echo "CHARACTERS_VERSION is ${CHARACTERS_VERSION}"
echo "REALMD_VERSION is ${REALMD_VERSION}"
find sql/updates/ -name "*.sql" -print0 | sort -z | while read -d $'\0' f
do
	FILE_VERSION=$(echo $(basename $f) | sed -r -e "s|^([0-9]+).*|\1|g")
        if (( 10#$FILE_VERSION >= 10#$MANGOS_VERSION )) ; then
		if [[ "$f" =~ "_${ID_WORLD}_" ]] ; then
			add_db "$f" "${ID_WORLD}"
			get_mangos_version
		fi
	fi
        if (( 10#$FILE_VERSION >= 10#$CHARACTERS_VERSION )) ; then
		if [[ "$f" =~ "_${ID_CHARACTERS}_" ]] ; then
			add_db "$f" "${ID_CHARACTERS}"
			get_characters_version
		fi
	fi
        if (( 10#$FILE_VERSION >= 10#$REALMD_VERSION )) ; then
		if [[ "$f" =~ "_${ID_AUTH}_" ]] ; then
			add_db "$f" "${ID_AUTH}"
			get_realmd_version
		fi
	fi
done

f="sql/sd${ID_SCRIPTDEV_VERSION}/${ID_SCRIPTDEV}_create_database.sql"
cat "$f" | sed -e "s|${ID_SCRIPTDEV}|${PREFIX}_${ID_SCRIPTDEV}|g" > $TF
mysql --user="$USER" --password="$PASSWORD" < $TF
check_success
add_db "sql/sd${ID_SCRIPTDEV_VERSION}/${ID_SCRIPTDEV}_create_structure_mysql.sql" "${ID_SCRIPTDEV}"
add_db "sql/sd${ID_SCRIPTDEV_VERSION}/${ID_SCRIPTDEV}_script_full.sql" "${ID_SCRIPTDEV}"
add_db "sql/sd${ID_SCRIPTDEV_VERSION}/${ID_WORLD}_scriptname_full.sql" "${ID_WORLD}"

SD_VERSION=$(ls $(find sql/sd${ID_SCRIPTDEV_VERSION}/updates/ -type d | sort | tail -n 1) | sort | tail -n 1 | sed -r -e "s|r([0-9]+).*|\1|g")
echo "SD_VERSION is $SD_VERSION"
#find $(find sql/sd${ID_SCRIPTDEV_VERSION}/updates/ -type d | sort) -name "*.sql" -print0 | sort -z | while read -d $'\0' f
find sql/sd${ID_SCRIPTDEV_VERSION}/updates/ -maxdepth 1 -name "*.sql" -print0 | sort -z | while read -d $'\0' f
do
  	VERSION=$(echo $(basename "$f") | sed -r -e "s|[r]?([0-9]+).*|\1|g")
        if (( 10#$VERSION > 10#$SD_VERSION )) ; then
                if [[ "$f" =~ "${ID_WORLD}.sql" ]] ; then
                        mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_WORLD} < "$f"
                        check_success
                else
                    	mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_SCRIPTDEV} < "$f"
                        check_success
                fi
        fi
done

if [[ $ENGINE == "cmangos" ]]; then
	add_db "sql/${ID_SCRIPTDEV}/${ID_SCRIPTDEV}.sql" "${ID_WORLD}"
fi

add_db "sql/sd${ID_SCRIPTDEV_VERSION}/optional/${ID_WORLD}_optional_generic_creature.sql" "${ID_WORLD}"
add_db "sql/acid/acid_wotlk.sql" "${ID_WORLD}"

echo "FINAL VERSIONS"
get_mangos_version
get_characters_version
get_realmd_version
echo "MANGOS_VERSION is ${MANGOS_VERSION}"
echo "CHARACTERS_VERSION is ${CHARACTERS_VERSION}"
echo "REALMD_VERSION is ${REALMD_VERSION}"
SD2_VERSION=$(ls sql/sd${ID_SCRIPTDEV_VERSION}/updates/* | sort | tail -n 1 | sed -r -e "s|.*r([0-9]+).*|\1|g")
echo "SD_VERSION is ${SD2_VERSION}"

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
