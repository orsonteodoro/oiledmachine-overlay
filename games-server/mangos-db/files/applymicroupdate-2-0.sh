PREFIX="$1"
USER="$2"
PASSWORD="$3"

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_12_custom_texts.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_13_missing_creatures.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_14_missing_spell_scripts.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_15_missing_gossips.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_16_npc_trainer_fixes.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_17_missing_gameobject_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_18_Start_Up_Fixes.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_19_Synching_of_EventAI_Action_Types.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_20_Quest_Hunting_for_Ectoplasm_fix.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_21_Tutenkash_Gong_fix.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_22_Deadmines_Mr_Smite_Corrections.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_23_Blades_Edge_Ogre_Brew.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_24_Quest_Hypercapacitor_Gizmo.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_25_Tortured_skeleton_issue_fix.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_26_Fel_Stalker_issue_fix.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_27_Terl_Arakor_Wetlands_gossip_text.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < World/Updates/Rel20/20000_28_db_script_string_correction.sql
unset PASSWORD
