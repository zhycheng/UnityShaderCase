Shader "Custom/case08/GaussianBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BlurSize("Blur Size",Range(0,10))=1
    }
    SubShader
    {

        CGINCLUDE
            #include "UnityCG.cginc"
            sampler2D _MainTex;
            float _BlurSize;
            half4   _MainTex_TexelSize;
            struct v2f
            {
                float4 pos:SV_POSITION;
                half2 uv[5]:TEXCOORD0;
            };

            v2f vertBlurVertical(appdata_img v)
            {
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);
                o.uv[0]=v.texcoord;
                o.uv[1]=v.texcoord+float2(0,_MainTex_TexelSize.y*1)*_BlurSize;
                o.uv[2]=v.texcoord-float2(0,_MainTex_TexelSize.y*1)*_BlurSize;
                o.uv[3]=v.texcoord+float2(0,_MainTex_TexelSize.y*2)*_BlurSize;
                o.uv[4]=v.texcoord-float2(0,_MainTex_TexelSize.y*2)*_BlurSize;
                return o;
            }
            v2f vertBlurHorizontal(appdata_img v)
            {
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);
                o.uv[0]=v.texcoord;
                o.uv[1]=v.texcoord+float2(_MainTex_TexelSize.x*1,0)*_BlurSize;
                o.uv[2]=v.texcoord-float2(_MainTex_TexelSize.x*1,0)*_BlurSize;
                o.uv[3]=v.texcoord+float2(_MainTex_TexelSize.x*2,0)*_BlurSize;
                o.uv[4]=v.texcoord-float2(_MainTex_TexelSize.x*2,0)*_BlurSize;
                return o;
            }

            fixed4 fragBlur(v2f i):SV_Target
            {
                float weight[5]={0.0545,0.2442,0.4026,0.2442,0.0545};
                fixed3 sum= tex2D(_MainTex, i.uv[0]).rgb*weight[2];
                sum+= tex2D(_MainTex, i.uv[1]).rgb*weight[1];
                sum+= tex2D(_MainTex, i.uv[2]).rgb*weight[3];
                sum+= tex2D(_MainTex, i.uv[3]).rgb*weight[0];
                sum+= tex2D(_MainTex, i.uv[4]).rgb*weight[4];
                return fixed4(sum,1);
            }
        ENDCG

        ZTest Always Cull Off ZWrite Off

        Pass
        {
            NAME "GAUSSIAN_BLUR_VERTICAL"
            CGPROGRAM
            #pragma vertex vertBlurVertical
            #pragma fragment fragBlur

            ENDCG
        }
         Pass
        {
            NAME "GAUSSIAN_BLUR_HORIZONTAL"
            CGPROGRAM
            #pragma vertex vertBlurHorizontal
            #pragma fragment fragBlur

            ENDCG
        }
    }
    FallBack "Diffuse"
}
