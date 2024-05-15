Shader "Custom/case08/Gray"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _GrayAmount("Gray Scale Amount",Range(0,1))=0.5
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
            fixed _GrayAmount;

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
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed gray=0.299*col.r+0.587*col.g+0.114*col.b;
                fixed4 finalColor=lerp(col,gray,_GrayAmount);
                return finalColor;
            }
            ENDCG
        }
    }
}
