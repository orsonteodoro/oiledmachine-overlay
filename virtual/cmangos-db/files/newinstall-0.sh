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

mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Full_DB/ClassicDB_1_5_z2656.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1002_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1003_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1004_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1005_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1006_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1006_gameobject_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1007_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1007_gameobject_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1008_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1008_gameobject_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1010_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1010_gameobject_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1011_gameobject_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1012_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1012_gameobject_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1013_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1014_creature_equip_template_raw.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1015_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1016_quest_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1017_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1018_quest_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1019_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1020_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1021_quest_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1022_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1023_UDB_updates.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1024_felwood_update.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1025_creature_model_info.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1026_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1027_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1028_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1029_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1030_quest_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1031_game_event_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1032_fixes.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1033_1_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1033_2_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1034_1_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1034_2_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1034_3_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1035_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1036_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1037_dbscripts_on_quest_end.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1038_1_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1038_2_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1038_3_creature_linking.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1039_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1040_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1041_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1042_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1043_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1044_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1045_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1046_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1047_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1048_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1049_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1050_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1051_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1052_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1053_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < updates/1054_creature.sql

#sd2 version 2734

