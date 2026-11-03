class_name TranslationData
extends LevelDataResource

## This is to be stored near the beginning of a level code,
## and kept in memory throughout gameplay. Whenever an object
## fetches a string from its properties, and the property is in
## translatable_properties, the object will fetch the actual
## display string from here.

## The one included with the level code is the base language.
## Users should be able to provide their own translations as files,
## which are also kept in memory during gameplay.

## The order in which an object picks TranslationData should go as follows:
## User's language -> English -> Original language (if not English)

var translations: Dictionary[int, String] 
var language: String

## IDs are integers, starting from 0.
## Every time a new translation is added, it's incremented by 1.
## However, unused IDs will not be filled, to prevent unwanted translation
## strings from being used in the wrong places when a level is edited. 
## Instead, the dictionary will just skip over that ID.
var latest_id: int = 0

## Returns the ID that this text will stored at so that it can be fetched later.
func add_translation(text: String) -> int:
	var cur_id: int = latest_id
	translations[cur_id] = text
	latest_id += 1
	return latest_id

func get_translation(id: int) -> String:
	return translations.get(id, "Error fetching translation... (Please report!)")

## Automatically set to whatever language the user has set. 
## Should be overridable manually though...
func load_default_lang() -> void:
	language = LocalSettings.load_setting("General", "Language", "en")

### Serialization
## TODO: Write this
func serialize() -> String:
	return ""

func deserialize(_code_version: int, _code: String) -> void:
	pass
