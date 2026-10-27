class_name LanguageHelper

# check if the first character is right to left (to decide whether to swap leading and trailing spaces)
static func is_first_char_rtl(text: String) -> bool:
	if text.is_empty():
		return false
	
	var code: int = text.unicode_at(0)
	
	return (
		(code >= 0x0590 and code <= 0x05FF) or # Hebrew
		(code >= 0x0600 and code <= 0x06FF) or # Arabic
		(code >= 0x0750 and code <= 0x077F) or # Arabic Supplement
		(code >= 0x0780 and code <= 0x07BF) or # Thaana
		(code >= 0x07C0 and code <= 0x07FF) or # N'Ko
		(code >= 0x08A0 and code <= 0x08FF) or # Arabic Extended-A
		(code >= 0xFB50 and code <= 0xFDFF) or # Arabic Presentation Forms-A
		(code >= 0xFE70 and code <= 0xFEFF)    # Arabic Presentation Forms-B
	)
