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

mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Full_DB/TBCDB_1.4.0_cmangos-tbc_s1982_SD2-TBC_s2720.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Updates/1.4.1_corepatch_mangos_s1960_to_s2034.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Updates/1.4.1_updatepack.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_characters < Current_Release/Updates/1.4.2_corepatch_characters_s2035_to_s2120.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Updates/1.4.2_corepatch_mangos_s2035_to_s2120.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Updates/1.4.2_updatepack.sql

mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/updates/s2128_12654_01_mangos_creature_template_power.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/updates/s2138_12670_01_mangos_spell_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/updates/s2170_12757_01_mangos_spell_chain.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/updates/s2171_12759_01_mangos_spell_chain.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/updates/s2201_12748_01_mangos_spell_template.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_characters < sql/updates/s2204_12756_01_characters_pvpstats.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/updates/s2254_12816_01_mangos_command.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/updates/s2254_12816_02_mangos_mangos_string.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/updates/s2261_12821_01_mangos_command.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/updates/s2263_12823_01_mangos_command.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/updates/s2263_12823_02_mangos_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/updates/s2263_12823_03_mangos_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/updates/s2263_12823_04_mangos_creature.sql

#1.4.3 prerelease beta
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/000_DB_Version.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/001_NPC_Waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/002_NPC_Waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/003_TBC_ClassLevelStats.sql

#sd version 2720
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2723_mangos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2728_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2728_scriptdev2.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2730_scriptdev2.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2732_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2734_mangos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2736_mangos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2737_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2737_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2739_mangos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2740_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2740_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2741_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2741_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2742_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2742_scriptdev2.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2744_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2745_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2747_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2748_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2748_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2750_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2750_scriptdev2.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2753_scriptdev2.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2755_scriptdev2.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2756_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2757_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2757_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2758_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.7/r2758_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2759_mangos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2760_mangos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.7/r2762_mangos.sql

mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2766_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2766_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2768_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2771_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2772_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2772_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2774_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2774_scriptdev2.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2776_scriptdev2.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2777_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2778_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2778_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2779_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2779_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2780_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2780_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2781_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2781_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2782_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2782_scriptdev2.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2784_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2786_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2786_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2788_mangos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2789_mangos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2790_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2790_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2791_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2792_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2793_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2793_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2794_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2794_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2804_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2806_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2807_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2807_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2808_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2808_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/0.8/r2811_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/0.8/r2811_scriptdev2.sql

mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/r2815_mangos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/r2816_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/r2817_scriptdev2.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/r2819_scriptdev2.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/r2827_scriptdev2.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/r2830_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/r2831_scriptdev2.sql
unset PASSWORD
