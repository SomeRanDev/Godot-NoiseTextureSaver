extends EditorResourceConversionPlugin;
class_name NoiseTextureToPortable;

func _handles(resource: Resource):
	return resource is NoiseTexture2D;

func _converts_to():
	return "PortableCompressedTexture2D";

func _convert(itex: Resource):
	var ctex = PortableCompressedTexture2D.new();
	ctex.create_from_image(itex.get_image(), PortableCompressedTexture2D.COMPRESSION_MODE_LOSSLESS);
	return ctex;
