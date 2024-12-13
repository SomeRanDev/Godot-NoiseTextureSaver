@tool
extends EditorPlugin;
class_name NoiseTextureSaverPlugin;

const SETTING_PATH = "addons/noise_texture_saver/default_output_folder";
const DEFAULT_SAVE_PATH = "res://saved_noise_textures";

var to_portable = null;
var to_png = null;

func _enter_tree() -> void:
	if !ProjectSettings.has_setting(SETTING_PATH):
		ProjectSettings.set_setting(SETTING_PATH, DEFAULT_SAVE_PATH);
		ProjectSettings.set_initial_value(SETTING_PATH, DEFAULT_SAVE_PATH);

	to_portable = NoiseTextureToPortable.new();
	add_resource_conversion_plugin(to_portable);

	to_png = NoiseTextureToPng.new(self);
	add_resource_conversion_plugin(to_png);

func _exit_tree() -> void:
	if to_portable:
		remove_resource_conversion_plugin(to_portable);
		to_portable = null;

	if to_png:
		remove_resource_conversion_plugin(to_png);
		to_png = null;
