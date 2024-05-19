using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PaintTest : MonoBehaviour
{
    // Start is called before the first frame update
    public GameObject renderObject;
    Material mat;
    Texture2D paintTexture;
    public Color clearColor=new Color(0,0,0,0);
    public Color paintColor=Color.red;
    public int R = 5;
    bool isPainting=false;
    void Start()
    {
		SkinnedMeshRenderer meshRenderer = renderObject.GetComponent<SkinnedMeshRenderer>();
		mat = meshRenderer.materials[1];
        paintTexture = new Texture2D(1024, 1024, TextureFormat.ARGB32, false);
		mat.mainTexture = paintTexture;

		resetColor();

	}
    public void resetColor()
    {
		for (int i = 0; i < paintTexture.width; i++)
		{
			for (int j = 0; j < paintTexture.height; j++)
			{
				paintTexture.SetPixel(i, j, clearColor);

			}
		}
		paintTexture.Apply();
	}

    // Update is called once per frame
    void Update()
    {
        if(Input.GetMouseButtonDown(0)==true)
        {
            isPainting = true;
           
        }
        else if(Input.GetMouseButtonUp(0) == true)
        {
			isPainting = false;
		}
        if(isPainting)
        {
			Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
			RaycastHit hit;
			if (Physics.Raycast(ray, out hit))
			{
				Debug.Log("ssss");
				Vector3 wPos = hit.point;
				Vector2 uv = hit.textureCoord;
				int centerX = (int)(uv.x * this.paintTexture.width) % this.paintTexture.width;
				int centerY = (int)(uv.y * this.paintTexture.height) % this.paintTexture.height;
				DoDrawCircle(centerX, centerY);


			}
		}
    }

	 void DoDrawCircle(int centerX,int centerY)
	{

        for(int i=-R;i<=R;i++)
        {
            for(int j=-R;j<=R;j++)
            {
                if(i*i+j*j<R*R)
                {
					this.paintTexture.SetPixel(centerX+i, centerY+j, paintColor);
					Debug.Log(centerX + ":" + centerY);
					
				}
            }
        }
		this.paintTexture.Apply();





	}
}
