extends EditorResourceConversionPlugin;
class_name NoiseTextureToPng;

var plugin: NoiseTextureSaverPlugin;

func _init(plugin: NoiseTextureSaverPlugin):
	self.plugin = plugin;

func _handles(resource: Resource):
	return resource is NoiseTexture2D;

func _converts_to():
	return "PNG (CompressedTexture2D)";

func _convert(resource: Resource):
	# Find paths
	var dir_path = ProjectSettings.get_setting(NoiseTextureSaverPlugin.SETTING_PATH, NoiseTextureSaverPlugin.DEFAULT_SAVE_PATH);
	var path = dir_path + "/NoiseTexture" + str(resource.get_rid().get_id()) + ".png";

	# Create folder if necessary
	var global_dir_path = ProjectSettings.globalize_path(dir_path);
	if !DirAccess.dir_exists_absolute(global_dir_path):
		var error = DirAccess.make_dir_recursive_absolute(global_dir_path);
		if error != 0:
			print("NoiseTextureSaver could not successfully create " + dir_path + ". Error code: " + str(error));
			return resource;

	if !(resource is NoiseTexture2D):
		return resource;

	# Save .png file
	var noise_texture = resource as NoiseTexture2D;
	noise_texture.get_image().save_png(path);
	
	# Try to force import the newly created .png into the editor.
	var filesystem = plugin\
		.get_editor_interface()\
		.get_resource_filesystem();
	filesystem.update_file(path);
	filesystem.reimport_files(PackedStringArray([path]));
	
	# Attempt to load the newly created .png.
	# This fails if the folder was just created since it hasn't been imported.
	var result = load(path);
	if result:
		return result;
	else:
		print_rich("[color=yellow]WARNING!\nThe NoiseTextureSaver addon could not load the generated texture. This is probably because the newly created `[color=white]" + dir_path + "[/color]` has not been imported by the Godot editor!! Wait a couple seconds to let Godot import the directory and try again!");
		return resource;
