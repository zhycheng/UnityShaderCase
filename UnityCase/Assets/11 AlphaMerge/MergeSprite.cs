using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MergeSprite : MonoBehaviour
{
    public Texture2D rgb;
    public Texture2D alpha;
    public Material mat;
	Image img;

	// Start is called before the first frame update
	void Start()
    {
        img = this.GetComponent<Image>();
		//Func1();
		Func2();



	}
	private void Func2()
	{
		mat.SetTexture("_MainTex", rgb);
		mat.SetTexture("_AlphaTex", alpha);
		img.material = mat;

	}

    private void Func1()
    {
		Color Temp = new Color(0, 0, 0);
		Texture2D rgbTex = rgb;
		Texture2D alphaTex = alpha;
		Texture2D tex = new Texture2D(rgbTex.width, rgbTex.height, TextureFormat.ARGB32, false);
		for (int i = 0; i < tex.width; i++)
		{
			for (int j = 0; j < tex.height; j++)
			{
				Color rgbColor = rgbTex.GetPixel(i, j);
				Color alphaColor = alphaTex.GetPixel(i, j);
				Temp.r = rgbColor.r;
				Temp.g = rgbColor.g;
				Temp.b = rgbColor.b;
				Temp.a = alphaColor.r;
				tex.SetPixel(i, j, Temp);
			}
		}
		tex.Apply();
		Sprite s = Sprite.Create(tex, new Rect(0, 0, rgbTex.width, rgbTex.height), new Vector2(0, 0));
		img.overrideSprite = s;
	}

    // Update is called once per frame
    void Update()
    {
        
    }
}
