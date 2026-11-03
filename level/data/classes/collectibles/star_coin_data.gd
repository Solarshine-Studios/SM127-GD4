class_name StarCoinData
extends LevelDataResource

const DEFAULT_HINT: String = "This Star Coin doesn't have a hint."
const DEFAULT_COLOR: Color = Color.YELLOW

var star_coin_uuid: String
var star_coin_hint: String
var star_coin_color: Color

### Serialization
## TODO: Write this
func serialize() -> String:
	return ""

func deserialize(_code: String) -> void:
	pass
