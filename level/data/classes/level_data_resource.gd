@abstract
class_name LevelDataResource
extends Resource

var _mutex: Mutex
## Indicates that this resource wasn't properly read from the level code, and that something or the entire object was replaced with a default value.
var faulty_resource: bool = false

func _init(code_version: int, code: String) -> void:
	deserialize(code_version, code)

## For threading. Lock the object before reading and writing it's data.
func lock() -> void:
	if not is_instance_valid(_mutex):
		_mutex = Mutex.new()
	
	_mutex.lock()

## For threading. Try locking the object before reading and writing its data, if
## the thread should not be blocked.
func try_lock() -> bool:
	if not is_instance_valid(_mutex):
		_mutex = Mutex.new()
	
	return _mutex.try_lock()

## For threading. Unlock the object after reading and writing its data.
func unlock() -> void:
	if not is_instance_valid(_mutex):
		_mutex = Mutex.new()
	
	_mutex.unlock()

func mark_as_faulty(message: String) -> void:
	faulty_resource = true
	push_warning("A faulty level resource was made when decoding: " + message)

## Turn this object's internal data into a saveable string.
## Used for level codes, as well as clipboard data in the editor. 
@abstract func serialize() -> String

## Take the string from serialize() and load its data
## back into the class to be used during runtime.
@abstract func deserialize(code_version: int, data: String) -> void
