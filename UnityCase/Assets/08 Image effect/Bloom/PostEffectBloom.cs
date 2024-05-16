using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class PostEffectBloom: MonoBehaviour
{
    [Range(1,8)]
    public int downSample = 1;

	[Range(1,8)]
	public int iteration = 1;



    public Material material;    
    // Start is called before the first frame update
    void Start()
    {
        if(material == null)
        {
            enabled = false;
        }
    }

	private void OnRenderImag1(RenderTexture source, RenderTexture destination)
	{
		if (material != null)
		{
			int trW = source.width;
			int trH = source.height;
			RenderTexture buffer0 = RenderTexture.GetTemporary(trW, trH, 0);
			Graphics.Blit(source, buffer0, material, 0);
			Graphics.Blit(buffer0, destination, material, 1);
			RenderTexture.ReleaseTemporary(buffer0);
		}
		else
		{
			//Graphics.Blit(source, destination);
		}
	}

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (material != null)
		{


			int trW = source.width;
			int trH = source.height;
			RenderTexture buffer0 = RenderTexture.GetTemporary(trW, trH, 0);
			buffer0.filterMode = FilterMode.Bilinear;
			RenderTexture buffer1 = RenderTexture.GetTemporary(trW, trH, 0);
			buffer1.filterMode = FilterMode.Bilinear;
			Graphics.Blit(source, buffer1, material,0);


			
			for (int i=0;i< iteration;i++)
			{
				Graphics.Blit(buffer1, buffer0, material, 1);
				Graphics.Blit(buffer0, buffer1, material, 2);
			}
			material.SetTexture("_BloomTex", buffer1);
			Graphics.Blit(source, destination, material,3);

			//Graphics.Blit(buffer1, destination);


			RenderTexture.ReleaseTemporary(buffer0);
			RenderTexture.ReleaseTemporary(buffer1);
		}
		else
		{
			//Graphics.Blit(source, destination);
		}
	}




	//第二个版本
	private void OnRenderImage2(RenderTexture source, RenderTexture destination)
	{
        if(material!=null)
        {


            int trW= source.width/downSample;
            int trH= source.height / downSample;
            RenderTexture buffer0 = RenderTexture.GetTemporary(trW, trH, 0);
			RenderTexture buffer1 = RenderTexture.GetTemporary(trW* downSample, trH* downSample, 0);
			RenderTexture buffer2 = RenderTexture.GetTemporary(trW, trH, 0);
			buffer0.filterMode = FilterMode.Bilinear;
            buffer1.filterMode = FilterMode.Bilinear;
			buffer2.filterMode = FilterMode.Bilinear;

			Graphics.Blit(source, buffer0);
			Graphics.Blit(buffer0, buffer1, material,0);
			Graphics.Blit(buffer1, buffer2);
			Graphics.Blit(buffer2, destination,material,1);

			RenderTexture.ReleaseTemporary(buffer0);
			RenderTexture.ReleaseTemporary(buffer1);
            RenderTexture.ReleaseTemporary(buffer2);

		}
        else
        {
            //Graphics.Blit(source, destination);
        }
	}


	// Update is called once per frame
	void Update()
    {
        
    }
}
