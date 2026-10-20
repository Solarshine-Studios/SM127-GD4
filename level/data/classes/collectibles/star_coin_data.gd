class_name StarCoinData
extends LevelDataResource

const DEFAULT_HINT: String = "This Star Coin doesn't have a hint."
const DEFAULT_COLOR: Color = Color.YELLOW

var star_coin_uuid: String
var star_coin_hint: String
var star_coin_color: Color


func _init(
		set_star_coin_uuid: String = "",
		set_star_coin_hint: String = DEFAULT_HINT,
		set_star_coin_color: Color = DEFAULT_COLOR
	) -> void:
	star_coin_uuid = set_star_coin_uuid if not set_star_coin_uuid.is_empty() else UUIDHelper.v4()
	star_coin_hint = set_star_coin_hint
	star_coin_color = set_star_coin_color
