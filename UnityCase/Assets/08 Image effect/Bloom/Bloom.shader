Shader "Custom/case08/Bloom"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BloomTex ("Bloom Texture", 2D) = "black" {}
        _BrightnessThreshold("Threshold",Range(0,2))=0.5
        _BlurSize("Blur Size",Range(0,10))=1
    }
    SubShader
    {

        CGINCLUDE
            #include "UnityCG.cginc"
            sampler2D _MainTex;
            float _BlurSize;
            half4   _MainTex_TexelSize;
            sampler2D _BloomTex;
            float _BrightnessThreshold;
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



            struct v2f_bloom
            {
                float4 pos:SV_POSITION;
                half4 uv:TEXCOORD0; 
            };

            v2f_bloom vertCatchBright(appdata_img v)
            {
                  v2f_bloom o;
                  o.pos=UnityObjectToClipPos(v.vertex);
                  o.uv.xy=v.texcoord;
                  return o;
            }

            fixed luminance(fixed4 color) {
			    return  0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b; 
		    }

            fixed4 fragCatchBright(v2f_bloom i) :SV_Target
            {
                fixed4 col=tex2D(_MainTex,i.uv);
                float v= clamp(luminance(col)-_BrightnessThreshold,0,1);
                return v*col;
            }

            v2f_bloom vertBloom(appdata_img v)
            {
                v2f_bloom o;
                o.pos=UnityObjectToClipPos(v.vertex);
                o.uv.xy=v.texcoord.xy;
                o.uv.zw = v.texcoord.xy;
                #if UNITY_UV_STARTS_AT_TOP			
			    if (_MainTex_TexelSize.y < 0.0)
				    o.uv.w = 1.0 - o.uv.w;
			    #endif
                return o;
            }

            fixed4 fragBloom(v2f_bloom v):SV_Target
            {
                return tex2D(_MainTex,v.uv.xy)+tex2D(_BloomTex,v.uv.zw);
            }


        ENDCG

        ZTest Always Cull Off ZWrite Off
        Pass
        {
            CGPROGRAM
            #pragma vertex vertCatchBright
            #pragma fragment fragCatchBright
            ENDCG
        }

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
        Pass
        {
            CGPROGRAM
            #pragma vertex vertBloom
            #pragma fragment fragBloom
            ENDCG
        }
    }
    FallBack "Diffuse"
}
