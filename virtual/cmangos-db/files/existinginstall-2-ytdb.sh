PREFIX="$1"
USER="$2"
PASSWORD="$3"

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

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
