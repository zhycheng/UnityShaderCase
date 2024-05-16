Shader "Custom/case09/OutlineNormal"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor("Main Color",Color)=(1,1,1,1)
        _OutlineWidth("Outline width",Range(0,1))=0.7
        _OutlineColr("Outline Color",Color)=(0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
           
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"
            float _OutlineWidth;
            fixed4 _OutlineColr;
            fixed4 _MainColor;

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 worldPos:TEXCOORD1;
                float3 worldNormal: TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex=UnityObjectToClipPos(v.vertex);
                o.worldPos=mul(unity_ObjectToWorld,v.vertex);
                o.worldNormal=UnityObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                float4 worldPos=i.worldPos;
                float3 worldNormal=i.worldNormal;

                float v=saturate(dot(worldNormal,normalize(UnityWorldSpaceViewDir(worldPos))));
                float al=step(_OutlineWidth,v);
                
               
                fixed4 col = lerp(_OutlineColr,_MainColor,al);
                return col;
            }
            ENDCG
        }

    }
}
