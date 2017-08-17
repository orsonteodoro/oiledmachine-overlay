PREFIX="$1"
USER="$2"
PASSWORD="$3"
ENGINE="$4" #can be mangos cmangos
MODE="$5" #can be new safe_update unsafe_update

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
ID_SCRIPTDEV="scriptdev${ID_SCRIPTDEV_VERSION}"

VERSIONING_SCHEME="" #can be 3column, 5digit, 4digit
get_mangos_version() {
	local FOUND="0"

	mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_WORLD} -e "SHOW COLUMNS FROM db_version" | grep -P "required_[rcz]?[0-9]+_[0-9]+"
	if [[ "$?" == "0" ]] ; then
		#required_20000_11_Creature_Template_repair scheme
		MANGOS_VERSION=$(mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_WORLD} -e "SHOW COLUMNS FROM db_version" | grep "required_" | sed -r -e "s|required_[rcz]?([0-9]+)_([0-9]+).*|\1.\2|g")
		FOUND="1"
	fi

	mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_WORLD} -e "SHOW COLUMNS FROM db_version" | grep -P "required_[rcz]?[0-9]+_"
	if [[ "$?" == "0" ]] ; then
		#z1040_s0418_02_mangos_creature_addon.sql
		MANGOS_VERSION=$(mysql -N -B --user="$USER" --password="$PASSWORD" ${PREFIX}_${ID_WORLD} -e "SHOW COLUMNS FROM db_version" | grep "required_" | sed -r -e "s|required_[rcz]?([0-9]+)_.*|9\1|g")
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
	find Full_DB -name "*.sql" -print0 | while read -d $'\0' f
	do
		add_db "$f" "${ID_WORLD}"
	done
fi

#apply old updates
get_mangos_version
get_characters_version
get_realmd_version
find sql/archive -type d | tail -n $(($(find sql/archive -type d | wc -l) - 1)) | sort -V | while read -d $'\n' d
do
	find $d -name "*.sql" -print0 | sort -z | while read -d $'\0' f
	do
		FOUND="0"

		echo $(basename "$f") | grep -P "^[zr][0-9]+_" > /dev/null
		if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
			debug_msg "variant 1"
			FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|^[zr]([0-9]+).*|9\1|g") #z1040_s0418_02_mangos_creature_addon.sql
			FOUND="1"
		fi

		echo $(basename "$f") | grep -P "^[0-9][0-9][0-9]_xxxx_[0-9]+_" > /dev/null
		if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
			debug_msg "variant 3"
			FILE_VERSION="9999" #062_xxxx_01_mangos_spell_learn_spell.sql #automerge
			FOUND="1"
		fi

		echo $(basename "$f") | grep -P "^[0-9][0-9][0-9]_[0-9]+_[0-9]+_" > /dev/null
		if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
			debug_msg "variant 4"
			FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|^[0-9][0-9][0-9]_([0-9]+).*|\1|g" -e "s|_|.|g") #001_6939_01_mangos_quest_template.sql
			FOUND="1"
		fi

		echo $(basename "$f") | grep -P "^2008_[0-9]+_[0-9]+_[0-9]_" > /dev/null
		if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
			debug_msg "variant 5"
			#FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|^2008_([0-9]+_[0-9]+_[0-9]).*|\1|g" -e "s|_|.|g") #2008_11_09_01_mangos_command.sql
			FILE_VERSION="6761"
			FOUND="1"
		fi

		echo $(basename "$f") | grep -P "^0[0-9]+_" > /dev/null
		if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
			debug_msg "variant 6"
			FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|^0([0-9]+).*|\1|g") #06360_characters_characters.sql
			FOUND="1"
		fi

		echo $(basename "$f") | grep -P "^[0-9]+_" > /dev/null
		if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
			debug_msg "variant 7"
			FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|^([0-9]+).*|\1|g")
			FOUND="1"
		fi

		ASSUME_MANGOS="0"
		echo $(basename "$f") | grep -P "^[0-9]+.sql" > /dev/null
		if [[ "$FOUND" == "0" && "$?" == "0" ]] ; then
			debug_msg "variant 8"
			FILE_VERSION=$(echo $(basename "$f") | sed -r -e "s|^([0-9]+).*|\1|g")
			FOUND="1"
			ASSUME_MANGOS="1"
		fi

		if [[ "$FOUND" == "0" ]] ; then
			echo "unhandled case: $f"
		fi

		DOTS_LEFT=$(echo "${FILE_VERSION}" | awk -F "." '{ print NF-1 }')

		debug_msg "current: $f"
		echo $(basename "$f") | grep -P "_${ID_WORLD}"
		if [[ "$?" == "0" || ASSUME_MANGOS == "1" ]] ; then
			DOTS_RIGHT=$(echo "${MANGOS_VERSION}" | awk -F "." '{ print NF-1 }')

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
		fi

		echo $(basename "$f") | grep -P "_${ID_CHARACTERS}"
		if [[ "$?" == "0" ]] ; then
			DOTS_RIGHT=$(echo "${CHARACTERS_VERSION}" | awk -F "." '{ print NF-1 }')

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
		fi

		echo $(basename "$f") | grep -P "_${ID_AUTH}"
		if [[ "$?" == "0" ]] ; then
			DOTS_RIGHT=$(echo "${REALMD_VERSION}" | awk -F "." '{ print NF-1 }')

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
		fi
	done
done

find updates -name "*.sql" -print0 | sort -z | while read -d $'\0' f
do
	add_db "$f" "${ID_WORLD}"
done

f="sql/sd${ID_SCRIPTDEV_VERSION}/${ID_SCRIPTDEV}_create_database.sql"
cat "$f" | sed -e "s|${ID_SCRIPTDEV}|${PREFIX}_${ID_SCRIPTDEV}|g" > $TF
mysql --user="$USER" --password="$PASSWORD" < $TF
check_success
add_db "sql/sd${ID_SCRIPTDEV_VERSION}/${ID_SCRIPTDEV}_create_structure_mysql.sql" "${ID_SCRIPTDEV}"
add_db "sql/sd${ID_SCRIPTDEV_VERSION}/${ID_SCRIPTDEV}_script_full.sql" "${ID_SCRIPTDEV}"
add_db "sql/sd${ID_SCRIPTDEV_VERSION}/${ID_WORLD}_scriptname_full.sql" "${ID_WORLD}"

SD_VERSION=$(grep -r -e "sd${ID_SCRIPTDEV_VERSION}_db_version" sql/sd${ID_SCRIPTDEV_VERSION}/${ID_SCRIPTDEV}_script_full.sql | tail -n 1 | sed -r -e "s|.*z([0-9]+)\+.*|\1|g")
echo "SD_VERSION is $SD_VERSION"

L=$(find sql/sd${ID_SCRIPTDEV_VERSION}/updates/ -type d | sort -V | tail -n $(( $(find sql/sd${ID_SCRIPTDEV_VERSION}/updates/ -type d | wc -l) - 1 )))
echo -e "$L\nsql/sd${ID_SCRIPTDEV_VERSION}/updates/" | while read -d $'\n' d
do
	find $d -name "*.sql" -maxdepth 1 -print0 | sort -z | while read -d $'\0' f
	do
		VERSION=$(echo $(basename $f) | sed -r -e "s|[r]?([0-9]+).*|\1|g")
		version_gt "${VERSION}" "${SD_VERSION}"
		if [[ "$?" == "0" ]] ; then
			if [[ "$f" =~ "${ID_WORLD}.sql" ]] ; then
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

add_db "sql/sd${ID_SCRIPTDEV_VERSION}/optional/${ID_WORLD}_optional_generic_creature.sql" "${ID_WORLD}"

if [ -f "/usr/share/acid/0/acid_classic.sql" ]; then
	add_db "/usr/share/acid/0/acid_classic.sql" "${ID_WORLD}"
fi

unset PASSWORD

