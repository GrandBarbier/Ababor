Shader "Stencil/Case_Loss"
{
    Properties
    {
        [IntRange] _StencilID ("Stencil ID", Range(0,255)) = 0
        [IntRange] _MaskID ("Mask ID", Range(0,255)) = 0
        
        Metalic("Metalic", Float) = 1
        Smoothness("Smoothness", Float) = 1
        Rust("Rust", Float) = 3
        Rust_Scale("Rust Scale", Float) = 100
        Rust_Intencity("Rust Intencity", Float) = 1
        [HDR]Rust_Color("Rust Color", Color) = (1, 0.6812683, 0, 0)
        [HDR]Color_Eyes("Color Eyes", Color) = (1, 1, 1, 0)
        Eyes_offset("Eyes offset", Float) = 1.1
        Eyes_Speed("Eyes Speed", Float) = 1
        Eyes_Max("Eyes Max", Float) = 5
        Eyes_Power("Eyes Power", Float) = 1
        _Color("Color", Color) = (0, 0, 0, 0)
        [NoScaleOffset]Texture2D_797d926dfbae4e41bdbd471e33d7993e("MainTex", 2D) = "white" {}
        [NoScaleOffset]Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97("Coin", 2D) = "white" {}
        [NoScaleOffset]Texture2D_38aa29dd5f744ffc8008a01796c8eb28("RustTex", 2D) = "white" {}
        [NoScaleOffset]Texture2D_7091a618baa9402e8301a4e786c775b6("EyesTex", 2D) = "white" {}
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="Geometry"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            // Render State
            Cull Back
            Blend One Zero
            ZTest LEqual
            ZWrite On
        
        Stencil
        {
            Ref [_StencilID]
            Comp equal
            Pass keep
        }

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_FORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            float3 normalWS;
            float4 tangentWS;
            float4 texCoord0;
            float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            float3 sh;
            #endif
            float4 fogFactorAndVertexLight;
            float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 TangentSpaceNormal;
            float4 uv0;
            float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            float3 interp1 : TEXCOORD1;
            float4 interp2 : TEXCOORD2;
            float4 interp3 : TEXCOORD3;
            float3 interp4 : TEXCOORD4;
            #if defined(LIGHTMAP_ON)
            float2 interp5 : TEXCOORD5;
            #endif
            #if !defined(LIGHTMAP_ON)
            float3 interp6 : TEXCOORD6;
            #endif
            float4 interp7 : TEXCOORD7;
            float4 interp8 : TEXCOORD8;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float Metalic;
        float Smoothness;
        float Rust;
        float Rust_Scale;
        float Rust_Intencity;
        float4 Rust_Color;
        float4 Color_Eyes;
        float Eyes_offset;
        float Eyes_Speed;
        float Eyes_Max;
        float Eyes_Power;
        float4 _Color;
        float4 Texture2D_797d926dfbae4e41bdbd471e33d7993e_TexelSize;
        float4 Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97_TexelSize;
        float4 Texture2D_38aa29dd5f744ffc8008a01796c8eb28_TexelSize;
        float4 Texture2D_7091a618baa9402e8301a4e786c775b6_TexelSize;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
        SAMPLER(samplerTexture2D_797d926dfbae4e41bdbd471e33d7993e);
        TEXTURE2D(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        SAMPLER(samplerTexture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        TEXTURE2D(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
        SAMPLER(samplerTexture2D_38aa29dd5f744ffc8008a01796c8eb28);
        TEXTURE2D(Texture2D_7091a618baa9402e8301a4e786c775b6);
        SAMPLER(samplerTexture2D_7091a618baa9402e8301a4e786c775b6);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }


        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
        }

        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }


        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);

            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            Out = t;
        }

        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);

            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
            
            Axis = normalize(Axis);

            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };

            Out = mul(rot_mat,  In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
            float4 _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0.tex, _Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_R_4 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.r;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_G_5 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.g;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_B_6 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.b;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_A_7 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.a;
            UnityTexture2D _Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
            float4 _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0.tex, _Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_R_4 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.r;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_G_5 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.g;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_B_6 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.b;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_A_7 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.a;
            float4 _UV_497251cb31c6481e80cca4bb7b94376f_Out_0 = IN.uv0;
            float2 _TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3;
            Unity_TilingAndOffset_float((_UV_497251cb31c6481e80cca4bb7b94376f_Out_0.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3);
            float _Property_258198a452454ba6b9eef1cd04acfe16_Out_0 = Rust_Scale;
            float _Float_d37a125732624b89ae34dcf021e0308c_Out_0 = _Property_258198a452454ba6b9eef1cd04acfe16_Out_0;
            float _SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2;
            Unity_SimpleNoise_float(_TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3, _Float_d37a125732624b89ae34dcf021e0308c_Out_0, _SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2);
            float3 _RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3;
            Unity_Rotate_About_Axis_Degrees_float((_UV_497251cb31c6481e80cca4bb7b94376f_Out_0.xyz), float3 (0, 1, 0), 90, _RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3);
            float _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2;
            Unity_SimpleNoise_float((_RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3.xy), _Float_d37a125732624b89ae34dcf021e0308c_Out_0, _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2);
            float _Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2;
            Unity_Add_float(_SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2, _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2, _Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2);
            float _Property_a1108bb44def4b14afd52689ec6bfabf_Out_0 = Rust;
            float _Float_dd492bc0766041c2a282185cb4dccbc8_Out_0 = _Property_a1108bb44def4b14afd52689ec6bfabf_Out_0;
            float _Power_eab0a753bce24cb2996d34d243c481cb_Out_2;
            Unity_Power_float(_Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2, _Float_dd492bc0766041c2a282185cb4dccbc8_Out_0, _Power_eab0a753bce24cb2996d34d243c481cb_Out_2);
            float _Property_6b3e929f388749e3b3fab2bed5cb0731_Out_0 = Rust_Intencity;
            float _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2;
            Unity_Multiply_float(_Power_eab0a753bce24cb2996d34d243c481cb_Out_2, _Property_6b3e929f388749e3b3fab2bed5cb0731_Out_0, _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2);
            float _Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2;
            Unity_Multiply_float(_SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_A_7, _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2, _Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2);
            float4 _Property_f20ca6e8518944c48e0d4fcc9c7fb6a5_Out_0 = IsGammaSpace() ? LinearToSRGB(Rust_Color) : Rust_Color;
            float4 _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2;
            Unity_Multiply_float((_Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2.xxxx), _Property_f20ca6e8518944c48e0d4fcc9c7fb6a5_Out_0, _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2);
            float4 _Add_d93ae8115c7849218693eae74a2d129d_Out_2;
            Unity_Add_float4(_SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0, _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2, _Add_d93ae8115c7849218693eae74a2d129d_Out_2);
            UnityTexture2D _Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_7091a618baa9402e8301a4e786c775b6);
            float4 _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0 = SAMPLE_TEXTURE2D(_Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0.tex, _Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_R_4 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.r;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_G_5 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.g;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_B_6 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.b;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_A_7 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.a;
            float _Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1;
            Unity_Preview_float(_SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_A_7, _Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1);
            float _Property_cef49a576700432f92db05a41dc14fd1_Out_0 = Eyes_Speed;
            float _Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_cef49a576700432f92db05a41dc14fd1_Out_0, _Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2);
            float _Sine_545369abe54e497980f0f72b1dbc2dec_Out_1;
            Unity_Sine_float(_Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2, _Sine_545369abe54e497980f0f72b1dbc2dec_Out_1);
            float _Property_f708f64118f442c489a2966614982120_Out_0 = Eyes_offset;
            float _Add_8acd497f31294e029b88aec1ca0f0e09_Out_2;
            Unity_Add_float(_Sine_545369abe54e497980f0f72b1dbc2dec_Out_1, _Property_f708f64118f442c489a2966614982120_Out_0, _Add_8acd497f31294e029b88aec1ca0f0e09_Out_2);
            float _Property_b8677c32a5ec4d47bce15389900f120d_Out_0 = Eyes_Max;
            float _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3;
            Unity_Clamp_float(_Add_8acd497f31294e029b88aec1ca0f0e09_Out_2, 0, _Property_b8677c32a5ec4d47bce15389900f120d_Out_0, _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3);
            float _Multiply_135816d5742040c186fe330b04806dd9_Out_2;
            Unity_Multiply_float(_Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1, _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3, _Multiply_135816d5742040c186fe330b04806dd9_Out_2);
            float4 _Property_1be18ed7c5c84d13bac1267404542baa_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_Eyes) : Color_Eyes;
            float4 _Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2;
            Unity_Multiply_float((_Multiply_135816d5742040c186fe330b04806dd9_Out_2.xxxx), _Property_1be18ed7c5c84d13bac1267404542baa_Out_0, _Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2);
            float _Property_e5fb9dc44107447ead0dd96d4cff5d90_Out_0 = Eyes_Power;
            float4 _Multiply_4ed7112f60164a73a7842006f86d011e_Out_2;
            Unity_Multiply_float(_Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2, (_Property_e5fb9dc44107447ead0dd96d4cff5d90_Out_0.xxxx), _Multiply_4ed7112f60164a73a7842006f86d011e_Out_2);
            UnityTexture2D _Property_ca1a7d34159a4081a6f975cc7a8a21ec_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
            float4 _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ca1a7d34159a4081a6f975cc7a8a21ec_Out_0.tex, _Property_ca1a7d34159a4081a6f975cc7a8a21ec_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_R_4 = _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0.r;
            float _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_G_5 = _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0.g;
            float _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_B_6 = _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0.b;
            float _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_A_7 = _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0.a;
            float _Property_0ec018267f544b6d831ec3b5f1ba17ff_Out_0 = Metalic;
            float _Multiply_05d048cc6a7c45f8be12eb0e44e42832_Out_2;
            Unity_Multiply_float(_SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_A_7, _Property_0ec018267f544b6d831ec3b5f1ba17ff_Out_0, _Multiply_05d048cc6a7c45f8be12eb0e44e42832_Out_2);
            float _Multiply_03e2d29dbc834842be84fe4162228ecd_Out_2;
            Unity_Multiply_float(_Multiply_05d048cc6a7c45f8be12eb0e44e42832_Out_2, 2, _Multiply_03e2d29dbc834842be84fe4162228ecd_Out_2);
            float _Property_e4de700dff3a4c619a61110d27c933d0_Out_0 = Smoothness;
            float _Multiply_7d89f2a5bb0e4eb08fa6fca51edeb1ec_Out_2;
            Unity_Multiply_float(_SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_A_7, _Property_e4de700dff3a4c619a61110d27c933d0_Out_0, _Multiply_7d89f2a5bb0e4eb08fa6fca51edeb1ec_Out_2);
            float _Multiply_bdd509d791b84f6c80ec4642b636b13d_Out_2;
            Unity_Multiply_float(0, _Multiply_7d89f2a5bb0e4eb08fa6fca51edeb1ec_Out_2, _Multiply_bdd509d791b84f6c80ec4642b636b13d_Out_2);
            surface.BaseColor = (_Add_d93ae8115c7849218693eae74a2d129d_Out_2.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_4ed7112f60164a73a7842006f86d011e_Out_2.xyz);
            surface.Metallic = _Multiply_03e2d29dbc834842be84fe4162228ecd_Out_2;
            surface.Smoothness = _Multiply_bdd509d791b84f6c80ec4642b636b13d_Out_2;
            surface.Occlusion = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



            output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


            output.uv0 =                         input.texCoord0;
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile _ _GBUFFER_NORMALS_OCT
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_GBUFFER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            float3 normalWS;
            float4 tangentWS;
            float4 texCoord0;
            float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            float3 sh;
            #endif
            float4 fogFactorAndVertexLight;
            float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 TangentSpaceNormal;
            float4 uv0;
            float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            float3 interp1 : TEXCOORD1;
            float4 interp2 : TEXCOORD2;
            float4 interp3 : TEXCOORD3;
            float3 interp4 : TEXCOORD4;
            #if defined(LIGHTMAP_ON)
            float2 interp5 : TEXCOORD5;
            #endif
            #if !defined(LIGHTMAP_ON)
            float3 interp6 : TEXCOORD6;
            #endif
            float4 interp7 : TEXCOORD7;
            float4 interp8 : TEXCOORD8;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float Metalic;
        float Smoothness;
        float Rust;
        float Rust_Scale;
        float Rust_Intencity;
        float4 Rust_Color;
        float4 Color_Eyes;
        float Eyes_offset;
        float Eyes_Speed;
        float Eyes_Max;
        float Eyes_Power;
        float4 _Color;
        float4 Texture2D_797d926dfbae4e41bdbd471e33d7993e_TexelSize;
        float4 Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97_TexelSize;
        float4 Texture2D_38aa29dd5f744ffc8008a01796c8eb28_TexelSize;
        float4 Texture2D_7091a618baa9402e8301a4e786c775b6_TexelSize;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
        SAMPLER(samplerTexture2D_797d926dfbae4e41bdbd471e33d7993e);
        TEXTURE2D(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        SAMPLER(samplerTexture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        TEXTURE2D(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
        SAMPLER(samplerTexture2D_38aa29dd5f744ffc8008a01796c8eb28);
        TEXTURE2D(Texture2D_7091a618baa9402e8301a4e786c775b6);
        SAMPLER(samplerTexture2D_7091a618baa9402e8301a4e786c775b6);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }


        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
        }

        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }


        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);

            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            Out = t;
        }

        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);

            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
            
            Axis = normalize(Axis);

            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };

            Out = mul(rot_mat,  In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
            float4 _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0.tex, _Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_R_4 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.r;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_G_5 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.g;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_B_6 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.b;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_A_7 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.a;
            UnityTexture2D _Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
            float4 _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0.tex, _Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_R_4 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.r;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_G_5 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.g;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_B_6 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.b;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_A_7 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.a;
            float4 _UV_497251cb31c6481e80cca4bb7b94376f_Out_0 = IN.uv0;
            float2 _TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3;
            Unity_TilingAndOffset_float((_UV_497251cb31c6481e80cca4bb7b94376f_Out_0.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3);
            float _Property_258198a452454ba6b9eef1cd04acfe16_Out_0 = Rust_Scale;
            float _Float_d37a125732624b89ae34dcf021e0308c_Out_0 = _Property_258198a452454ba6b9eef1cd04acfe16_Out_0;
            float _SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2;
            Unity_SimpleNoise_float(_TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3, _Float_d37a125732624b89ae34dcf021e0308c_Out_0, _SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2);
            float3 _RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3;
            Unity_Rotate_About_Axis_Degrees_float((_UV_497251cb31c6481e80cca4bb7b94376f_Out_0.xyz), float3 (0, 1, 0), 90, _RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3);
            float _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2;
            Unity_SimpleNoise_float((_RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3.xy), _Float_d37a125732624b89ae34dcf021e0308c_Out_0, _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2);
            float _Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2;
            Unity_Add_float(_SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2, _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2, _Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2);
            float _Property_a1108bb44def4b14afd52689ec6bfabf_Out_0 = Rust;
            float _Float_dd492bc0766041c2a282185cb4dccbc8_Out_0 = _Property_a1108bb44def4b14afd52689ec6bfabf_Out_0;
            float _Power_eab0a753bce24cb2996d34d243c481cb_Out_2;
            Unity_Power_float(_Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2, _Float_dd492bc0766041c2a282185cb4dccbc8_Out_0, _Power_eab0a753bce24cb2996d34d243c481cb_Out_2);
            float _Property_6b3e929f388749e3b3fab2bed5cb0731_Out_0 = Rust_Intencity;
            float _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2;
            Unity_Multiply_float(_Power_eab0a753bce24cb2996d34d243c481cb_Out_2, _Property_6b3e929f388749e3b3fab2bed5cb0731_Out_0, _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2);
            float _Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2;
            Unity_Multiply_float(_SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_A_7, _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2, _Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2);
            float4 _Property_f20ca6e8518944c48e0d4fcc9c7fb6a5_Out_0 = IsGammaSpace() ? LinearToSRGB(Rust_Color) : Rust_Color;
            float4 _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2;
            Unity_Multiply_float((_Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2.xxxx), _Property_f20ca6e8518944c48e0d4fcc9c7fb6a5_Out_0, _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2);
            float4 _Add_d93ae8115c7849218693eae74a2d129d_Out_2;
            Unity_Add_float4(_SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0, _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2, _Add_d93ae8115c7849218693eae74a2d129d_Out_2);
            UnityTexture2D _Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_7091a618baa9402e8301a4e786c775b6);
            float4 _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0 = SAMPLE_TEXTURE2D(_Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0.tex, _Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_R_4 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.r;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_G_5 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.g;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_B_6 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.b;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_A_7 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.a;
            float _Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1;
            Unity_Preview_float(_SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_A_7, _Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1);
            float _Property_cef49a576700432f92db05a41dc14fd1_Out_0 = Eyes_Speed;
            float _Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_cef49a576700432f92db05a41dc14fd1_Out_0, _Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2);
            float _Sine_545369abe54e497980f0f72b1dbc2dec_Out_1;
            Unity_Sine_float(_Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2, _Sine_545369abe54e497980f0f72b1dbc2dec_Out_1);
            float _Property_f708f64118f442c489a2966614982120_Out_0 = Eyes_offset;
            float _Add_8acd497f31294e029b88aec1ca0f0e09_Out_2;
            Unity_Add_float(_Sine_545369abe54e497980f0f72b1dbc2dec_Out_1, _Property_f708f64118f442c489a2966614982120_Out_0, _Add_8acd497f31294e029b88aec1ca0f0e09_Out_2);
            float _Property_b8677c32a5ec4d47bce15389900f120d_Out_0 = Eyes_Max;
            float _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3;
            Unity_Clamp_float(_Add_8acd497f31294e029b88aec1ca0f0e09_Out_2, 0, _Property_b8677c32a5ec4d47bce15389900f120d_Out_0, _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3);
            float _Multiply_135816d5742040c186fe330b04806dd9_Out_2;
            Unity_Multiply_float(_Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1, _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3, _Multiply_135816d5742040c186fe330b04806dd9_Out_2);
            float4 _Property_1be18ed7c5c84d13bac1267404542baa_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_Eyes) : Color_Eyes;
            float4 _Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2;
            Unity_Multiply_float((_Multiply_135816d5742040c186fe330b04806dd9_Out_2.xxxx), _Property_1be18ed7c5c84d13bac1267404542baa_Out_0, _Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2);
            float _Property_e5fb9dc44107447ead0dd96d4cff5d90_Out_0 = Eyes_Power;
            float4 _Multiply_4ed7112f60164a73a7842006f86d011e_Out_2;
            Unity_Multiply_float(_Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2, (_Property_e5fb9dc44107447ead0dd96d4cff5d90_Out_0.xxxx), _Multiply_4ed7112f60164a73a7842006f86d011e_Out_2);
            UnityTexture2D _Property_ca1a7d34159a4081a6f975cc7a8a21ec_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
            float4 _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ca1a7d34159a4081a6f975cc7a8a21ec_Out_0.tex, _Property_ca1a7d34159a4081a6f975cc7a8a21ec_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_R_4 = _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0.r;
            float _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_G_5 = _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0.g;
            float _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_B_6 = _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0.b;
            float _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_A_7 = _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0.a;
            float _Property_0ec018267f544b6d831ec3b5f1ba17ff_Out_0 = Metalic;
            float _Multiply_05d048cc6a7c45f8be12eb0e44e42832_Out_2;
            Unity_Multiply_float(_SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_A_7, _Property_0ec018267f544b6d831ec3b5f1ba17ff_Out_0, _Multiply_05d048cc6a7c45f8be12eb0e44e42832_Out_2);
            float _Multiply_03e2d29dbc834842be84fe4162228ecd_Out_2;
            Unity_Multiply_float(_Multiply_05d048cc6a7c45f8be12eb0e44e42832_Out_2, 2, _Multiply_03e2d29dbc834842be84fe4162228ecd_Out_2);
            float _Property_e4de700dff3a4c619a61110d27c933d0_Out_0 = Smoothness;
            float _Multiply_7d89f2a5bb0e4eb08fa6fca51edeb1ec_Out_2;
            Unity_Multiply_float(_SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_A_7, _Property_e4de700dff3a4c619a61110d27c933d0_Out_0, _Multiply_7d89f2a5bb0e4eb08fa6fca51edeb1ec_Out_2);
            float _Multiply_bdd509d791b84f6c80ec4642b636b13d_Out_2;
            Unity_Multiply_float(0, _Multiply_7d89f2a5bb0e4eb08fa6fca51edeb1ec_Out_2, _Multiply_bdd509d791b84f6c80ec4642b636b13d_Out_2);
            surface.BaseColor = (_Add_d93ae8115c7849218693eae74a2d129d_Out_2.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_4ed7112f60164a73a7842006f86d011e_Out_2.xyz);
            surface.Metallic = _Multiply_03e2d29dbc834842be84fe4162228ecd_Out_2;
            surface.Smoothness = _Multiply_bdd509d791b84f6c80ec4642b636b13d_Out_2;
            surface.Occlusion = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



            output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


            output.uv0 =                         input.texCoord0;
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float Metalic;
        float Smoothness;
        float Rust;
        float Rust_Scale;
        float Rust_Intencity;
        float4 Rust_Color;
        float4 Color_Eyes;
        float Eyes_offset;
        float Eyes_Speed;
        float Eyes_Max;
        float Eyes_Power;
        float4 _Color;
        float4 Texture2D_797d926dfbae4e41bdbd471e33d7993e_TexelSize;
        float4 Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97_TexelSize;
        float4 Texture2D_38aa29dd5f744ffc8008a01796c8eb28_TexelSize;
        float4 Texture2D_7091a618baa9402e8301a4e786c775b6_TexelSize;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
        SAMPLER(samplerTexture2D_797d926dfbae4e41bdbd471e33d7993e);
        TEXTURE2D(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        SAMPLER(samplerTexture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        TEXTURE2D(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
        SAMPLER(samplerTexture2D_38aa29dd5f744ffc8008a01796c8eb28);
        TEXTURE2D(Texture2D_7091a618baa9402e8301a4e786c775b6);
        SAMPLER(samplerTexture2D_7091a618baa9402e8301a4e786c775b6);

            // Graph Functions
            // GraphFunctions: <None>

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float Metalic;
        float Smoothness;
        float Rust;
        float Rust_Scale;
        float Rust_Intencity;
        float4 Rust_Color;
        float4 Color_Eyes;
        float Eyes_offset;
        float Eyes_Speed;
        float Eyes_Max;
        float Eyes_Power;
        float4 _Color;
        float4 Texture2D_797d926dfbae4e41bdbd471e33d7993e_TexelSize;
        float4 Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97_TexelSize;
        float4 Texture2D_38aa29dd5f744ffc8008a01796c8eb28_TexelSize;
        float4 Texture2D_7091a618baa9402e8301a4e786c775b6_TexelSize;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
        SAMPLER(samplerTexture2D_797d926dfbae4e41bdbd471e33d7993e);
        TEXTURE2D(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        SAMPLER(samplerTexture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        TEXTURE2D(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
        SAMPLER(samplerTexture2D_38aa29dd5f744ffc8008a01796c8eb28);
        TEXTURE2D(Texture2D_7091a618baa9402e8301a4e786c775b6);
        SAMPLER(samplerTexture2D_7091a618baa9402e8301a4e786c775b6);

            // Graph Functions
            // GraphFunctions: <None>

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 normalWS;
            float4 tangentWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 TangentSpaceNormal;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            float4 interp1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.tangentWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.tangentWS = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float Metalic;
        float Smoothness;
        float Rust;
        float Rust_Scale;
        float Rust_Intencity;
        float4 Rust_Color;
        float4 Color_Eyes;
        float Eyes_offset;
        float Eyes_Speed;
        float Eyes_Max;
        float Eyes_Power;
        float4 _Color;
        float4 Texture2D_797d926dfbae4e41bdbd471e33d7993e_TexelSize;
        float4 Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97_TexelSize;
        float4 Texture2D_38aa29dd5f744ffc8008a01796c8eb28_TexelSize;
        float4 Texture2D_7091a618baa9402e8301a4e786c775b6_TexelSize;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
        SAMPLER(samplerTexture2D_797d926dfbae4e41bdbd471e33d7993e);
        TEXTURE2D(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        SAMPLER(samplerTexture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        TEXTURE2D(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
        SAMPLER(samplerTexture2D_38aa29dd5f744ffc8008a01796c8eb28);
        TEXTURE2D(Texture2D_7091a618baa9402e8301a4e786c775b6);
        SAMPLER(samplerTexture2D_7091a618baa9402e8301a4e786c775b6);

            // Graph Functions
            // GraphFunctions: <None>

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 NormalTS;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            surface.NormalTS = IN.TangentSpaceNormal;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



            output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }

            // Render State
            Cull Off

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_META
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 uv1 : TEXCOORD1;
            float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float4 uv0;
            float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float4 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float Metalic;
        float Smoothness;
        float Rust;
        float Rust_Scale;
        float Rust_Intencity;
        float4 Rust_Color;
        float4 Color_Eyes;
        float Eyes_offset;
        float Eyes_Speed;
        float Eyes_Max;
        float Eyes_Power;
        float4 _Color;
        float4 Texture2D_797d926dfbae4e41bdbd471e33d7993e_TexelSize;
        float4 Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97_TexelSize;
        float4 Texture2D_38aa29dd5f744ffc8008a01796c8eb28_TexelSize;
        float4 Texture2D_7091a618baa9402e8301a4e786c775b6_TexelSize;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
        SAMPLER(samplerTexture2D_797d926dfbae4e41bdbd471e33d7993e);
        TEXTURE2D(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        SAMPLER(samplerTexture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        TEXTURE2D(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
        SAMPLER(samplerTexture2D_38aa29dd5f744ffc8008a01796c8eb28);
        TEXTURE2D(Texture2D_7091a618baa9402e8301a4e786c775b6);
        SAMPLER(samplerTexture2D_7091a618baa9402e8301a4e786c775b6);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }


        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
        }

        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }


        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);

            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            Out = t;
        }

        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);

            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
            
            Axis = normalize(Axis);

            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };

            Out = mul(rot_mat,  In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
            float4 _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0.tex, _Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_R_4 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.r;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_G_5 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.g;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_B_6 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.b;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_A_7 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.a;
            UnityTexture2D _Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
            float4 _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0.tex, _Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_R_4 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.r;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_G_5 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.g;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_B_6 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.b;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_A_7 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.a;
            float4 _UV_497251cb31c6481e80cca4bb7b94376f_Out_0 = IN.uv0;
            float2 _TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3;
            Unity_TilingAndOffset_float((_UV_497251cb31c6481e80cca4bb7b94376f_Out_0.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3);
            float _Property_258198a452454ba6b9eef1cd04acfe16_Out_0 = Rust_Scale;
            float _Float_d37a125732624b89ae34dcf021e0308c_Out_0 = _Property_258198a452454ba6b9eef1cd04acfe16_Out_0;
            float _SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2;
            Unity_SimpleNoise_float(_TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3, _Float_d37a125732624b89ae34dcf021e0308c_Out_0, _SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2);
            float3 _RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3;
            Unity_Rotate_About_Axis_Degrees_float((_UV_497251cb31c6481e80cca4bb7b94376f_Out_0.xyz), float3 (0, 1, 0), 90, _RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3);
            float _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2;
            Unity_SimpleNoise_float((_RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3.xy), _Float_d37a125732624b89ae34dcf021e0308c_Out_0, _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2);
            float _Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2;
            Unity_Add_float(_SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2, _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2, _Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2);
            float _Property_a1108bb44def4b14afd52689ec6bfabf_Out_0 = Rust;
            float _Float_dd492bc0766041c2a282185cb4dccbc8_Out_0 = _Property_a1108bb44def4b14afd52689ec6bfabf_Out_0;
            float _Power_eab0a753bce24cb2996d34d243c481cb_Out_2;
            Unity_Power_float(_Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2, _Float_dd492bc0766041c2a282185cb4dccbc8_Out_0, _Power_eab0a753bce24cb2996d34d243c481cb_Out_2);
            float _Property_6b3e929f388749e3b3fab2bed5cb0731_Out_0 = Rust_Intencity;
            float _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2;
            Unity_Multiply_float(_Power_eab0a753bce24cb2996d34d243c481cb_Out_2, _Property_6b3e929f388749e3b3fab2bed5cb0731_Out_0, _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2);
            float _Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2;
            Unity_Multiply_float(_SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_A_7, _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2, _Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2);
            float4 _Property_f20ca6e8518944c48e0d4fcc9c7fb6a5_Out_0 = IsGammaSpace() ? LinearToSRGB(Rust_Color) : Rust_Color;
            float4 _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2;
            Unity_Multiply_float((_Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2.xxxx), _Property_f20ca6e8518944c48e0d4fcc9c7fb6a5_Out_0, _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2);
            float4 _Add_d93ae8115c7849218693eae74a2d129d_Out_2;
            Unity_Add_float4(_SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0, _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2, _Add_d93ae8115c7849218693eae74a2d129d_Out_2);
            UnityTexture2D _Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_7091a618baa9402e8301a4e786c775b6);
            float4 _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0 = SAMPLE_TEXTURE2D(_Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0.tex, _Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_R_4 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.r;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_G_5 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.g;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_B_6 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.b;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_A_7 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.a;
            float _Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1;
            Unity_Preview_float(_SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_A_7, _Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1);
            float _Property_cef49a576700432f92db05a41dc14fd1_Out_0 = Eyes_Speed;
            float _Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_cef49a576700432f92db05a41dc14fd1_Out_0, _Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2);
            float _Sine_545369abe54e497980f0f72b1dbc2dec_Out_1;
            Unity_Sine_float(_Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2, _Sine_545369abe54e497980f0f72b1dbc2dec_Out_1);
            float _Property_f708f64118f442c489a2966614982120_Out_0 = Eyes_offset;
            float _Add_8acd497f31294e029b88aec1ca0f0e09_Out_2;
            Unity_Add_float(_Sine_545369abe54e497980f0f72b1dbc2dec_Out_1, _Property_f708f64118f442c489a2966614982120_Out_0, _Add_8acd497f31294e029b88aec1ca0f0e09_Out_2);
            float _Property_b8677c32a5ec4d47bce15389900f120d_Out_0 = Eyes_Max;
            float _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3;
            Unity_Clamp_float(_Add_8acd497f31294e029b88aec1ca0f0e09_Out_2, 0, _Property_b8677c32a5ec4d47bce15389900f120d_Out_0, _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3);
            float _Multiply_135816d5742040c186fe330b04806dd9_Out_2;
            Unity_Multiply_float(_Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1, _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3, _Multiply_135816d5742040c186fe330b04806dd9_Out_2);
            float4 _Property_1be18ed7c5c84d13bac1267404542baa_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_Eyes) : Color_Eyes;
            float4 _Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2;
            Unity_Multiply_float((_Multiply_135816d5742040c186fe330b04806dd9_Out_2.xxxx), _Property_1be18ed7c5c84d13bac1267404542baa_Out_0, _Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2);
            float _Property_e5fb9dc44107447ead0dd96d4cff5d90_Out_0 = Eyes_Power;
            float4 _Multiply_4ed7112f60164a73a7842006f86d011e_Out_2;
            Unity_Multiply_float(_Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2, (_Property_e5fb9dc44107447ead0dd96d4cff5d90_Out_0.xxxx), _Multiply_4ed7112f60164a73a7842006f86d011e_Out_2);
            surface.BaseColor = (_Add_d93ae8115c7849218693eae74a2d129d_Out_2.xyz);
            surface.Emission = (_Multiply_4ed7112f60164a73a7842006f86d011e_Out_2.xyz);
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_2D
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float4 uv0;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float4 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float Metalic;
        float Smoothness;
        float Rust;
        float Rust_Scale;
        float Rust_Intencity;
        float4 Rust_Color;
        float4 Color_Eyes;
        float Eyes_offset;
        float Eyes_Speed;
        float Eyes_Max;
        float Eyes_Power;
        float4 _Color;
        float4 Texture2D_797d926dfbae4e41bdbd471e33d7993e_TexelSize;
        float4 Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97_TexelSize;
        float4 Texture2D_38aa29dd5f744ffc8008a01796c8eb28_TexelSize;
        float4 Texture2D_7091a618baa9402e8301a4e786c775b6_TexelSize;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
        SAMPLER(samplerTexture2D_797d926dfbae4e41bdbd471e33d7993e);
        TEXTURE2D(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        SAMPLER(samplerTexture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        TEXTURE2D(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
        SAMPLER(samplerTexture2D_38aa29dd5f744ffc8008a01796c8eb28);
        TEXTURE2D(Texture2D_7091a618baa9402e8301a4e786c775b6);
        SAMPLER(samplerTexture2D_7091a618baa9402e8301a4e786c775b6);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }


        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
        }

        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }


        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);

            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            Out = t;
        }

        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);

            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
            
            Axis = normalize(Axis);

            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };

            Out = mul(rot_mat,  In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
            float4 _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0.tex, _Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_R_4 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.r;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_G_5 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.g;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_B_6 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.b;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_A_7 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.a;
            UnityTexture2D _Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
            float4 _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0.tex, _Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_R_4 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.r;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_G_5 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.g;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_B_6 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.b;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_A_7 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.a;
            float4 _UV_497251cb31c6481e80cca4bb7b94376f_Out_0 = IN.uv0;
            float2 _TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3;
            Unity_TilingAndOffset_float((_UV_497251cb31c6481e80cca4bb7b94376f_Out_0.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3);
            float _Property_258198a452454ba6b9eef1cd04acfe16_Out_0 = Rust_Scale;
            float _Float_d37a125732624b89ae34dcf021e0308c_Out_0 = _Property_258198a452454ba6b9eef1cd04acfe16_Out_0;
            float _SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2;
            Unity_SimpleNoise_float(_TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3, _Float_d37a125732624b89ae34dcf021e0308c_Out_0, _SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2);
            float3 _RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3;
            Unity_Rotate_About_Axis_Degrees_float((_UV_497251cb31c6481e80cca4bb7b94376f_Out_0.xyz), float3 (0, 1, 0), 90, _RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3);
            float _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2;
            Unity_SimpleNoise_float((_RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3.xy), _Float_d37a125732624b89ae34dcf021e0308c_Out_0, _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2);
            float _Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2;
            Unity_Add_float(_SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2, _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2, _Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2);
            float _Property_a1108bb44def4b14afd52689ec6bfabf_Out_0 = Rust;
            float _Float_dd492bc0766041c2a282185cb4dccbc8_Out_0 = _Property_a1108bb44def4b14afd52689ec6bfabf_Out_0;
            float _Power_eab0a753bce24cb2996d34d243c481cb_Out_2;
            Unity_Power_float(_Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2, _Float_dd492bc0766041c2a282185cb4dccbc8_Out_0, _Power_eab0a753bce24cb2996d34d243c481cb_Out_2);
            float _Property_6b3e929f388749e3b3fab2bed5cb0731_Out_0 = Rust_Intencity;
            float _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2;
            Unity_Multiply_float(_Power_eab0a753bce24cb2996d34d243c481cb_Out_2, _Property_6b3e929f388749e3b3fab2bed5cb0731_Out_0, _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2);
            float _Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2;
            Unity_Multiply_float(_SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_A_7, _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2, _Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2);
            float4 _Property_f20ca6e8518944c48e0d4fcc9c7fb6a5_Out_0 = IsGammaSpace() ? LinearToSRGB(Rust_Color) : Rust_Color;
            float4 _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2;
            Unity_Multiply_float((_Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2.xxxx), _Property_f20ca6e8518944c48e0d4fcc9c7fb6a5_Out_0, _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2);
            float4 _Add_d93ae8115c7849218693eae74a2d129d_Out_2;
            Unity_Add_float4(_SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0, _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2, _Add_d93ae8115c7849218693eae74a2d129d_Out_2);
            surface.BaseColor = (_Add_d93ae8115c7849218693eae74a2d129d_Out_2.xyz);
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

            ENDHLSL
        }
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="Geometry"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_FORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            float3 normalWS;
            float4 tangentWS;
            float4 texCoord0;
            float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            float3 sh;
            #endif
            float4 fogFactorAndVertexLight;
            float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 TangentSpaceNormal;
            float4 uv0;
            float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            float3 interp1 : TEXCOORD1;
            float4 interp2 : TEXCOORD2;
            float4 interp3 : TEXCOORD3;
            float3 interp4 : TEXCOORD4;
            #if defined(LIGHTMAP_ON)
            float2 interp5 : TEXCOORD5;
            #endif
            #if !defined(LIGHTMAP_ON)
            float3 interp6 : TEXCOORD6;
            #endif
            float4 interp7 : TEXCOORD7;
            float4 interp8 : TEXCOORD8;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float Metalic;
        float Smoothness;
        float Rust;
        float Rust_Scale;
        float Rust_Intencity;
        float4 Rust_Color;
        float4 Color_Eyes;
        float Eyes_offset;
        float Eyes_Speed;
        float Eyes_Max;
        float Eyes_Power;
        float4 _Color;
        float4 Texture2D_797d926dfbae4e41bdbd471e33d7993e_TexelSize;
        float4 Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97_TexelSize;
        float4 Texture2D_38aa29dd5f744ffc8008a01796c8eb28_TexelSize;
        float4 Texture2D_7091a618baa9402e8301a4e786c775b6_TexelSize;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
        SAMPLER(samplerTexture2D_797d926dfbae4e41bdbd471e33d7993e);
        TEXTURE2D(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        SAMPLER(samplerTexture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        TEXTURE2D(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
        SAMPLER(samplerTexture2D_38aa29dd5f744ffc8008a01796c8eb28);
        TEXTURE2D(Texture2D_7091a618baa9402e8301a4e786c775b6);
        SAMPLER(samplerTexture2D_7091a618baa9402e8301a4e786c775b6);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }


        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
        }

        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }


        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);

            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            Out = t;
        }

        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);

            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
            
            Axis = normalize(Axis);

            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };

            Out = mul(rot_mat,  In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
            float4 _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0.tex, _Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_R_4 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.r;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_G_5 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.g;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_B_6 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.b;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_A_7 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.a;
            UnityTexture2D _Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
            float4 _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0.tex, _Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_R_4 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.r;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_G_5 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.g;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_B_6 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.b;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_A_7 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.a;
            float4 _UV_497251cb31c6481e80cca4bb7b94376f_Out_0 = IN.uv0;
            float2 _TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3;
            Unity_TilingAndOffset_float((_UV_497251cb31c6481e80cca4bb7b94376f_Out_0.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3);
            float _Property_258198a452454ba6b9eef1cd04acfe16_Out_0 = Rust_Scale;
            float _Float_d37a125732624b89ae34dcf021e0308c_Out_0 = _Property_258198a452454ba6b9eef1cd04acfe16_Out_0;
            float _SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2;
            Unity_SimpleNoise_float(_TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3, _Float_d37a125732624b89ae34dcf021e0308c_Out_0, _SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2);
            float3 _RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3;
            Unity_Rotate_About_Axis_Degrees_float((_UV_497251cb31c6481e80cca4bb7b94376f_Out_0.xyz), float3 (0, 1, 0), 90, _RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3);
            float _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2;
            Unity_SimpleNoise_float((_RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3.xy), _Float_d37a125732624b89ae34dcf021e0308c_Out_0, _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2);
            float _Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2;
            Unity_Add_float(_SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2, _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2, _Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2);
            float _Property_a1108bb44def4b14afd52689ec6bfabf_Out_0 = Rust;
            float _Float_dd492bc0766041c2a282185cb4dccbc8_Out_0 = _Property_a1108bb44def4b14afd52689ec6bfabf_Out_0;
            float _Power_eab0a753bce24cb2996d34d243c481cb_Out_2;
            Unity_Power_float(_Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2, _Float_dd492bc0766041c2a282185cb4dccbc8_Out_0, _Power_eab0a753bce24cb2996d34d243c481cb_Out_2);
            float _Property_6b3e929f388749e3b3fab2bed5cb0731_Out_0 = Rust_Intencity;
            float _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2;
            Unity_Multiply_float(_Power_eab0a753bce24cb2996d34d243c481cb_Out_2, _Property_6b3e929f388749e3b3fab2bed5cb0731_Out_0, _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2);
            float _Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2;
            Unity_Multiply_float(_SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_A_7, _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2, _Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2);
            float4 _Property_f20ca6e8518944c48e0d4fcc9c7fb6a5_Out_0 = IsGammaSpace() ? LinearToSRGB(Rust_Color) : Rust_Color;
            float4 _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2;
            Unity_Multiply_float((_Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2.xxxx), _Property_f20ca6e8518944c48e0d4fcc9c7fb6a5_Out_0, _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2);
            float4 _Add_d93ae8115c7849218693eae74a2d129d_Out_2;
            Unity_Add_float4(_SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0, _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2, _Add_d93ae8115c7849218693eae74a2d129d_Out_2);
            UnityTexture2D _Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_7091a618baa9402e8301a4e786c775b6);
            float4 _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0 = SAMPLE_TEXTURE2D(_Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0.tex, _Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_R_4 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.r;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_G_5 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.g;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_B_6 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.b;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_A_7 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.a;
            float _Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1;
            Unity_Preview_float(_SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_A_7, _Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1);
            float _Property_cef49a576700432f92db05a41dc14fd1_Out_0 = Eyes_Speed;
            float _Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_cef49a576700432f92db05a41dc14fd1_Out_0, _Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2);
            float _Sine_545369abe54e497980f0f72b1dbc2dec_Out_1;
            Unity_Sine_float(_Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2, _Sine_545369abe54e497980f0f72b1dbc2dec_Out_1);
            float _Property_f708f64118f442c489a2966614982120_Out_0 = Eyes_offset;
            float _Add_8acd497f31294e029b88aec1ca0f0e09_Out_2;
            Unity_Add_float(_Sine_545369abe54e497980f0f72b1dbc2dec_Out_1, _Property_f708f64118f442c489a2966614982120_Out_0, _Add_8acd497f31294e029b88aec1ca0f0e09_Out_2);
            float _Property_b8677c32a5ec4d47bce15389900f120d_Out_0 = Eyes_Max;
            float _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3;
            Unity_Clamp_float(_Add_8acd497f31294e029b88aec1ca0f0e09_Out_2, 0, _Property_b8677c32a5ec4d47bce15389900f120d_Out_0, _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3);
            float _Multiply_135816d5742040c186fe330b04806dd9_Out_2;
            Unity_Multiply_float(_Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1, _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3, _Multiply_135816d5742040c186fe330b04806dd9_Out_2);
            float4 _Property_1be18ed7c5c84d13bac1267404542baa_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_Eyes) : Color_Eyes;
            float4 _Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2;
            Unity_Multiply_float((_Multiply_135816d5742040c186fe330b04806dd9_Out_2.xxxx), _Property_1be18ed7c5c84d13bac1267404542baa_Out_0, _Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2);
            float _Property_e5fb9dc44107447ead0dd96d4cff5d90_Out_0 = Eyes_Power;
            float4 _Multiply_4ed7112f60164a73a7842006f86d011e_Out_2;
            Unity_Multiply_float(_Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2, (_Property_e5fb9dc44107447ead0dd96d4cff5d90_Out_0.xxxx), _Multiply_4ed7112f60164a73a7842006f86d011e_Out_2);
            UnityTexture2D _Property_ca1a7d34159a4081a6f975cc7a8a21ec_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
            float4 _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ca1a7d34159a4081a6f975cc7a8a21ec_Out_0.tex, _Property_ca1a7d34159a4081a6f975cc7a8a21ec_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_R_4 = _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0.r;
            float _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_G_5 = _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0.g;
            float _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_B_6 = _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0.b;
            float _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_A_7 = _SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_RGBA_0.a;
            float _Property_0ec018267f544b6d831ec3b5f1ba17ff_Out_0 = Metalic;
            float _Multiply_05d048cc6a7c45f8be12eb0e44e42832_Out_2;
            Unity_Multiply_float(_SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_A_7, _Property_0ec018267f544b6d831ec3b5f1ba17ff_Out_0, _Multiply_05d048cc6a7c45f8be12eb0e44e42832_Out_2);
            float _Multiply_03e2d29dbc834842be84fe4162228ecd_Out_2;
            Unity_Multiply_float(_Multiply_05d048cc6a7c45f8be12eb0e44e42832_Out_2, 2, _Multiply_03e2d29dbc834842be84fe4162228ecd_Out_2);
            float _Property_e4de700dff3a4c619a61110d27c933d0_Out_0 = Smoothness;
            float _Multiply_7d89f2a5bb0e4eb08fa6fca51edeb1ec_Out_2;
            Unity_Multiply_float(_SampleTexture2D_b0a5e19bb6e54f5fbea0781fa811ee89_A_7, _Property_e4de700dff3a4c619a61110d27c933d0_Out_0, _Multiply_7d89f2a5bb0e4eb08fa6fca51edeb1ec_Out_2);
            float _Multiply_bdd509d791b84f6c80ec4642b636b13d_Out_2;
            Unity_Multiply_float(0, _Multiply_7d89f2a5bb0e4eb08fa6fca51edeb1ec_Out_2, _Multiply_bdd509d791b84f6c80ec4642b636b13d_Out_2);
            surface.BaseColor = (_Add_d93ae8115c7849218693eae74a2d129d_Out_2.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_4ed7112f60164a73a7842006f86d011e_Out_2.xyz);
            surface.Metallic = _Multiply_03e2d29dbc834842be84fe4162228ecd_Out_2;
            surface.Smoothness = _Multiply_bdd509d791b84f6c80ec4642b636b13d_Out_2;
            surface.Occlusion = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



            output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


            output.uv0 =                         input.texCoord0;
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float Metalic;
        float Smoothness;
        float Rust;
        float Rust_Scale;
        float Rust_Intencity;
        float4 Rust_Color;
        float4 Color_Eyes;
        float Eyes_offset;
        float Eyes_Speed;
        float Eyes_Max;
        float Eyes_Power;
        float4 _Color;
        float4 Texture2D_797d926dfbae4e41bdbd471e33d7993e_TexelSize;
        float4 Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97_TexelSize;
        float4 Texture2D_38aa29dd5f744ffc8008a01796c8eb28_TexelSize;
        float4 Texture2D_7091a618baa9402e8301a4e786c775b6_TexelSize;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
        SAMPLER(samplerTexture2D_797d926dfbae4e41bdbd471e33d7993e);
        TEXTURE2D(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        SAMPLER(samplerTexture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        TEXTURE2D(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
        SAMPLER(samplerTexture2D_38aa29dd5f744ffc8008a01796c8eb28);
        TEXTURE2D(Texture2D_7091a618baa9402e8301a4e786c775b6);
        SAMPLER(samplerTexture2D_7091a618baa9402e8301a4e786c775b6);

            // Graph Functions
            // GraphFunctions: <None>

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float Metalic;
        float Smoothness;
        float Rust;
        float Rust_Scale;
        float Rust_Intencity;
        float4 Rust_Color;
        float4 Color_Eyes;
        float Eyes_offset;
        float Eyes_Speed;
        float Eyes_Max;
        float Eyes_Power;
        float4 _Color;
        float4 Texture2D_797d926dfbae4e41bdbd471e33d7993e_TexelSize;
        float4 Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97_TexelSize;
        float4 Texture2D_38aa29dd5f744ffc8008a01796c8eb28_TexelSize;
        float4 Texture2D_7091a618baa9402e8301a4e786c775b6_TexelSize;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
        SAMPLER(samplerTexture2D_797d926dfbae4e41bdbd471e33d7993e);
        TEXTURE2D(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        SAMPLER(samplerTexture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        TEXTURE2D(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
        SAMPLER(samplerTexture2D_38aa29dd5f744ffc8008a01796c8eb28);
        TEXTURE2D(Texture2D_7091a618baa9402e8301a4e786c775b6);
        SAMPLER(samplerTexture2D_7091a618baa9402e8301a4e786c775b6);

            // Graph Functions
            // GraphFunctions: <None>

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 normalWS;
            float4 tangentWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 TangentSpaceNormal;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            float4 interp1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.tangentWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.tangentWS = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float Metalic;
        float Smoothness;
        float Rust;
        float Rust_Scale;
        float Rust_Intencity;
        float4 Rust_Color;
        float4 Color_Eyes;
        float Eyes_offset;
        float Eyes_Speed;
        float Eyes_Max;
        float Eyes_Power;
        float4 _Color;
        float4 Texture2D_797d926dfbae4e41bdbd471e33d7993e_TexelSize;
        float4 Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97_TexelSize;
        float4 Texture2D_38aa29dd5f744ffc8008a01796c8eb28_TexelSize;
        float4 Texture2D_7091a618baa9402e8301a4e786c775b6_TexelSize;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
        SAMPLER(samplerTexture2D_797d926dfbae4e41bdbd471e33d7993e);
        TEXTURE2D(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        SAMPLER(samplerTexture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        TEXTURE2D(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
        SAMPLER(samplerTexture2D_38aa29dd5f744ffc8008a01796c8eb28);
        TEXTURE2D(Texture2D_7091a618baa9402e8301a4e786c775b6);
        SAMPLER(samplerTexture2D_7091a618baa9402e8301a4e786c775b6);

            // Graph Functions
            // GraphFunctions: <None>

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 NormalTS;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            surface.NormalTS = IN.TangentSpaceNormal;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



            output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }

            // Render State
            Cull Off

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_META
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 uv1 : TEXCOORD1;
            float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float4 uv0;
            float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float4 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float Metalic;
        float Smoothness;
        float Rust;
        float Rust_Scale;
        float Rust_Intencity;
        float4 Rust_Color;
        float4 Color_Eyes;
        float Eyes_offset;
        float Eyes_Speed;
        float Eyes_Max;
        float Eyes_Power;
        float4 _Color;
        float4 Texture2D_797d926dfbae4e41bdbd471e33d7993e_TexelSize;
        float4 Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97_TexelSize;
        float4 Texture2D_38aa29dd5f744ffc8008a01796c8eb28_TexelSize;
        float4 Texture2D_7091a618baa9402e8301a4e786c775b6_TexelSize;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
        SAMPLER(samplerTexture2D_797d926dfbae4e41bdbd471e33d7993e);
        TEXTURE2D(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        SAMPLER(samplerTexture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        TEXTURE2D(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
        SAMPLER(samplerTexture2D_38aa29dd5f744ffc8008a01796c8eb28);
        TEXTURE2D(Texture2D_7091a618baa9402e8301a4e786c775b6);
        SAMPLER(samplerTexture2D_7091a618baa9402e8301a4e786c775b6);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }


        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
        }

        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }


        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);

            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            Out = t;
        }

        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);

            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
            
            Axis = normalize(Axis);

            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };

            Out = mul(rot_mat,  In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
            float4 _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0.tex, _Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_R_4 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.r;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_G_5 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.g;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_B_6 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.b;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_A_7 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.a;
            UnityTexture2D _Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
            float4 _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0.tex, _Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_R_4 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.r;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_G_5 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.g;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_B_6 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.b;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_A_7 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.a;
            float4 _UV_497251cb31c6481e80cca4bb7b94376f_Out_0 = IN.uv0;
            float2 _TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3;
            Unity_TilingAndOffset_float((_UV_497251cb31c6481e80cca4bb7b94376f_Out_0.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3);
            float _Property_258198a452454ba6b9eef1cd04acfe16_Out_0 = Rust_Scale;
            float _Float_d37a125732624b89ae34dcf021e0308c_Out_0 = _Property_258198a452454ba6b9eef1cd04acfe16_Out_0;
            float _SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2;
            Unity_SimpleNoise_float(_TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3, _Float_d37a125732624b89ae34dcf021e0308c_Out_0, _SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2);
            float3 _RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3;
            Unity_Rotate_About_Axis_Degrees_float((_UV_497251cb31c6481e80cca4bb7b94376f_Out_0.xyz), float3 (0, 1, 0), 90, _RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3);
            float _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2;
            Unity_SimpleNoise_float((_RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3.xy), _Float_d37a125732624b89ae34dcf021e0308c_Out_0, _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2);
            float _Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2;
            Unity_Add_float(_SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2, _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2, _Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2);
            float _Property_a1108bb44def4b14afd52689ec6bfabf_Out_0 = Rust;
            float _Float_dd492bc0766041c2a282185cb4dccbc8_Out_0 = _Property_a1108bb44def4b14afd52689ec6bfabf_Out_0;
            float _Power_eab0a753bce24cb2996d34d243c481cb_Out_2;
            Unity_Power_float(_Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2, _Float_dd492bc0766041c2a282185cb4dccbc8_Out_0, _Power_eab0a753bce24cb2996d34d243c481cb_Out_2);
            float _Property_6b3e929f388749e3b3fab2bed5cb0731_Out_0 = Rust_Intencity;
            float _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2;
            Unity_Multiply_float(_Power_eab0a753bce24cb2996d34d243c481cb_Out_2, _Property_6b3e929f388749e3b3fab2bed5cb0731_Out_0, _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2);
            float _Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2;
            Unity_Multiply_float(_SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_A_7, _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2, _Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2);
            float4 _Property_f20ca6e8518944c48e0d4fcc9c7fb6a5_Out_0 = IsGammaSpace() ? LinearToSRGB(Rust_Color) : Rust_Color;
            float4 _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2;
            Unity_Multiply_float((_Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2.xxxx), _Property_f20ca6e8518944c48e0d4fcc9c7fb6a5_Out_0, _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2);
            float4 _Add_d93ae8115c7849218693eae74a2d129d_Out_2;
            Unity_Add_float4(_SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0, _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2, _Add_d93ae8115c7849218693eae74a2d129d_Out_2);
            UnityTexture2D _Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_7091a618baa9402e8301a4e786c775b6);
            float4 _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0 = SAMPLE_TEXTURE2D(_Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0.tex, _Property_701d04b6781943dfa06b3dcd4d7405ff_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_R_4 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.r;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_G_5 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.g;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_B_6 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.b;
            float _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_A_7 = _SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_RGBA_0.a;
            float _Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1;
            Unity_Preview_float(_SampleTexture2D_c904b6114e394168aaf47a1737c2ca45_A_7, _Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1);
            float _Property_cef49a576700432f92db05a41dc14fd1_Out_0 = Eyes_Speed;
            float _Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_cef49a576700432f92db05a41dc14fd1_Out_0, _Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2);
            float _Sine_545369abe54e497980f0f72b1dbc2dec_Out_1;
            Unity_Sine_float(_Multiply_6de3c5bfe3bc4f37a21ed01b3addaec3_Out_2, _Sine_545369abe54e497980f0f72b1dbc2dec_Out_1);
            float _Property_f708f64118f442c489a2966614982120_Out_0 = Eyes_offset;
            float _Add_8acd497f31294e029b88aec1ca0f0e09_Out_2;
            Unity_Add_float(_Sine_545369abe54e497980f0f72b1dbc2dec_Out_1, _Property_f708f64118f442c489a2966614982120_Out_0, _Add_8acd497f31294e029b88aec1ca0f0e09_Out_2);
            float _Property_b8677c32a5ec4d47bce15389900f120d_Out_0 = Eyes_Max;
            float _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3;
            Unity_Clamp_float(_Add_8acd497f31294e029b88aec1ca0f0e09_Out_2, 0, _Property_b8677c32a5ec4d47bce15389900f120d_Out_0, _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3);
            float _Multiply_135816d5742040c186fe330b04806dd9_Out_2;
            Unity_Multiply_float(_Preview_1cc2ef0b48454b4d903aad83f67bc628_Out_1, _Clamp_0454804f3cef4a169899a0dfd3644554_Out_3, _Multiply_135816d5742040c186fe330b04806dd9_Out_2);
            float4 _Property_1be18ed7c5c84d13bac1267404542baa_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_Eyes) : Color_Eyes;
            float4 _Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2;
            Unity_Multiply_float((_Multiply_135816d5742040c186fe330b04806dd9_Out_2.xxxx), _Property_1be18ed7c5c84d13bac1267404542baa_Out_0, _Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2);
            float _Property_e5fb9dc44107447ead0dd96d4cff5d90_Out_0 = Eyes_Power;
            float4 _Multiply_4ed7112f60164a73a7842006f86d011e_Out_2;
            Unity_Multiply_float(_Multiply_bf01aeebc58d4e219ea4cb258b8c81f8_Out_2, (_Property_e5fb9dc44107447ead0dd96d4cff5d90_Out_0.xxxx), _Multiply_4ed7112f60164a73a7842006f86d011e_Out_2);
            surface.BaseColor = (_Add_d93ae8115c7849218693eae74a2d129d_Out_2.xyz);
            surface.Emission = (_Multiply_4ed7112f60164a73a7842006f86d011e_Out_2.xyz);
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_2D
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float4 uv0;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float4 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float Metalic;
        float Smoothness;
        float Rust;
        float Rust_Scale;
        float Rust_Intencity;
        float4 Rust_Color;
        float4 Color_Eyes;
        float Eyes_offset;
        float Eyes_Speed;
        float Eyes_Max;
        float Eyes_Power;
        float4 _Color;
        float4 Texture2D_797d926dfbae4e41bdbd471e33d7993e_TexelSize;
        float4 Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97_TexelSize;
        float4 Texture2D_38aa29dd5f744ffc8008a01796c8eb28_TexelSize;
        float4 Texture2D_7091a618baa9402e8301a4e786c775b6_TexelSize;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
        SAMPLER(samplerTexture2D_797d926dfbae4e41bdbd471e33d7993e);
        TEXTURE2D(Texture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        SAMPLER(samplerTexture2D_6b0e483beaba4f0c8de2f56afa2d6f97);
        TEXTURE2D(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
        SAMPLER(samplerTexture2D_38aa29dd5f744ffc8008a01796c8eb28);
        TEXTURE2D(Texture2D_7091a618baa9402e8301a4e786c775b6);
        SAMPLER(samplerTexture2D_7091a618baa9402e8301a4e786c775b6);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }


        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453);
        }

        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }


        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);

            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

            Out = t;
        }

        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);

            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
            
            Axis = normalize(Axis);

            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };

            Out = mul(rot_mat,  In);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_797d926dfbae4e41bdbd471e33d7993e);
            float4 _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0.tex, _Property_d5e08f31e4c74f869dccedf5b18491d4_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_R_4 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.r;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_G_5 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.g;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_B_6 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.b;
            float _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_A_7 = _SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0.a;
            UnityTexture2D _Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_38aa29dd5f744ffc8008a01796c8eb28);
            float4 _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0.tex, _Property_7f68c254e7b44f88ba0f128c7a122a0b_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_R_4 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.r;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_G_5 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.g;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_B_6 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.b;
            float _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_A_7 = _SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_RGBA_0.a;
            float4 _UV_497251cb31c6481e80cca4bb7b94376f_Out_0 = IN.uv0;
            float2 _TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3;
            Unity_TilingAndOffset_float((_UV_497251cb31c6481e80cca4bb7b94376f_Out_0.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3);
            float _Property_258198a452454ba6b9eef1cd04acfe16_Out_0 = Rust_Scale;
            float _Float_d37a125732624b89ae34dcf021e0308c_Out_0 = _Property_258198a452454ba6b9eef1cd04acfe16_Out_0;
            float _SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2;
            Unity_SimpleNoise_float(_TilingAndOffset_d6643674353848b4a33353aa3a9f2e39_Out_3, _Float_d37a125732624b89ae34dcf021e0308c_Out_0, _SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2);
            float3 _RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3;
            Unity_Rotate_About_Axis_Degrees_float((_UV_497251cb31c6481e80cca4bb7b94376f_Out_0.xyz), float3 (0, 1, 0), 90, _RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3);
            float _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2;
            Unity_SimpleNoise_float((_RotateAboutAxis_73bce576277442a2949cc99891222cb7_Out_3.xy), _Float_d37a125732624b89ae34dcf021e0308c_Out_0, _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2);
            float _Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2;
            Unity_Add_float(_SimpleNoise_7b49b6d33a884939b21f5a1e93bbb18b_Out_2, _SimpleNoise_4f7dbce4e97f436d89eb8ee6fb388fa6_Out_2, _Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2);
            float _Property_a1108bb44def4b14afd52689ec6bfabf_Out_0 = Rust;
            float _Float_dd492bc0766041c2a282185cb4dccbc8_Out_0 = _Property_a1108bb44def4b14afd52689ec6bfabf_Out_0;
            float _Power_eab0a753bce24cb2996d34d243c481cb_Out_2;
            Unity_Power_float(_Add_2d002a64fe264a4589a2dddd99d7bc9d_Out_2, _Float_dd492bc0766041c2a282185cb4dccbc8_Out_0, _Power_eab0a753bce24cb2996d34d243c481cb_Out_2);
            float _Property_6b3e929f388749e3b3fab2bed5cb0731_Out_0 = Rust_Intencity;
            float _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2;
            Unity_Multiply_float(_Power_eab0a753bce24cb2996d34d243c481cb_Out_2, _Property_6b3e929f388749e3b3fab2bed5cb0731_Out_0, _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2);
            float _Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2;
            Unity_Multiply_float(_SampleTexture2D_f24aa03d066f479ca7a668387cc54b44_A_7, _Multiply_05624ce3fe8a4756b47cdb3854b79199_Out_2, _Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2);
            float4 _Property_f20ca6e8518944c48e0d4fcc9c7fb6a5_Out_0 = IsGammaSpace() ? LinearToSRGB(Rust_Color) : Rust_Color;
            float4 _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2;
            Unity_Multiply_float((_Multiply_7bcc1d799ce94ed894742041321b2fd0_Out_2.xxxx), _Property_f20ca6e8518944c48e0d4fcc9c7fb6a5_Out_0, _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2);
            float4 _Add_d93ae8115c7849218693eae74a2d129d_Out_2;
            Unity_Add_float4(_SampleTexture2D_5a4a0014160247faaa26222bff97d81e_RGBA_0, _Multiply_964d1290f22b45bb9c34e5aa477feba3_Out_2, _Add_d93ae8115c7849218693eae74a2d129d_Out_2);
            surface.BaseColor = (_Add_d93ae8115c7849218693eae74a2d129d_Out_2.xyz);
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

            ENDHLSL
        }
    }
    CustomEditor "ShaderGraph.PBRMasterGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}