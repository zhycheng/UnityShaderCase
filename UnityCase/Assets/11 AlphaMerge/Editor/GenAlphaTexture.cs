//GenAlphaTexture.cs

using UnityEngine;
using UnityEditor;
using System.IO;

public class GenAlphaTexture
{
	[MenuItem("GameTools/GenAlphaTexture&JPG")]
	public static void StartGenAlphaTexture()
	{
		var textures = Selection.GetFiltered<Texture2D>(SelectionMode.DeepAssets);
		foreach (var t in textures)
		{
			var path = AssetDatabase.GetAssetPath(t);

			// 如果提示图片不可读，需要设置一下isReadable为true, 操作完记得再设置为false
			// var imp = AssetImporter.GetAtPath(path) as TextureImporter;
			// imp.isReadable = true;
			// AssetDatabase.ImportAsset(path);


			Texture2D newTexture = new Texture2D(t.width, t.height, TextureFormat.RGBA32, false);
			Texture2D newJpgTexture = new Texture2D(t.width, t.height, TextureFormat.RGBA32, false);
			
			for(int i=0;i<t.width;i++)
			{
				for(int j=0;j<t.height;j++)
				{
					Color c=t.GetPixel(i, j);
					newTexture.SetPixel(i, j, new Color(0,0,0,c.a));
					newJpgTexture.SetPixel(i, j, new Color(c.r,c.g,c.b,c.a));
				}
			}
			newTexture.Apply();
			newJpgTexture.Apply();

			string fname = path.Split('.')[0] + "_a.png";
			File.WriteAllBytes(fname, newTexture.EncodeToPNG());
			string fnamejpg = path.Split('.')[0] + "_png.png";
			File.WriteAllBytes(fnamejpg, newJpgTexture.EncodeToPNG());





			// imp.isReadable = false;
			// AssetDatabase.ImportAsset(path);
			AssetDatabase.Refresh();
		}
	}
}