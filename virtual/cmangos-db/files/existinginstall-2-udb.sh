PREFIX="$1"
USER="$2"
PASSWORD="$3"

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Full_DB/UDB_0.12.2_mangos_11792_SD2_2279.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Updates/403_corepatch_mangos_11793_to_11840.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Updates/403_updatepack_mangos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Updates/404_corepatch_mangos_11841_to_11928.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Updates/404_updatepack_mangos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Updates/405_corepatch_mangos_11929_to_12111.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Updates/405_updatepack_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_characters < Current_Release/Updates/406_corepatch_characters_12112_to_12444.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Updates/406_corepatch_mangos_12112_to_12444.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Updates/406_updatepack_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_characters < Current_Release/Updates/407_corepatch_characters_12445_to_12670.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Updates/407_corepatch_mangos_12445_to_12670.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Current_Release/Updates/407_updatepack_mangos.sql

#0.12.2 (408) pre-release beta
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/000_DB_Version.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/001_instance_swp.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/002_quest_12953.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/003_spell_script_targets.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/004_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/005_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/006_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/007_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/008_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/009_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/010_quest_10439.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/011_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/012_quest_9438.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/013_quest_4974.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/014_quest_4941.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/015_quest_6568.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/016_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/017_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/018_Druid_quests.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/019_wotlk_classlevelstats.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/020_quest_112_and_114.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/021_quest_2520.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/022_quest_6121.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/023_instance_aq40.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/024_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/025_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/026_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/027_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/028_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/029_quest_10208_10144.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/030_quest_10286.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/031_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/032_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/033_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/034_equipment.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/035_event.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/036_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/037_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/038_quest_9387.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/039_quest_6628.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/040_quest_10351.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/041_quest_10258.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/042_quest_990.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/043_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/044_quest_12027.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/045_quest_12022_and_12191.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/047_quest_8447.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/048_quest_9472_and_9483.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/049_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/050_quest_5541.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/051_NpcFlags.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/052_instance_cos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/053_gameobject_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/054_achievement_criteria.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/055_instance_swp.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/056_creature_template_spells.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/057_quest_12701.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/058_instance_cos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/059_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/060_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/061_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/062_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/063_quest_10861.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/064_instance_cos.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/065_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/066_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/067_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/068_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/069_instance_toc5.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/070_quest_12657.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/071_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"072_ClassicDB_Backport#2 part1.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"073_ClassicDB_Backport#2 part2.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/074_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/075_instance_toc5.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/076_creatures.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/077_quest_12711.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/078_quest_411_and_808.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/079_quest_12687.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"080_DKZone Part1.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"081_DKZone Part2.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"082_DKZone Part3.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"083_DKZone Part4.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/084_quest_12680.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"085_DKZone Part5.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"086_DKZone Part6.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/087_instance_dm_north.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/088_instance_brd.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/089_quest_6041.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/090_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/091_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/092_instance_ulduar.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/093_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/094_instance_rfd.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/096_import_corepatch_from_12748_to_12823.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/097_import_sd2_from_r3046_to_r3096.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/098_quest_12711.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/099_reward_Mail.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/100_instance_toc5.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/101_import_corepatch_12848.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/102_import_sd2_from_r3098_to_r3101.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/103_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/104_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/105_instance_toc5.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/106_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/107_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/108_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/109_quest_10909.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/110_questrelation.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/111_instance_toc25.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"112_DKZone Part7.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"113_DKZone Part8.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/114_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/115_quest_2240.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/116_quest_12716.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/117_quest_12723.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/118_quest_12725.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/119_quest_12727.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/120_instance_toc25.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/121_quest_7481_7482.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"122_ClassicDB_Backport#3 part1.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"123_ClassicDB_Backport#3 part2.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/124_quest_11128.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/125_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/126_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/127_quest_3382.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/128_quest_5151.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/129_import_sd2_from_r3103_to_r3116.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/130_instance_toc25.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/131_quest_12755.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/132_instance_toc25.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/133_quest_12757.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/134_import_corepatch_12864.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/135_quests_Riding.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/136_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/137_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/138_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/139_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/140_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/141_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/142_equipment.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/143_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/144_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/145_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/146_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/147_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/148_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/149_DBScript.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/150_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/151_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/152_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/153_gossip.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/154_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/155_gossip.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/156_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/157_NpcFlags.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/158_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/159_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/160_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/161_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/162_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/163_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/164_quest_10674_10859.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/165_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/166_quest_11174.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/167_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/168_import_sd2_from_r3122_to_r3126.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/169_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/170_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/171_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/172_gossip.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/173_quest_9437.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/174_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/175_gossip.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/176_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/177_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/178_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/179_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/180_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/181_item.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/182_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/183_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/184_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/185_instance_toc25.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/186_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/187_instance_hor.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/188_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/189_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/190_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/191_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/192_instance_sunken_temple.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"193_DKZone Part9.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/194_equipment.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/195_creature_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/196_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"197_DKZone Part10.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/198_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/199_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/200_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/201_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/202_quest_10488.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/203_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/204_quest_9805.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/205_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/206_gossip.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/207_gossip.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/208_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/209_gossip.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"210_DKZone Part11.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/211_gameobject.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"212_DKZone Part12.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/213_creature.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/214_gameobject_template.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/"215_DKZone Part13.sql"
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/216_DBScript.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/217_waypoints.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/218_quest_4265.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/219_quest_4129.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/220_quest_2943.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/221_quest_3463.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/222_quest_1059.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/223_gossip.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/224_quest_4321.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/225_gossip.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/226_gossip.sql
mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < Updates/227_quest_4901.sql
#sd2 version 3046-3126
#core 12748-12864

#core version 12848
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/updates/12864_01_mangos_spell_template.sql

#sd2 version 3126
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/r3130_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_scriptdev2 < sql/sd2/updates/r3130_scriptdev2.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/r3131_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/r3135_mangos.sql
#mysql --user="$USER" --password="$PASSWORD" ${PREFIX}_mangos < sql/sd2/updates/r3140_mangos.sql


