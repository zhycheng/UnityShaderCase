using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour
{

    public Material mat;
    public float radius=3;
    public Color color;
    public float width = 1f;
   

    // Start is called before the first frame update
    void Start()
    {
        color = Color.cyan;

	}

    // Update is called once per frame
    void Update()
    {
         if(mat!=null)
        {
            mat.SetFloat("_Radius", radius);
            mat.SetColor("_RadiusColor", color);
            mat.SetVector("_Center",this.transform.position);
            mat.SetFloat("_RadiusWidth", width);
        }
    }
}
