Shader "Custom/case08/Depth"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DepthPower("Depth Scale Amount",Range(0,5))=1
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
            //#pragma fragmentoption ARB_precision_hint_fastest
   

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _DepthPower;
            sampler2D _CameraDepthTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_CameraDepthTexture, i.uv.xy);
                float d=UNITY_SAMPLE_DEPTH(col);
                d=Linear01Depth(d);
                d=pow(d,_DepthPower);
                return d;
            }
            ENDCG
        }
    }
}
