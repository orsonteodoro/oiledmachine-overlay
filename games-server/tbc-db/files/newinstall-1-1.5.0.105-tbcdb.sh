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

mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Full_DB/TBCDB_1.5.0_cmangos-tbc.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/000_DB_Version.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/001_Totem_Models.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/003_Brewfest_Improvements.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/004_Spell_Script_Targets(Target 60).sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/005_Sunwell_Plateau.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/006_Falcon Watch_NPC_Movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/007_Hallows_End_Improvements.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/008_Misc_DB_Fixes.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/009_General_Spawn_Cleanups.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/010_Shadowmoon_Nethercite Spawn_Pool.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/011_UDB-005_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/012_UDB-008_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/013_UDB-010_quest_10439.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/014_UDB-011_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/015_UDB-012_quest_9438.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/016_UDB-013_quest_4974.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/017_UDB-014_quest_4941.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/018_UDB-015_quest_6568.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/019_UDB-016_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/020_UDB-017_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/021_UDB-018_Druid_quests.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/022_UDB-021_quest_2520.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/023_UDB-022_quest_6121.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/024_UDB-023_instance_aq40.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/025_Quest-112_and_114_Scripts.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/026_Complete_Herb_Spawn_Pools.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/027_UDB-024_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/028_UDB-025_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/029_UDB-026_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/030_UDB-027_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/031_UDB-028_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/032_ClassicDB-0741_pool_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/033_ClassicDB-0742_quest_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/034_ClassicDB-0748_dbscripts_on_go_template_use.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/034_ClassicDB-0748_dbscripts_on_go_use.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/034_ClassicDB-0748_gameobject_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/035_UDB-029_quest_10208_10144.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/036_UDB-030_quest_10286.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/037_quest_667.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/038_creature_template_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/039_NPC_Spawn_Cleanups.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/040_NPC_Loot_Fixes.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/041_UDB-031_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/042_UDB-032_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/043_UDB-037_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/044_UDB-038_quest_9387.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/045_UDB-040_quest_10351.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/046_UDB-041_quest_10258.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/047_UDB-042_quest_990.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/048_UDB-043_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/049_ClassicDB-0755_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/050_ClassicDB-0756_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/051_ClassicDB-0757_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/051_ClassicDB-0757_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/051_ClassicDB-0757_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/052_ClassicDB-0763_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/054_ClassicDB-0766_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/055_ClassicDB-0767_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/056_ClassicDB-0768_quest_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/057_ClassicDB-0769_creature_equip_template_raw.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/058_ClassicDB-0771_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/059_ClassicDB-0772_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/060_ClassicDB-0773_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/061_ClassicDB-0775_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/062_ClassicDB-0776_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/063_ClassicDB-0777_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/064_ClassicDB-0778_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/065_ClassicDB-0779_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/066_ClassicDB-0780_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/067_ClassicDB-0781_dbscripts_on_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/069_Cat_Figurine_Fixes.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/070_Quest-9756.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/071_ClassicDB-0784_dbscripts_on_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/072_ClassicDB-0785_1_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/072_ClassicDB-0785_2_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/072_ClassicDB-0785_3_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/073_ClassicDB-0786_quest_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/074_UDB-045_quest_12022_and_12191.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/075_UDB-047_quest_8447.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/076_UDB-048_quest_9472_and_9483.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/077_UDB-049_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/078_UDB-050_quest_5541.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/079_UDB-051_NpcFlags.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/080_UDB-055_instance_swp.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/081_UDB-056_creature_template_spells.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/082_Console_Fixes.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/083_Mineral_Spawn_Time_Fixes.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/084_Mineral_Herb_Max_Spawn_Tweaks.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/085_NPC_Loot_Droprate_Initial_Fixes.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/086_UDB-062_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/087_UDB-063_quest_10861.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/088_ClassicDB-0787_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/089_ClassicDB-0788_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/090_ClassicDB-0789_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/091_ClassicDB-0790_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/092_ClassicDB-0791_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/093_ClassicDB-0793_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/094_ClassicDB-0795_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/095_ClassicDB-0796_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/096_ClassicDB-0797_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/097_ClassicDB-0798_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/098_ClassicDB-0799_1_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/099_ClassicDB-0799_2_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/100_ClassicDB-0800_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/101_ClassicDB-0801_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/102_ClassicDB-0802_creature_movement_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/103_ClassicDB-0803_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/104_ClassicDB-0804_creature_movement.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/105_ClassicDB-0805_creature_movement.sql

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
