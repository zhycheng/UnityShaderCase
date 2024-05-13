Shader "Custom/case03/cartoon"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RampTex("Ramp",2D)="white"{}
        _LightLevel("Level",Range(1,32)) =10
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Toon2

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        sampler2D   _RampTex;
        half _LightLevel;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            
            o.Alpha = c.a;
        }
        half4 LightingLimpleLambert(SurfaceOutput s,half3 lightDir,half atten)
        {
            half NdotL=saturate(dot(s.Normal,lightDir));
            half4 c;
            c.rgb=  s.Albedo*_LightColor0.rgb*(NdotL*atten);
            c.a=s.Alpha;
            return c;
        }
        fixed4 LightingToon(SurfaceOutput s,fixed3 lightDir,fixed atten)
        {
            half NdotL=saturate(dot(s.Normal,lightDir));
            NdotL=tex2D(_RampTex,fixed2(NdotL,0.5));
            fixed4 c;
            c.rgb=s.Albedo*_LightColor0.rgb*NdotL*atten;
            c.a=s.Alpha;
            return c;
        }
        fixed4 LightingToon2(SurfaceOutput s,fixed3 lightDir,fixed atten)
        {
            half NdotL=saturate(dot(s.Normal,lightDir));
            NdotL=floor(NdotL*_LightLevel)/_LightLevel;
            fixed4 c;
            c.rgb=s.Albedo*_LightColor0.rgb*NdotL*atten;
            c.a=s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}