PREFIX="$1"
USER="$2"
PASSWORD="$3"
ENGINE="$4"
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

version_gt() { # x > y      2 > 1 true
        RESULT=$(echo -e "$1\n$2" | sort -Vr | head -n 1)
        if [[ "${RESULT}" == "$1" ]] ; then
                return 0 #true/success
        else
            	return 1 #false
        fi
}

ID_CHARACTERS="characters"
ID_WORLD="mangos"
ID_AUTH="realmd"
ID_SCRIPTDEV="scriptdev2"

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
	find Development/database -name "*.sql" -print0 | while read -d $'\0' f
	do
		if [[ "$f" =~ "characters.sql" ]]; then
			continue
		fi

		if [[ "$f" =~ "realmd.sql" ]]; then
			continue
		fi

		if [[ "$f" =~ "${ID_SCRIPTDEV}" ]]; then
			continue
		fi

	  	add_db "$f" "${ID_WORLD}"
	done
fi

f="sql/sd2/${ID_SCRIPTDEV}_create_database.sql"
cat "$f" | sed -e "s|${ID_SCRIPTDEV}|${PREFIX}_${ID_SCRIPTDEV}|g" > $TF
mysql --user="$USER" --password="$PASSWORD" < $TF
check_success
add_db "sql/sd2/${ID_SCRIPTDEV}_create_structure_mysql.sql" "${ID_SCRIPTDEV}"
add_db "sql/sd2/${ID_SCRIPTDEV}_script_full.sql" "${ID_SCRIPTDEV}"
add_db "sql/sd2/${ID_WORLD}_scriptname_full.sql" "${ID_SCRIPTDEV}"

SD_VERSION=$(grep -r -e "sd2_db_version" sql/sd2/${ID_SCRIPTDEV}_script_full.sql | tail -n 1 | sed -r -e "s|.*z([0-9]+)\+.*|\1|g")
echo "SD_VERSION is $SD_VERSION"

L=$(find sql/sd2/updates/ -type d | sort -V | tail -n $(( $(find sql/sd2/updates/ -type d | wc -l) - 1 )))
echo -e "$L\nsql/sd2/updates/" | while read -d $'\n' d
do
  	find $d -name "*.sql" -maxdepth 1 -print0 | sort -z | while read -d $'\0' f
        do
          	VERSION=$(echo $(basename $f) | sed -r -e "s|[r]?([0-9]+).*|\1|g")
                version_gt "${VERSION}" "${SD_VERSION}"
                if [[ "$?" == "0" ]] ; then
                        if [[ "$f" =~ "mangos.sql" ]] ; then
                                add_db "$f" "${ID_WORLD}"
                        else
                            	add_db "$f" "${ID_SCRIPTDEV}"
                        fi
                fi
        done
done

if [[ $ENGINE == "cmangos" ]]; then
        add_db "sql/${ID_SCRIPTDEV}/${ID_SCRIPTDEV}.sql" "${ID_WORLD}"
fi

add_db "sql/sd2/optional/${ID_WORLD}_optional_generic_creature.sql" "${ID_WORLD}"

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
