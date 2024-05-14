Shader "Custom/case06/UseGrabPass"
{
    Properties
    {
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Transparent"}
        LOD 100
        GrabPass
        {
                  "_BackgroundTexture"
        }
        Pass
        {
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
 

            #include "UnityCG.cginc"
            sampler2D _BackgroundTexture;
            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 uvgrab:TEXCOORD0;
            };



            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uvgrab=ComputeGrabScreenPos(o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col=tex2Dproj(_BackgroundTexture,UNITY_PROJ_COORD(i.uvgrab));
                return col+fixed4(0,0,0.3,0);
            }
            ENDCG
        }
    }
}
