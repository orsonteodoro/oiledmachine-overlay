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
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/mangos_scriptname_full.sql

cd Development/database
cat <<EOF > full_db.sql
for i in *.sql; do tail -n +18 $i >> full_db.sql; done

mysql --user="${USERNAME}" --password="${REPLY}" ${PREFIX}_mangos < full_db.sql


unset PASSWORD
unset REPLY
