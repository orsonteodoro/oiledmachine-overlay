PREFIX="$1"
USER="$2"
PASSWORD="$3"

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

TF=`tempfile`
cat sql/create_mysql.sql | sed -e "s|characters|${PREFIX}_characters|g" -e "s|realmd|${PREFIX}_realmd|g" -e "s|\`mangos\`|\`${PREFIX}_mangos\`|g" > $TF
mysql --user="$USER" --password="$PASSWORD" < $TF
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_characters < sql/characters.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_realmd < sql/realmd.sql

cat sql/sd2/scriptdev2_create_database.sql | sed -e "s|scriptdev2|${PREFIX}_scriptdev2|g" > $TF
mysql --user="$USER" --password="$PASSWORD" < $TF
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/scriptdev2_create_structure_mysql.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/scriptdev2_script_full.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/mangos_scriptname_full.sql

mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < YTDB_0.14.8_R650_cMaNGOS_R12867_SD2_R3121_ACID_R320_RuDB_R65.sql

#sd2 version 3121 installed
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/r3122_mangos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/r3125_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/r3125_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/r3126_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/r3126_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/r3130_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/r3130_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/r3131_mangos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/r3135_mangos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/r3140_mangos.sql

