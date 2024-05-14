Shader "Custom/case06/Glass"
{
    Properties
    {
        _MainTex("Base (RGB) Trans(A)",2D)="white"{}
        _BumpMap("Noise Texture",2D)="bump"{}
        _Magnitude("Magnitude",Range(0,1))=0.05
        _Color("color",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { 
        "RenderType"="Opaque" "Queue"="Transparent"
        "Queue"="Transparent"
        }
        LOD 100
        GrabPass
        {
                  "_BackgroundTexture"
        }
        Pass
        {
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
 

            #include "UnityCG.cginc"
            sampler2D _BackgroundTexture;
            sampler2D    _MainTex;
            sampler2D  _BumpMap;
            float _Magnitude;
            fixed4 _Color;
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord:TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 uvgrab:TEXCOORD0;
                float2 texcoord:   TEXCOORD1;
            };



            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uvgrab=ComputeGrabScreenPos(o.vertex);
                o.  texcoord=v. texcoord;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
               
               

                half4 mainColor=tex2D(_MainTex,i.texcoord);
                half4 bump=tex2D(_BumpMap,i.texcoord);
                half2 distoration=UnpackNormal(bump).rg;
                i.uvgrab.xy+= distoration*_Magnitude;
                fixed4 col=tex2Dproj(_BackgroundTexture,UNITY_PROJ_COORD(i.uvgrab));
                return col*mainColor*_Color;
            }
            ENDCG
        }
    }
}
