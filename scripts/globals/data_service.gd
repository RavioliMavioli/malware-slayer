extends Node

const USER_PATH: String = "user://data/"
const FORMAT: String = "cfg"
const DEFAULT_PATH :String = "res://default_data/"

var default_data := {}
var file_data := {}
var pending_file_changes := {}

## save changes to disk at the end of current update frame
var auto_apply_changes := true

signal data_changed(file_path: String, section :String, key :String)

func get_wrapper(file_path: String, section: String = "common") -> SectionWrapper:
	var wrapper := SectionWrapper.new()
	wrapper.file_path = file_path
	wrapper.section = section
	return wrapper

func set_data(file_path: String, section: String, key: String, value: Variant):
	var config := _get_config(file_path)
	if config.has_section_key(section, key) and config.get_value(section, key) == value:
		return
	config.set_value(section, key, value)
	data_changed.emit(file_path, section, key)
	pending_file_changes[file_path] = true
	if auto_apply_changes and not get_tree().process_frame.is_connected(save_pending):
		get_tree().process_frame.connect(save_pending, CONNECT_ONE_SHOT)

func has_data(file_path: String, section: String, key :String) -> bool:
	if default_data.has(file_path):
		if default_data[file_path].has_section_key(section, key):
			return true
	var config := _get_config(file_path)
	return config.has_section_key(section, key)

func get_data(file_path: String, section: String, key :String, default :Variant = null) -> Variant:
	var config := _get_config(file_path)
	if not config.has_section_key(section, key) and default_data.has(file_path):
		var defaultConfig :ConfigFile = default_data[file_path]
		return defaultConfig.get_value(section, key, default)
	return config.get_value(section, key, default)

# there's no reason to use this, but it's good to have it for completeness
func save_all_data() -> void:
	for file_path in file_data:
		_save_file(file_path)
	pending_file_changes.clear()

func save_pending():
	for file_path in pending_file_changes:
		_save_file(file_path)
	pending_file_changes.clear()

func cancel_pending():
	for file_path in pending_file_changes:
		_load_file(file_path)
	pending_file_changes.clear()

func _get_config(file_path: String) -> ConfigFile:
	if not file_data.has(file_path):
		_load_file(file_path)
	return file_data[file_path]

func _save_file(file_path:String):
	if not file_data.has(file_path):
		push_error("Data file does not exist: %s"%file_path)
		return
	var config := _get_config(file_path)
	var full_path := USER_PATH + file_path + "."+FORMAT
	DirAccess.make_dir_recursive_absolute(full_path.get_base_dir())
	var res := config.save(full_path)
	assert(res == OK, "Error saving data: %s path: %s"%[res, full_path])

func _load_file(file_path: String):
	var config := ConfigFile.new()
	config.load(USER_PATH + file_path + "."+FORMAT)
	file_data[file_path] = config
	
	_load_default_file(file_path)
	
	return config


# normal config file load function
# you would want to switch to this if you change format of default files to cfg
# that would require a change in export settings
# which is a problem because 'export_presets.cfg' is in .gitignore
# meaning anyone cloning the repo would not be able to properly export
#func _load_default_file(file_path :String) -> ConfigFile:
	#var config := ConfigFile.new()
	#config.load(DEFAULT_PATH + file_path + "."+FORMAT)
	#default_data[file_path] = config
func _load_default_file(file_path :String):
	var default_path := DEFAULT_PATH + file_path + ".gd"
	if not ResourceLoader.exists(default_path):
		return
	var script := load(default_path) as Script
	var defaultConfig := ConfigFile.new()
	var err := defaultConfig.parse(script.data)
	assert(err == OK, "Error %s parsing default data file: %s"%[err, default_path])
	default_data[file_path] = defaultConfig


class SectionWrapper:
	var file_path:String
	var section:String
	func set_data(key: String, value: Variant):
		DataService.set_data(file_path, section, key, value)
	func get_data(key: String, default: Variant = null) -> Variant:
		return DataService.get_data(file_path, section, key, default)
	func has_data(key: String) -> bool:
		return DataService.has_data(file_path, section, key)
	func get_keys() -> PackedStringArray:
		return DataService.get_config(file_path).get_section_keys(section)
