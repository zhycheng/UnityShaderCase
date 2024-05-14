Shader "Custom/case06/water"
{
    Properties
    {
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _Color("Color",Color)=(1,1,1,1)
        _Period("Period",Range(0,50))=1
        _Magnitude("Magnitude",Range(0,0.5))=0.05
        _Scale("Scale",Range(0,10))=1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        GrabPass
        {
            "_backgroudTexture"
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
      

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                fixed4 color:COLOR;
            };

            struct v2f
            {
                float2 texcoord : TEXCOORD0;
                float4 vertex : SV_POSITION;
                fixed4 color:COLOR;
                float4 uvgrab:TEXCOORD1;
                float4  worldPos:  TEXCOORD2;
            };

            sampler2D _NoiseTex;
            sampler2D  _backgroudTexture;
            fixed4 _Color;
            float _Period;
            float _Magnitude;
            float _Scale;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uvgrab=ComputeGrabScreenPos(o.vertex);
                o.texcoord=v.texcoord;
                o.color=v.color;
                o.worldPos=mul(unity_ObjectToWorld,v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float sinT=sin(_Time.w/_Period);
                float2 distortion=float2(tex2D(_NoiseTex,i.worldPos/_Scale+float2(sinT,0)).r-0.5,
                   tex2D(_NoiseTex,i.worldPos/_Scale+float2(0,sinT)).r-0.5
                );
               
               i.uvgrab.xy+=distortion* _Magnitude;
               fixed4 col =tex2Dproj(_backgroudTexture,UNITY_PROJ_COORD(i.uvgrab));
               return col*_Color;
            }
            ENDCG
        }
    }
}
