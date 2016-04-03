PREFIX="$1"
USER="$2"
PASSWORD="$3"

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

source make_full_WorldDB.sh

TF=`tempfile`
cat Character/Setup/characterCreateDB.sql | sed "s|characters|${PREFIX}_characters|g" > $TF
mysql --user="$USER" --password="$PASSWORD" < $TF
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_characters < Character/Setup/characterLoadDB.sql
cat Realm/Setup/realmdCreateDB.sql | sed "s|realmd|${PREFIX}_realmd|g" > $TF
mysql --user="$USER" --password="$PASSWORD" < $TF
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_realmd < Realm/Setup/realmdLoadDB.sql
cat World/Setup/mangosdCreateDB.sql | sed -e "s|characters|${PREFIX}_characters|g" -e "s|realmd|${PREFIX}_realmd|g" -e "s|\`mangos\`|\`${PREFIX}_mangos\`|g" > $TF
mysql --user="$USER" --password="$PASSWORD" < $TF
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Setup/mangosdLoadDB.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < full_db.sql
unset PASSWORD
