class_name CollectibleData
extends LevelDataResource


# Array of MissionData
var mission_data: Array[MissionData] = []
# Array of StarCoinData
var star_coin_data: Array[StarCoinData] = []
# This is the total_shine_count
var used_mission_data: Dictionary = {}
# Whether mission progression is linear or open
var linear_progression: bool = false
# A list of nozzles that can be saved between playthroughs
var persistent_nozzles: Array[String] = [
	"HoverNozzle",
	"RocketNozzle",
    "TurboNozzle"
]

var red_coin_count: int = 0

# This is the easiest way to bridge the
# gap between the shines' mission tab and
# the level settings mission tab.
signal data_changed(data: CollectibleData)


func _init(
	set_mission_data: Array[MissionData] = [], 
	set_star_coin_data: Array[StarCoinData] = [], 
	set_red_coin_count: int = 0, 
	set_used_mission_data: Dictionary = {}, 
	set_linear_progression: bool = false,
	set_persistent_nozzles: Array[String] = persistent_nozzles
) -> void:
	mission_data = set_mission_data
	star_coin_data = set_star_coin_data
	red_coin_count = set_red_coin_count
	used_mission_data = set_used_mission_data
	linear_progression = set_linear_progression
	persistent_nozzles = set_persistent_nozzles


func get_shine_count() -> int:
	return used_mission_data.size()

func get_menu_shine_count() -> int:
	var count: int = 0
	for mission: String in used_mission_data:
		if get_mission_by_uuid(mission).mission_show_in_menu: count += 1
		
	return count

func get_star_coin_count() -> int:
	return star_coin_data.size()

func get_mission_by_uuid(uuid: String) -> MissionData:
	for mission: MissionData in mission_data:
		if mission.mission_uuid == uuid:
			return mission
	return null

func get_new_mission_sort() -> int:
	if mission_data.is_empty(): return 0
	var sorted_mission_data: Array[MissionData] = mission_data.duplicate()
	sorted_mission_data.sort_custom(MissionData.sort_by_order)
	return sorted_mission_data.back().shine_sort_order + 1

func add_star_coin(uuid: String = "") -> StarCoinData:
	var data: StarCoinData = StarCoinData.new(UUIDHelper.v4() if not uuid else uuid)

	star_coin_data.append(data)
	return data

func get_star_coin_by_uuid(uuid: String) -> StarCoinData:
	for star_coin: StarCoinData in star_coin_data:
		if star_coin.star_coin_uuid == uuid:
			return star_coin
	return null
