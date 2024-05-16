Shader "Custom/case09/Cartoon"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor("Main Color",Color)=(1,1,1,1)
        _OutlineWidth("Outline width",Range(0,5))=0.12
        _OutlineColr("Outline Color",Color)=(0,0,0,1)
        _RampTex("Ramp Texture",2D)="white"{}
        _SpecularScale ("Specular Scale", Range(0, 0.1)) = 0.01
        _SpecularColor("Specular Color",Color)=(1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            Tags{"LightMode"="ShadowCaster"}
        }
        Pass
        {
           Cull Front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"
             float _OutlineWidth;
            fixed4 _OutlineColr;

            struct v2f
            {
                float2 uv : TEXCOORD0;

                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata_base v)
            {
                v2f o;
                float4 pos =mul(UNITY_MATRIX_MV,v.vertex);
                float3 normal =mul(UNITY_MATRIX_IT_MV,v.normal);
                normal.z=-0.5;
                pos =pos+float4(normalize(normal),0)*_OutlineWidth;
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.vertex=mul(UNITY_MATRIX_P,pos);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = _OutlineColr;
                return col;
            }
            ENDCG
        }
        Pass
        {
            Tags { "LightMode"="ForwardBase" }
			Cull Back
            CGPROGRAM
           	#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityShaderVariables.cginc"
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 worldNormal:  TEXCOORD1;
                float4 worldPos:TEXCOORD2;
                SHADOW_COORDS(3)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _MainColor;
            sampler2D _RampTex;
            float _SpecularScale;
            fixed4 _SpecularColor;
            v2f vert (appdata_full v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.worldNormal=UnityObjectToWorldNormal(v.normal);
                o.worldPos=mul(unity_ObjectToWorld,v.vertex);
                TRANSFER_SHADOW(o);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {


                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT*_MainColor;

                fixed3 lightDir=normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 viewDir=normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 halfDir=normalize(lightDir+viewDir);

                 UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);

                fixed v=(dot(i.worldNormal,lightDir)*0.5+0.5)*atten;
                
                fixed3 diffuse=_MainColor.rgb*_LightColor0.rgb*tex2D(_RampTex,float2(v,0.5)).rgb;

                fixed spec=dot(i.worldNormal,halfDir);
                fixed w=fwidth(spec)*2;
                fixed3 specular=_SpecularColor.rgb*_LightColor0.rgb*lerp(0,1,smoothstep(-w,w,spec + _SpecularScale - 1))* step(0.0001, _SpecularScale);

              return fixed4(ambient + diffuse + specular, 1.0);
            }
            ENDCG
        }
    }
 
}
