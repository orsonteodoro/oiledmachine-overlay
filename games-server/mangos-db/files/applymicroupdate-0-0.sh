PREFIX="$1"
USER="$2"
PASSWORD="$3"

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20007_19_Start_Up_Error_fixes.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20007_20_Hotfix_Corrections_to_RegenerateStats.sql
unset PASSWORD
