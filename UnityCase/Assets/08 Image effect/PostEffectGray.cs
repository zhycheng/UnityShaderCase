using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PostEffectGray : MonoBehaviour
{

    public Material material;    
    // Start is called before the first frame update
    void Start()
    {
        if(material == null)
        {
            enabled = false;
        }
    }

	// OnRenderImage 在所有渲染完成后被调用，以对图片进行额外渲染
	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
        if(material!=null)
        {
            Graphics.Blit(source, destination,material);
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
