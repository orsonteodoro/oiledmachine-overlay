PREFIX="$1"
USER="$2"
PASSWORD="$3"

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel18/18000_01_scripted_event_id.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel19/19001_01_Cluck_Quest_Fix.sql
unset PASSWORD
