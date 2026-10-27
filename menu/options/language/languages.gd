extends VBoxContainer


const LANGUAGE_BUTTON: PackedScene = preload("res://menu/options/language/language_button.tscn")
const FLAG_PATH: String = "res://global/assets/icons/locales/%s.svg"


func _ready() -> void:
	for locale: String in TranslationServer.get_loaded_locales():
		var translation: Translation = TranslationServer.get_translation_object(locale)
		var lang_button: ButtonSound = LANGUAGE_BUTTON.instantiate()
		lang_button.text = translation.get_message("LANG")
		lang_button.initial_text = lang_button.text
		lang_button.theme_type_variation = ""
		
		var flag_icon: TextureRect = lang_button.get_node("Flag")
		flag_icon.texture = load(FLAG_PATH % translation.get_message("FLAG"))
		
		lang_button.name = locale
		lang_button.pressed.connect(select_locale.bind(locale))
		add_child.call_deferred(lang_button)
	
	var default_lang: String = "en"
	if OS.get_locale_language() in TranslationServer.get_loaded_locales():
		default_lang = OS.get_locale_language()
	
	select_locale.call_deferred(LocalSettings.load_setting("General", "language", default_lang))


func select_locale(locale: String) -> void:
	LocalSettings.change_setting("General", "language", locale)
	TranslationServer.set_locale(locale)
	
	for button: Button in get_children():
		var is_correct_locale: bool = (button.name == locale)
		button.theme_type_variation = "ButtonSpecial" if is_correct_locale else ""
