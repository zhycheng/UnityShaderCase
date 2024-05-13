Shader "Custom/case03/phong"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Specular ("Specular", Range(1,32)) = 8
       
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf phong

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
        float _Specular;

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
            o.Alpha = c.a;
        }

        fixed4 Lightingphong(SurfaceOutput s,half3 lightDir,half3 viewDir,half atten)
        {
            half NdotL=saturate(dot(s.Normal,lightDir));
           
            fixed3 diffuse=  s.Albedo*_LightColor0.rgb*(NdotL*atten);
            fixed3 R=normalize(2*s.Normal*dot(s.Normal,lightDir)-lightDir);
            fixed spc=pow(saturate(dot(R,viewDir)),_Specular);
            fixed3 specular =s.Albedo*_LightColor0.rgb*(spc*atten);
            half4 c;
            c.rgb=  diffuse+specular;
            c.a=s.Alpha;
            return c;
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
