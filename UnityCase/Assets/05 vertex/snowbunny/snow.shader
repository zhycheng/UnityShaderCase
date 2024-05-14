Shader "Custom/case05/snow"
{
    Properties
    {



        _MainColor("Main Color",Color)=(1,1,1,1)
        _MainTex("Base (RGB)",2D)="white"{}
        _Bump("Bump",2D)="bump"{}
        _Snow("Level of Snow",Range(-1,1))=1
        _SnowColor("Color of Snow",Color)=(1,1,1,1)
        _SnowDirection("Direction of Snow",Vector)=(0,1,0)
        _SnowDepth("Depth of Snow",Range(0,1))=0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D     _Bump;
        float _Snow;
        float4 _SnowColor;
        float4  _MainColor;
        float4  _SnowDirection;
        float _SnowDepth;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Bump;
            float3 worldNormal;INTERNAL_DATA
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)
        void vert(inout appdata_full v)
        {
            float3 worldNormal=UnityObjectToWorldNormal(v.normal);
            float3 objectNormal=UnityWorldToObjectDir(_SnowDirection);
            if(dot(worldNormal,_SnowDirection)>=_Snow)
            {
                v.vertex.xyz+=(objectNormal)*_SnowDepth;
            }
        }
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
              half4 c=  tex2D(_MainTex,IN.uv_MainTex);
              o.Normal=UnpackNormal(tex2D(_Bump,IN.uv_Bump));
              if(dot(WorldNormalVector(IN,o.Normal),_SnowDirection)>=_Snow)
              {
                o.Albedo=_SnowColor;
              }
              else
              {
              o.Albedo=c.rgb*_MainColor.rgb;
              }
              o.Alpha=1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
