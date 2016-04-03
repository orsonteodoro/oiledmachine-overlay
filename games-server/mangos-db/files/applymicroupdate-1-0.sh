PREFIX="$1"
USER="$2"
PASSWORD="$3"

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_34_BGAV_Snowfall_grave_issue_fix.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_35_BGAV_Creature_Template_Classlevelstats_Fixes.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_36_BGAV_Icewing_Marshal_Faction_Fix.sql
unset PASSWORD
