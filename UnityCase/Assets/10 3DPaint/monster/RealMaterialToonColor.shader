// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ToonColor"
{
	Properties
	{
		[Header(Highlights)]_HighlightsColor("HighlightsColor", Color) = (1,1,1,0)
		[Toggle]_Highlights("Highlights", Float) = 1
		_LightColor("LightColor", Color) = (1,1,1,0)
		_HighlightsRange("HighlightsRange", Range( 0 , 1)) = 0.8
		_HighlightsColorStrength("HighlightsColorStrength", Range( 0 , 1)) = 0
		[Header(Shadow)]_ShadowColor("ShadowColor", Color) = (1,1,1,0)
		_Shadowrange("Shadow range", Range( 0 , 1)) = 0
		_shadowStrength("shadowStrength", Range( 0 , 1)) = 0
		[Header(Reflected light)]_ReflectedlightColor("Reflected light Color", Color) = (1,1,1,0)
		[Toggle]_Reflectedlight("Reflected light", Float) = 1
		_ReflectedlightRange("Reflected light Range", Range( 0 , 1)) = 0.49
		_ReflectLightStrength("ReflectLightStrength", Range( 0 , 1)) = 0
		[Header(Fresnel)]_Fresnel("Fresnel", Range( 0 , 2)) = 0
		[Toggle(_USEFRESNEL_ON)] _UseFresnel("UseFresnel", Float) = 0
		[Toggle(_USETEX_ON)] _UseTex("UseTex", Float) = 0
		_Texture("Texture", 2D) = "white" {}
		_MOR("MOR", 2D) = "white" {}
		_Emission("Emission", 2D) = "black" {}
		[Normal]_normal("normal", 2D) = "bump" {}
		[Toggle]_normalMapSuface("normalMapSuface", Float) = 1
		_Aostrength("Ao strength", Range( 0 , 1)) = 1
		_Matcap("Matcap", 2D) = "white" {}
		_matcapstrength("matcap strength", Range( 0 , 1)) = 0.5
		_emissionstrength("emission strength", Range( 0 , 1.5)) = 1
		_Aorange("Ao range", Range( 0 , 1)) = 0
		[Toggle]_UseOutLine("UseOutLine", Float) = 1
		_smooth("smooth", Float) = 0
		_blend("blend", Range( 0 , 1)) = 0
		[Toggle]_hit("hit", Float) = 0
		_B("B", Range( -1 , 1)) = 0
		_G("G", Range( -1 , 1)) = 0
		_R("R", Range( -1 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		ZWrite Off
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float cameraDepthFade180 = (( -UnityObjectToViewPos( v.vertex.xyz ).z -_ProjectionParams.y - 1.0 ) / 50.0);
			float outlineVar = (( _UseOutLine )?( ( ( 0.05 + cameraDepthFade180 ) / 6.0 ) ):( 0.0 ));
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			float4 color132 = IsGammaSpace() ? float4(0.4352942,0.9921569,0.01960784,1) : float4(0.1589609,0.9822509,0.001517635,1);
			o.Emission = color132.rgb;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZWrite On
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_local __ _USEFRESNEL_ON
		#pragma multi_compile_local __ _USETEX_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif

		struct appdata_full_custom
		{
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 texcoord2 : TEXCOORD2;
			float4 texcoord3 : TEXCOORD3;
			float4 color : COLOR;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _hit;
		uniform float _Reflectedlight;
		uniform float _Highlights;
		uniform float4 _ShadowColor;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float4 _LightColor;
		uniform float _Shadowrange;
		uniform float _normalMapSuface;
		uniform sampler2D _normal;
		uniform float4 _normal_ST;
		uniform float _shadowStrength;
		uniform float _Fresnel;
		uniform float4 _HighlightsColor;
		uniform float _HighlightsRange;
		uniform float _HighlightsColorStrength;
		uniform float4 _ReflectedlightColor;
		uniform float _ReflectedlightRange;
		uniform float _ReflectLightStrength;
		uniform float _R;
		uniform float _G;
		uniform float _B;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float _emissionstrength;
		uniform float _Aorange;
		uniform sampler2D _MOR;
		uniform float4 _MOR_ST;
		uniform float _Aostrength;
		uniform sampler2D _Matcap;
		uniform float _matcapstrength;
		uniform float _smooth;
		uniform float _blend;
		uniform float _UseOutLine;

		void vertexDataFunc( inout appdata_full_custom v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += 0;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			SurfaceOutputStandard s160 = (SurfaceOutputStandard ) 0;
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float4 tex2DNode64 = tex2D( _Texture, uv_Texture );
			float4 blendOpSrc65 = tex2DNode64;
			float4 blendOpDest65 = tex2DNode64;
			#ifdef _USETEX_ON
				float4 staticSwitch67 = ( saturate( ( blendOpSrc65 * blendOpDest65 ) ));
			#else
				float4 staticSwitch67 = _ShadowColor;
			#endif
			float4 blendOpSrc62 = _LightColor;
			float4 blendOpDest62 = tex2D( _Texture, uv_Texture );
			#ifdef _USETEX_ON
				float4 staticSwitch66 = ( saturate( 2.0f*blendOpDest62*blendOpSrc62 + blendOpDest62*blendOpDest62*(1.0f - 2.0f*blendOpSrc62) ));
			#else
				float4 staticSwitch66 = _LightColor;
			#endif
			float clampResult29 = clamp( _Shadowrange , 0.0 , 1.0 );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float2 uv_normal = i.uv_texcoord * _normal_ST.xy + _normal_ST.zw;
			float3 tex2DNode85 = UnpackNormal( tex2D( _normal, uv_normal ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
			float3 tangentToWorldPos94 = mul( ase_tangentToWorldFast, tex2DNode85 );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult13 = dot( (( _normalMapSuface )?( tangentToWorldPos94 ):( ase_normWorldNormal )) , ase_worldlightDir );
			float smoothstepResult14 = smoothstep( 0.0 , clampResult29 , dotResult13);
			float lerpResult68 = lerp( 1.0 , ( ase_lightAtten * smoothstepResult14 ) , (0.0 + (_shadowStrength - 0.0) * (3.0 - 0.0) / (1.0 - 0.0)));
			float clampResult36 = clamp( _Shadowrange , 0.0 , 1.0 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV30 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode30 = ( 0.0 + _Fresnel * pow( 1.0 - fresnelNdotV30, 0.5 ) );
			float smoothstepResult37 = smoothstep( 0.0 , clampResult36 , ( 1.0 - fresnelNode30 ));
			#ifdef _USEFRESNEL_ON
				float staticSwitch39 = smoothstepResult37;
			#else
				float staticSwitch39 = lerpResult68;
			#endif
			float4 lerpResult9 = lerp( staticSwitch67 , staticSwitch66 , staticSwitch39);
			float clampResult28 = clamp( ( 1.0 - _HighlightsRange ) , 0.0 , 1.0 );
			float smoothstepResult23 = smoothstep( clampResult28 , 1.0 , dotResult13);
			float4 lerpResult24 = lerp( lerpResult9 , _HighlightsColor , smoothstepResult23);
			float4 lerpResult52 = lerp( lerpResult9 , lerpResult24 , _HighlightsColorStrength);
			float temp_output_46_0 = ( 1.0 - smoothstepResult14 );
			float clampResult43 = clamp( ( 1.0 - _ReflectedlightRange ) , 0.0 , 1.0 );
			float smoothstepResult44 = smoothstep( 2.0 , -1.0 , temp_output_46_0);
			float smoothstepResult48 = smoothstep( clampResult43 , 1.0 , ( smoothstepResult44 - dotResult13 ));
			float4 lerpResult41 = lerp( (( _Highlights )?( lerpResult52 ):( lerpResult9 )) , _ReflectedlightColor , ( temp_output_46_0 * smoothstepResult48 ));
			float4 lerpResult55 = lerp( (( _Highlights )?( lerpResult52 ):( lerpResult9 )) , lerpResult41 , _ReflectLightStrength);
			#ifdef _USEFRESNEL_ON
				float4 staticSwitch40 = lerpResult9;
			#else
				float4 staticSwitch40 = (( _Reflectedlight )?( lerpResult55 ):( (( _Highlights )?( lerpResult52 ):( lerpResult9 )) ));
			#endif
			float4 TexColor186 = staticSwitch40;
			float4 break187 = TexColor186;
			float3 appendResult190 = (float3(break187.r , break187.g , break187.b));
			float3 appendResult197 = (float3(_R , _G , _B));
			float4 appendResult188 = (float4(( appendResult190 + appendResult197 ) , break187.a));
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float4 tex2DNode77 = tex2D( _Emission, uv_Emission );
			float temp_output_81_0 = ( tex2DNode77.r + tex2DNode77.g + tex2DNode77.b );
			float4 lerpResult82 = lerp( appendResult188 , tex2DNode77 , ( _emissionstrength * temp_output_81_0 ));
			float2 uv_MOR = i.uv_texcoord * _MOR_ST.xy + _MOR_ST.zw;
			float4 tex2DNode73 = tex2D( _MOR, uv_MOR );
			float smoothstepResult127 = smoothstep( 0.0 , _Aorange , tex2DNode73.g);
			float lerpResult99 = lerp( 1.0 , smoothstepResult127 , _Aostrength);
			float lerpResult157 = lerp( lerpResult99 , 0.0 , temp_output_81_0);
			float temp_output_109_0 = ( 1.0 - tex2DNode73.b );
			float4 lerpResult146 = lerp( lerpResult82 , tex2D( _Matcap, ( ( mul( UNITY_MATRIX_V, float4( (( _normalMapSuface )?( tangentToWorldPos94 ):( ase_normWorldNormal )) , 0.0 ) ).xyz * temp_output_109_0 ) + temp_output_109_0 ).xy ) , _matcapstrength);
			float4 lerpResult121 = lerp( ( lerpResult82 * ( lerpResult157 + temp_output_81_0 ) ) , ( lerpResult146 + ( lerpResult82 * float4( 0,0,0,0 ) * lerpResult99 ) ) , tex2DNode73.r);
			s160.Albedo = lerpResult121.rgb;
			s160.Normal = WorldNormalVector( i , tex2DNode85 );
			s160.Emission = tex2DNode77.rgb;
			s160.Metallic = tex2DNode73.r;
			s160.Smoothness = ( ( 1.0 - tex2DNode73.b ) * _smooth );
			s160.Occlusion = ( tex2DNode73.g * _Aostrength );

			data.light = gi.light;

			UnityGI gi160 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g160 = UnityGlossyEnvironmentSetup( s160.Smoothness, data.worldViewDir, s160.Normal, float3(0,0,0));
			gi160 = UnityGlobalIllumination( data, s160.Occlusion, s160.Normal, g160 );
			#endif

			float3 surfResult160 = LightingStandard ( s160, viewDir, gi160 ).rgb;
			surfResult160 += s160.Emission;

			#ifdef UNITY_PASS_FORWARDADD//160
			surfResult160 -= s160.Emission;
			#endif//160
			float4 blendOpSrc166 = float4( surfResult160 , 0.0 );
			float4 blendOpDest166 = lerpResult121;
			float4 lerpBlendMode166 = lerp(blendOpDest166,2.0f*blendOpDest166*blendOpSrc166 + blendOpDest166*blendOpDest166*(1.0f - 2.0f*blendOpSrc166),_blend);
			float4 temp_output_166_0 = ( saturate( lerpBlendMode166 ));
			float4 color170 = IsGammaSpace() ? float4(1,0.3502357,0.2688679,0) : float4(1,0.1006219,0.05875937,0);
			float4 blendOpSrc169 = temp_output_166_0;
			float4 blendOpDest169 = color170;
			float4 lerpBlendMode169 = lerp(blendOpDest169,( blendOpDest169/ max( 1.0 - blendOpSrc169, 0.00001 ) ),0.8);
			float fresnelNdotV171 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode171 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV171, 0.5 ) );
			float4 lerpResult172 = lerp( temp_output_166_0 , lerpBlendMode169 , fresnelNode171);
			c.rgb = (( _hit )?( lerpResult172 ):( temp_output_166_0 )).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full_custom v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
1913;52;1920;959;7.033203;998.1742;1;True;False
Node;AmplifyShaderEditor.SamplerNode;85;-3223.293,807.4277;Inherit;True;Property;_normal;normal;18;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;0ca977f725cccab419aa1c9c551f4dba;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;11;-3253.944,471.8546;Inherit;True;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;94;-2912.223,808.1245;Inherit;False;Tangent;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;12;-2859.563,299.6548;Inherit;True;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;16;-2045.047,656.6596;Inherit;False;Property;_Shadowrange;Shadow range;6;0;Create;True;0;0;0;False;0;False;0;0.62;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;96;-2832.223,699.1245;Inherit;False;Property;_normalMapSuface;normalMapSuface;19;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-2305.06,40.3501;Inherit;False;Property;_Fresnel;Fresnel;12;1;[Header];Create;True;1;Fresnel;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;13;-2613.821,437.5262;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;29;-1504.213,874.8375;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;14;-1394.889,537.2343;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;30;-2012.985,-178.4026;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;59;-2181.559,-907.5707;Inherit;True;Property;_Texture;Texture;15;0;Create;True;0;0;0;False;0;False;None;5efa756a6610a894d9d8183455d5d5ca;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;69;-1123.471,505.2843;Inherit;False;Property;_shadowStrength;shadowStrength;7;0;Create;True;0;0;0;False;0;False;0;0.16;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;18;-1413.653,251.296;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;64;-1761.167,-911.3408;Inherit;True;Property;_TextureSample1;Texture Sample 1;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-1013.403,683.8096;Inherit;False;Property;_HighlightsRange;HighlightsRange;3;0;Create;True;0;0;0;False;0;False;0.8;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-1584.511,-648.5958;Inherit;False;Property;_LightColor;LightColor;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,0.8580792,0.7216981,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;61;-2101.149,-468.8496;Inherit;True;Property;_TextureSample0;Texture Sample 0;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;36;-1539.711,263.1629;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;34;-1625.031,-172.5905;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1169.886,265.9869;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;70;-766.0813,490.3519;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;65;-929.0261,-906.2195;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;37;-1252.614,51.63294;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;54;-680.7795,688.7382;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;68;-822.949,261.1539;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;62;-1415.149,-422.8496;Inherit;True;SoftLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;-1172.311,-610.8597;Inherit;False;Property;_ShadowColor;ShadowColor;5;1;[Header];Create;True;1;Shadow;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;28;-516.2029,706.9599;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;66;-791.0261,-351.2195;Inherit;False;Property;_UseTex;UseTex;14;0;Create;True;0;0;0;False;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;39;-882.8047,94.84157;Inherit;False;Property;_UseFresnel;UseFresnel;13;0;Create;True;0;0;0;False;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;67;-645.0261,-593.2195;Inherit;False;Property;_UseTex;UseTex;14;0;Create;True;0;0;0;False;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Reference;66;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-502.9448,1296.923;Inherit;False;Property;_ReflectedlightRange;Reflected light Range;10;0;Create;True;0;0;0;False;0;False;0.49;0.394;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;46;-1146.224,1016.031;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;23;-537.2653,349.7596;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.8;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;44;-891.9297,1036.956;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;49;-181.753,1289.141;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;9;-548.064,-361.5225;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;25;-651.9869,-64.42613;Inherit;False;Property;_HighlightsColor;HighlightsColor;0;1;[Header];Create;True;1;Highlights;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;43;30.32317,1221.385;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-681.9924,172.0427;Inherit;False;Property;_HighlightsColorStrength;HighlightsColorStrength;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;24;-431.4845,14.14299;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;47;-558.3079,972.7533;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;-230.0924,1.042725;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;48;-283.9223,981.4224;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-38.04797,719.5031;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;50;-76.07806,-117.6271;Inherit;False;Property;_Highlights;Highlights;1;0;Create;True;0;0;0;False;0;False;1;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;45;-200.3184,319.61;Inherit;False;Property;_ReflectedlightColor;Reflected light Color;8;1;[Header];Create;True;1;Reflected light;0;0;False;0;False;1,1,1,0;0.4721876,0.6933733,0.764151,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;374.4834,546.3221;Inherit;False;Property;_ReflectLightStrength;ReflectLightStrength;11;0;Create;True;0;0;0;False;0;False;0;0.16;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;41;107.4958,366.0933;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;55;476.9221,214.0051;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;51;305.4,-79.72357;Inherit;False;Property;_Reflectedlight;Reflected light;9;0;Create;True;0;0;0;False;0;False;1;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;40;153.3354,-307.4671;Inherit;False;Property;_Keyword0;Keyword 0;13;0;Create;True;0;0;0;False;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Reference;39;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;186;454.9668,-301.1742;Inherit;False;TexColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;347.9668,-580.1742;Inherit;False;186;TexColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;194;674.9668,-547.1742;Inherit;False;Property;_R;R;31;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;195;668.9668,-468.1742;Inherit;False;Property;_G;G;30;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;658.9668,-387.1742;Inherit;False;Property;_B;B;29;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;187;723.9668,-775.1742;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ViewMatrixNode;100;311.5292,901.8807;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SamplerNode;73;673.6474,402.7576;Inherit;True;Property;_MOR;MOR;16;0;Create;True;0;0;0;False;0;False;-1;None;0f36449fc97b8394e978079aa8a18c77;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;190;839.9668,-875.1742;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;128;775.2883,599.398;Inherit;False;Property;_Aorange;Ao range;24;0;Create;True;0;0;0;False;0;False;0;1.12;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;470.0723,931.6666;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;77;592.5283,-82.75635;Inherit;True;Property;_Emission;Emission;17;0;Create;True;0;0;0;False;0;False;-1;None;2e7eb93367b668d45b425e7d4c13996c;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;109;771.3181,1084.324;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;197;984.9668,-487.1742;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;127;1103.8,580.4464;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;787.3243,903.1122;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;717.7402,155.9249;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;192;1011.967,-637.1742;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;98;656.1191,703.9168;Inherit;False;Property;_Aostrength;Ao strength;20;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;1435.495,-458.4283;Inherit;False;Property;_emissionstrength;emission strength;23;0;Create;True;0;0;0;False;0;False;1;0;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;988.1948,-10.92828;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;1035.634,919.1891;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;99;1256.661,579.6985;Inherit;True;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;188;1162.967,-777.1742;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;157;1071.704,196.844;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;1076.64,1185.013;Float;False;Property;_matcapstrength;matcap strength;22;0;Create;True;0;0;0;False;0;False;0.5;0.512;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;106;1190.707,844.7866;Inherit;True;Property;_Matcap;Matcap;21;0;Create;True;0;0;0;False;0;False;-1;None;1b8f5790a28d71844ae19a6c00650cef;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;82;1145.068,-152.5999;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;159;1480.445,281.1768;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;1737.711,307.2226;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;146;1572.116,923.7948;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;1733.775,71.6095;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;163;1865.498,992.207;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;161;2035.694,1085.701;Inherit;False;Property;_smooth;smooth;26;0;Create;True;0;0;0;False;0;False;0;1.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;110;1793.004,609.0243;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;2169.02,932.2532;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;121;2146.032,520.5446;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;2409.762,1018.122;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;173;1935.162,1628.746;Inherit;False;Constant;_width;width;30;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;180;1933.259,1814.375;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;50;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;2698.818,674.3977;Inherit;False;Property;_blend;blend;27;0;Create;True;0;0;0;False;0;False;0;0.991;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;160;2619.661,850.2841;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;183;2175.502,1697.337;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;166;2802.818,501.3977;Inherit;False;SoftLight;True;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;170;3210.805,733.6088;Inherit;False;Constant;_hitcolor;hit color;31;0;Create;True;0;0;0;False;0;False;1,0.3502357,0.2688679,0;1,0.9547865,0.7311321,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;184;2493.956,1765.383;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;6;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;171;3502.306,796.9091;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;169;3478.306,666.9091;Inherit;False;ColorDodge;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.8;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;172;3849.306,667.9091;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;132;2439.141,1308.881;Inherit;False;Constant;_Color;Color;27;0;Create;True;0;0;0;False;0;False;0.4352942,0.9921569,0.01960784,1;0,1,0.1715357,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;130;2563.341,1504.781;Inherit;False;Property;_UseOutLine;UseOutLine;25;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;168;3941.306,545.9091;Inherit;False;Property;_hit;hit;28;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OutlineNode;129;2671.507,1324.546;Inherit;False;0;False;None;2;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4174.905,552.2052;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ToonColor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;94;0;85;0
WireConnection;96;0;11;0
WireConnection;96;1;94;0
WireConnection;13;0;96;0
WireConnection;13;1;12;0
WireConnection;29;0;16;0
WireConnection;14;0;13;0
WireConnection;14;2;29;0
WireConnection;30;2;57;0
WireConnection;64;0;59;0
WireConnection;61;0;59;0
WireConnection;36;0;16;0
WireConnection;34;0;30;0
WireConnection;17;0;18;0
WireConnection;17;1;14;0
WireConnection;70;0;69;0
WireConnection;65;0;64;0
WireConnection;65;1;64;0
WireConnection;37;0;34;0
WireConnection;37;2;36;0
WireConnection;54;0;27;0
WireConnection;68;1;17;0
WireConnection;68;2;70;0
WireConnection;62;0;10;0
WireConnection;62;1;61;0
WireConnection;28;0;54;0
WireConnection;66;1;10;0
WireConnection;66;0;62;0
WireConnection;39;1;68;0
WireConnection;39;0;37;0
WireConnection;67;1;1;0
WireConnection;67;0;65;0
WireConnection;46;0;14;0
WireConnection;23;0;13;0
WireConnection;23;1;28;0
WireConnection;44;0;46;0
WireConnection;49;0;42;0
WireConnection;9;0;67;0
WireConnection;9;1;66;0
WireConnection;9;2;39;0
WireConnection;43;0;49;0
WireConnection;24;0;9;0
WireConnection;24;1;25;0
WireConnection;24;2;23;0
WireConnection;47;0;44;0
WireConnection;47;1;13;0
WireConnection;52;0;9;0
WireConnection;52;1;24;0
WireConnection;52;2;53;0
WireConnection;48;0;47;0
WireConnection;48;1;43;0
WireConnection;58;0;46;0
WireConnection;58;1;48;0
WireConnection;50;0;9;0
WireConnection;50;1;52;0
WireConnection;41;0;50;0
WireConnection;41;1;45;0
WireConnection;41;2;58;0
WireConnection;55;0;50;0
WireConnection;55;1;41;0
WireConnection;55;2;56;0
WireConnection;51;0;50;0
WireConnection;51;1;55;0
WireConnection;40;1;51;0
WireConnection;40;0;9;0
WireConnection;186;0;40;0
WireConnection;187;0;185;0
WireConnection;190;0;187;0
WireConnection;190;1;187;1
WireConnection;190;2;187;2
WireConnection;103;0;100;0
WireConnection;103;1;96;0
WireConnection;109;0;73;3
WireConnection;197;0;194;0
WireConnection;197;1;195;0
WireConnection;197;2;196;0
WireConnection;127;0;73;2
WireConnection;127;2;128;0
WireConnection;104;0;103;0
WireConnection;104;1;109;0
WireConnection;81;0;77;1
WireConnection;81;1;77;2
WireConnection;81;2;77;3
WireConnection;192;0;190;0
WireConnection;192;1;197;0
WireConnection;126;0;124;0
WireConnection;126;1;81;0
WireConnection;105;0;104;0
WireConnection;105;1;109;0
WireConnection;99;1;127;0
WireConnection;99;2;98;0
WireConnection;188;0;192;0
WireConnection;188;3;187;3
WireConnection;157;0;99;0
WireConnection;157;2;81;0
WireConnection;106;1;105;0
WireConnection;82;0;188;0
WireConnection;82;1;77;0
WireConnection;82;2;126;0
WireConnection;159;0;157;0
WireConnection;159;1;81;0
WireConnection;112;0;82;0
WireConnection;112;2;99;0
WireConnection;146;0;82;0
WireConnection;146;1;106;0
WireConnection;146;2;102;0
WireConnection;84;0;82;0
WireConnection;84;1;159;0
WireConnection;163;0;73;3
WireConnection;110;0;146;0
WireConnection;110;1;112;0
WireConnection;162;0;163;0
WireConnection;162;1;161;0
WireConnection;121;0;84;0
WireConnection;121;1;110;0
WireConnection;121;2;73;1
WireConnection;164;0;73;2
WireConnection;164;1;98;0
WireConnection;160;0;121;0
WireConnection;160;1;85;0
WireConnection;160;2;77;0
WireConnection;160;3;73;1
WireConnection;160;4;162;0
WireConnection;160;5;164;0
WireConnection;183;0;173;0
WireConnection;183;1;180;0
WireConnection;166;0;160;0
WireConnection;166;1;121;0
WireConnection;166;2;167;0
WireConnection;184;0;183;0
WireConnection;169;0;166;0
WireConnection;169;1;170;0
WireConnection;172;0;166;0
WireConnection;172;1;169;0
WireConnection;172;2;171;0
WireConnection;130;1;184;0
WireConnection;168;0;166;0
WireConnection;168;1;172;0
WireConnection;129;0;132;0
WireConnection;129;1;130;0
WireConnection;0;13;168;0
WireConnection;0;11;129;0
ASEEND*/
//CHKSM=DF81EA657DE48862A8ED91DD2BD2C0A5F55B92A0