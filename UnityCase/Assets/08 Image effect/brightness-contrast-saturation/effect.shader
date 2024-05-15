Shader "Custom/case08/brightness"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BrightnessAmount("Brightness Amount",Range(0,1))=1.0
        _SaturationAmount("Saturation Amount",Range(0,1))=1.0
        _ContrastAmount("Constrat Amount",Range(0,1))=1.0
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

            fixed _BrightnessAmount;
            fixed _SaturationAmount;
            fixed _ContrastAmount;

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
                fixed3 ret=col.rgb*_BrightnessAmount;
                fixed3 sat=fixed3(0.2125,0.7154,0.0721);
                fixed final=dot(sat,col.rgb);
                fixed3 saturationColor=fixed3(final,final,final);
                ret=lerp(saturationColor,ret,_SaturationAmount);

                fixed3 arg=fixed3(0.5,0.5,0.5);
                ret=lerp(arg,ret,_ContrastAmount);
                return fixed4(ret,col.a);
            }
            ENDCG
        }
    }
}
