Shader "Stencil/Case_Gold"
{
    Properties
    {
        [IntRange] _StencilID ("Stencil ID", Range(0,255)) = 0
        [IntRange] _MaskID ("Mask ID", Range(0,255)) = 0
        
        [HDR]_Color("Color", Color) = (0.3018868, 0.3018868, 0.3018868, 0)
        speed("speed", Float) = 5
        smooth("smooth", Float) = 0
        Metal("Metal", Float) = 0
        [HDR]Color_1("Color (1)", Color) = (1, 1, 1, 0)
        [NoScaleOffset]Texture2D_e61f2db8a8104d7ea1a8032f08426d5c("Base Texture", 2D) = "white" {}
        [NoScaleOffset]Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7("Texture2D", 2D) = "white" {}
        [NoScaleOffset]Texture2D_94d20fd6308248f5a5583d5e2884b13a("Coin", 2D) = "white" {}
        [NoScaleOffset]Texture2D_93ce76279e534c878d4e294d153913ab("Shine", 2D) = "white" {}
        [ToggleUI]Boolean_f7c89928036b4a47b2b1e75f2f9f5fc7("Boolean", Float) = 0
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
        float4 _Color;
        float speed;
        float smooth;
        float Metal;
        float4 Color_1;
        float4 Texture2D_e61f2db8a8104d7ea1a8032f08426d5c_TexelSize;
        float4 Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7_TexelSize;
        float4 Texture2D_94d20fd6308248f5a5583d5e2884b13a_TexelSize;
        float4 Texture2D_93ce76279e534c878d4e294d153913ab_TexelSize;
        float Boolean_f7c89928036b4a47b2b1e75f2f9f5fc7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        SAMPLER(samplerTexture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        TEXTURE2D(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        SAMPLER(samplerTexture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        TEXTURE2D(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
        SAMPLER(samplerTexture2D_94d20fd6308248f5a5583d5e2884b13a);
        TEXTURE2D(Texture2D_93ce76279e534c878d4e294d153913ab);
        SAMPLER(samplerTexture2D_93ce76279e534c878d4e294d153913ab);

            // Graph Functions
            
        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);

            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;

            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;

            Out = UV;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_eb26e8ea99154af1867c084de80d5bee_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
            float4 _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0 = SAMPLE_TEXTURE2D(_Property_eb26e8ea99154af1867c084de80d5bee_Out_0.tex, _Property_eb26e8ea99154af1867c084de80d5bee_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_R_4 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.r;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_G_5 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.g;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_B_6 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.b;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_A_7 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.a;
            UnityTexture2D _Property_0e71e37c09dc48979563f0df09f1aff8_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
            float4 _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0e71e37c09dc48979563f0df09f1aff8_Out_0.tex, _Property_0e71e37c09dc48979563f0df09f1aff8_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_R_4 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.r;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_G_5 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.g;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_B_6 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.b;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_A_7 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.a;
            float _Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1;
            Unity_Preview_float(_SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_A_7, _Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1);
            UnityTexture2D _Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
            float4 _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0.tex, _Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_R_4 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.r;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_G_5 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.g;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_B_6 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.b;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_A_7 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.a;
            float _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1;
            Unity_Preview_float(_SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_A_7, _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1);
            float _Add_adc6e03685f047b9be4fb4abe876a503_Out_2;
            Unity_Add_float(_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1, _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1, _Add_adc6e03685f047b9be4fb4abe876a503_Out_2);
            UnityTexture2D _Property_fbdc7a4e3d4a4637969ef91e90723660_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_93ce76279e534c878d4e294d153913ab);
            float2 _Rotate_6f378828bd50471d9b6158e999687cb6_Out_3;
            Unity_Rotate_Degrees_float(IN.uv0.xy, float2 (0, 0), 45, _Rotate_6f378828bd50471d9b6158e999687cb6_Out_3);
            float _Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.03, _Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2);
            float _Property_1e39a59c12e34ffa9df099625a821773_Out_0 = speed;
            float _Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2;
            Unity_Multiply_float(_Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2, _Property_1e39a59c12e34ffa9df099625a821773_Out_0, _Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2);
            float2 _Vector2_08e11b11ae17434ebd3a2ae5144e713c_Out_0 = float2(_Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2, 0);
            float2 _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3;
            Unity_TilingAndOffset_float(_Rotate_6f378828bd50471d9b6158e999687cb6_Out_3, float2 (0.1, 1), _Vector2_08e11b11ae17434ebd3a2ae5144e713c_Out_0, _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3);
            float4 _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fbdc7a4e3d4a4637969ef91e90723660_Out_0.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3);
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_R_4 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.r;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_G_5 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.g;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_B_6 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.b;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_A_7 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.a;
            float _Preview_03841807ff254ad484bcf005c3120ee0_Out_1;
            Unity_Preview_float(_SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_A_7, _Preview_03841807ff254ad484bcf005c3120ee0_Out_1);
            float _Multiply_6d03599cc11740aba385ac6130e98d45_Out_2;
            Unity_Multiply_float(_Add_adc6e03685f047b9be4fb4abe876a503_Out_2, _Preview_03841807ff254ad484bcf005c3120ee0_Out_1, _Multiply_6d03599cc11740aba385ac6130e98d45_Out_2);
            float4 _Property_1a9c7f206ca842f89e29463767413541_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_1) : Color_1;
            float4 _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2;
            Unity_Multiply_float((_Multiply_6d03599cc11740aba385ac6130e98d45_Out_2.xxxx), _Property_1a9c7f206ca842f89e29463767413541_Out_0, _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2);
            float4 _Add_27e9b90506b4426a999dc298fcad1bf7_Out_2;
            Unity_Add_float4(_SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0, _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2, _Add_27e9b90506b4426a999dc298fcad1bf7_Out_2);
            float4 _Property_aaaae8bb72d4420f83a9241077ae3d27_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2;
            Unity_Multiply_float((_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1.xxxx), _Property_aaaae8bb72d4420f83a9241077ae3d27_Out_0, _Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2);
            float _Property_30e232d1e3554bc78c0e902a34dc153e_Out_0 = Metal;
            float _Multiply_f73f6a10ea77406f900a92572ddc5408_Out_2;
            Unity_Multiply_float(_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1, _Property_30e232d1e3554bc78c0e902a34dc153e_Out_0, _Multiply_f73f6a10ea77406f900a92572ddc5408_Out_2);
            float _Property_0f41c9559b8541c4a9a75ac19765810e_Out_0 = smooth;
            float _Multiply_774b6115e00c4702b986ae66613803cc_Out_2;
            Unity_Multiply_float(_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1, _Property_0f41c9559b8541c4a9a75ac19765810e_Out_0, _Multiply_774b6115e00c4702b986ae66613803cc_Out_2);
            surface.BaseColor = (_Add_27e9b90506b4426a999dc298fcad1bf7_Out_2.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2.xyz);
            surface.Metallic = _Multiply_f73f6a10ea77406f900a92572ddc5408_Out_2;
            surface.Smoothness = _Multiply_774b6115e00c4702b986ae66613803cc_Out_2;
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
        float4 _Color;
        float speed;
        float smooth;
        float Metal;
        float4 Color_1;
        float4 Texture2D_e61f2db8a8104d7ea1a8032f08426d5c_TexelSize;
        float4 Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7_TexelSize;
        float4 Texture2D_94d20fd6308248f5a5583d5e2884b13a_TexelSize;
        float4 Texture2D_93ce76279e534c878d4e294d153913ab_TexelSize;
        float Boolean_f7c89928036b4a47b2b1e75f2f9f5fc7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        SAMPLER(samplerTexture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        TEXTURE2D(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        SAMPLER(samplerTexture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        TEXTURE2D(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
        SAMPLER(samplerTexture2D_94d20fd6308248f5a5583d5e2884b13a);
        TEXTURE2D(Texture2D_93ce76279e534c878d4e294d153913ab);
        SAMPLER(samplerTexture2D_93ce76279e534c878d4e294d153913ab);

            // Graph Functions
            
        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);

            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;

            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;

            Out = UV;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_eb26e8ea99154af1867c084de80d5bee_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
            float4 _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0 = SAMPLE_TEXTURE2D(_Property_eb26e8ea99154af1867c084de80d5bee_Out_0.tex, _Property_eb26e8ea99154af1867c084de80d5bee_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_R_4 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.r;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_G_5 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.g;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_B_6 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.b;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_A_7 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.a;
            UnityTexture2D _Property_0e71e37c09dc48979563f0df09f1aff8_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
            float4 _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0e71e37c09dc48979563f0df09f1aff8_Out_0.tex, _Property_0e71e37c09dc48979563f0df09f1aff8_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_R_4 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.r;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_G_5 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.g;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_B_6 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.b;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_A_7 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.a;
            float _Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1;
            Unity_Preview_float(_SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_A_7, _Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1);
            UnityTexture2D _Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
            float4 _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0.tex, _Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_R_4 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.r;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_G_5 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.g;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_B_6 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.b;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_A_7 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.a;
            float _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1;
            Unity_Preview_float(_SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_A_7, _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1);
            float _Add_adc6e03685f047b9be4fb4abe876a503_Out_2;
            Unity_Add_float(_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1, _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1, _Add_adc6e03685f047b9be4fb4abe876a503_Out_2);
            UnityTexture2D _Property_fbdc7a4e3d4a4637969ef91e90723660_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_93ce76279e534c878d4e294d153913ab);
            float2 _Rotate_6f378828bd50471d9b6158e999687cb6_Out_3;
            Unity_Rotate_Degrees_float(IN.uv0.xy, float2 (0, 0), 45, _Rotate_6f378828bd50471d9b6158e999687cb6_Out_3);
            float _Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.03, _Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2);
            float _Property_1e39a59c12e34ffa9df099625a821773_Out_0 = speed;
            float _Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2;
            Unity_Multiply_float(_Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2, _Property_1e39a59c12e34ffa9df099625a821773_Out_0, _Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2);
            float2 _Vector2_08e11b11ae17434ebd3a2ae5144e713c_Out_0 = float2(_Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2, 0);
            float2 _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3;
            Unity_TilingAndOffset_float(_Rotate_6f378828bd50471d9b6158e999687cb6_Out_3, float2 (0.1, 1), _Vector2_08e11b11ae17434ebd3a2ae5144e713c_Out_0, _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3);
            float4 _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fbdc7a4e3d4a4637969ef91e90723660_Out_0.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3);
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_R_4 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.r;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_G_5 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.g;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_B_6 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.b;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_A_7 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.a;
            float _Preview_03841807ff254ad484bcf005c3120ee0_Out_1;
            Unity_Preview_float(_SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_A_7, _Preview_03841807ff254ad484bcf005c3120ee0_Out_1);
            float _Multiply_6d03599cc11740aba385ac6130e98d45_Out_2;
            Unity_Multiply_float(_Add_adc6e03685f047b9be4fb4abe876a503_Out_2, _Preview_03841807ff254ad484bcf005c3120ee0_Out_1, _Multiply_6d03599cc11740aba385ac6130e98d45_Out_2);
            float4 _Property_1a9c7f206ca842f89e29463767413541_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_1) : Color_1;
            float4 _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2;
            Unity_Multiply_float((_Multiply_6d03599cc11740aba385ac6130e98d45_Out_2.xxxx), _Property_1a9c7f206ca842f89e29463767413541_Out_0, _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2);
            float4 _Add_27e9b90506b4426a999dc298fcad1bf7_Out_2;
            Unity_Add_float4(_SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0, _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2, _Add_27e9b90506b4426a999dc298fcad1bf7_Out_2);
            float4 _Property_aaaae8bb72d4420f83a9241077ae3d27_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2;
            Unity_Multiply_float((_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1.xxxx), _Property_aaaae8bb72d4420f83a9241077ae3d27_Out_0, _Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2);
            float _Property_30e232d1e3554bc78c0e902a34dc153e_Out_0 = Metal;
            float _Multiply_f73f6a10ea77406f900a92572ddc5408_Out_2;
            Unity_Multiply_float(_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1, _Property_30e232d1e3554bc78c0e902a34dc153e_Out_0, _Multiply_f73f6a10ea77406f900a92572ddc5408_Out_2);
            float _Property_0f41c9559b8541c4a9a75ac19765810e_Out_0 = smooth;
            float _Multiply_774b6115e00c4702b986ae66613803cc_Out_2;
            Unity_Multiply_float(_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1, _Property_0f41c9559b8541c4a9a75ac19765810e_Out_0, _Multiply_774b6115e00c4702b986ae66613803cc_Out_2);
            surface.BaseColor = (_Add_27e9b90506b4426a999dc298fcad1bf7_Out_2.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2.xyz);
            surface.Metallic = _Multiply_f73f6a10ea77406f900a92572ddc5408_Out_2;
            surface.Smoothness = _Multiply_774b6115e00c4702b986ae66613803cc_Out_2;
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
        float4 _Color;
        float speed;
        float smooth;
        float Metal;
        float4 Color_1;
        float4 Texture2D_e61f2db8a8104d7ea1a8032f08426d5c_TexelSize;
        float4 Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7_TexelSize;
        float4 Texture2D_94d20fd6308248f5a5583d5e2884b13a_TexelSize;
        float4 Texture2D_93ce76279e534c878d4e294d153913ab_TexelSize;
        float Boolean_f7c89928036b4a47b2b1e75f2f9f5fc7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        SAMPLER(samplerTexture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        TEXTURE2D(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        SAMPLER(samplerTexture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        TEXTURE2D(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
        SAMPLER(samplerTexture2D_94d20fd6308248f5a5583d5e2884b13a);
        TEXTURE2D(Texture2D_93ce76279e534c878d4e294d153913ab);
        SAMPLER(samplerTexture2D_93ce76279e534c878d4e294d153913ab);

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
        float4 _Color;
        float speed;
        float smooth;
        float Metal;
        float4 Color_1;
        float4 Texture2D_e61f2db8a8104d7ea1a8032f08426d5c_TexelSize;
        float4 Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7_TexelSize;
        float4 Texture2D_94d20fd6308248f5a5583d5e2884b13a_TexelSize;
        float4 Texture2D_93ce76279e534c878d4e294d153913ab_TexelSize;
        float Boolean_f7c89928036b4a47b2b1e75f2f9f5fc7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        SAMPLER(samplerTexture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        TEXTURE2D(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        SAMPLER(samplerTexture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        TEXTURE2D(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
        SAMPLER(samplerTexture2D_94d20fd6308248f5a5583d5e2884b13a);
        TEXTURE2D(Texture2D_93ce76279e534c878d4e294d153913ab);
        SAMPLER(samplerTexture2D_93ce76279e534c878d4e294d153913ab);

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
        float4 _Color;
        float speed;
        float smooth;
        float Metal;
        float4 Color_1;
        float4 Texture2D_e61f2db8a8104d7ea1a8032f08426d5c_TexelSize;
        float4 Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7_TexelSize;
        float4 Texture2D_94d20fd6308248f5a5583d5e2884b13a_TexelSize;
        float4 Texture2D_93ce76279e534c878d4e294d153913ab_TexelSize;
        float Boolean_f7c89928036b4a47b2b1e75f2f9f5fc7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        SAMPLER(samplerTexture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        TEXTURE2D(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        SAMPLER(samplerTexture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        TEXTURE2D(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
        SAMPLER(samplerTexture2D_94d20fd6308248f5a5583d5e2884b13a);
        TEXTURE2D(Texture2D_93ce76279e534c878d4e294d153913ab);
        SAMPLER(samplerTexture2D_93ce76279e534c878d4e294d153913ab);

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
        float4 _Color;
        float speed;
        float smooth;
        float Metal;
        float4 Color_1;
        float4 Texture2D_e61f2db8a8104d7ea1a8032f08426d5c_TexelSize;
        float4 Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7_TexelSize;
        float4 Texture2D_94d20fd6308248f5a5583d5e2884b13a_TexelSize;
        float4 Texture2D_93ce76279e534c878d4e294d153913ab_TexelSize;
        float Boolean_f7c89928036b4a47b2b1e75f2f9f5fc7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        SAMPLER(samplerTexture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        TEXTURE2D(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        SAMPLER(samplerTexture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        TEXTURE2D(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
        SAMPLER(samplerTexture2D_94d20fd6308248f5a5583d5e2884b13a);
        TEXTURE2D(Texture2D_93ce76279e534c878d4e294d153913ab);
        SAMPLER(samplerTexture2D_93ce76279e534c878d4e294d153913ab);

            // Graph Functions
            
        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);

            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;

            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;

            Out = UV;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            float3 Emission;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_eb26e8ea99154af1867c084de80d5bee_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
            float4 _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0 = SAMPLE_TEXTURE2D(_Property_eb26e8ea99154af1867c084de80d5bee_Out_0.tex, _Property_eb26e8ea99154af1867c084de80d5bee_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_R_4 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.r;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_G_5 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.g;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_B_6 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.b;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_A_7 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.a;
            UnityTexture2D _Property_0e71e37c09dc48979563f0df09f1aff8_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
            float4 _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0e71e37c09dc48979563f0df09f1aff8_Out_0.tex, _Property_0e71e37c09dc48979563f0df09f1aff8_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_R_4 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.r;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_G_5 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.g;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_B_6 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.b;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_A_7 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.a;
            float _Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1;
            Unity_Preview_float(_SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_A_7, _Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1);
            UnityTexture2D _Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
            float4 _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0.tex, _Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_R_4 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.r;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_G_5 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.g;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_B_6 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.b;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_A_7 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.a;
            float _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1;
            Unity_Preview_float(_SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_A_7, _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1);
            float _Add_adc6e03685f047b9be4fb4abe876a503_Out_2;
            Unity_Add_float(_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1, _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1, _Add_adc6e03685f047b9be4fb4abe876a503_Out_2);
            UnityTexture2D _Property_fbdc7a4e3d4a4637969ef91e90723660_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_93ce76279e534c878d4e294d153913ab);
            float2 _Rotate_6f378828bd50471d9b6158e999687cb6_Out_3;
            Unity_Rotate_Degrees_float(IN.uv0.xy, float2 (0, 0), 45, _Rotate_6f378828bd50471d9b6158e999687cb6_Out_3);
            float _Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.03, _Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2);
            float _Property_1e39a59c12e34ffa9df099625a821773_Out_0 = speed;
            float _Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2;
            Unity_Multiply_float(_Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2, _Property_1e39a59c12e34ffa9df099625a821773_Out_0, _Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2);
            float2 _Vector2_08e11b11ae17434ebd3a2ae5144e713c_Out_0 = float2(_Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2, 0);
            float2 _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3;
            Unity_TilingAndOffset_float(_Rotate_6f378828bd50471d9b6158e999687cb6_Out_3, float2 (0.1, 1), _Vector2_08e11b11ae17434ebd3a2ae5144e713c_Out_0, _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3);
            float4 _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fbdc7a4e3d4a4637969ef91e90723660_Out_0.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3);
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_R_4 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.r;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_G_5 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.g;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_B_6 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.b;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_A_7 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.a;
            float _Preview_03841807ff254ad484bcf005c3120ee0_Out_1;
            Unity_Preview_float(_SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_A_7, _Preview_03841807ff254ad484bcf005c3120ee0_Out_1);
            float _Multiply_6d03599cc11740aba385ac6130e98d45_Out_2;
            Unity_Multiply_float(_Add_adc6e03685f047b9be4fb4abe876a503_Out_2, _Preview_03841807ff254ad484bcf005c3120ee0_Out_1, _Multiply_6d03599cc11740aba385ac6130e98d45_Out_2);
            float4 _Property_1a9c7f206ca842f89e29463767413541_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_1) : Color_1;
            float4 _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2;
            Unity_Multiply_float((_Multiply_6d03599cc11740aba385ac6130e98d45_Out_2.xxxx), _Property_1a9c7f206ca842f89e29463767413541_Out_0, _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2);
            float4 _Add_27e9b90506b4426a999dc298fcad1bf7_Out_2;
            Unity_Add_float4(_SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0, _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2, _Add_27e9b90506b4426a999dc298fcad1bf7_Out_2);
            float4 _Property_aaaae8bb72d4420f83a9241077ae3d27_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2;
            Unity_Multiply_float((_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1.xxxx), _Property_aaaae8bb72d4420f83a9241077ae3d27_Out_0, _Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2);
            surface.BaseColor = (_Add_27e9b90506b4426a999dc298fcad1bf7_Out_2.xyz);
            surface.Emission = (_Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2.xyz);
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
        float4 _Color;
        float speed;
        float smooth;
        float Metal;
        float4 Color_1;
        float4 Texture2D_e61f2db8a8104d7ea1a8032f08426d5c_TexelSize;
        float4 Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7_TexelSize;
        float4 Texture2D_94d20fd6308248f5a5583d5e2884b13a_TexelSize;
        float4 Texture2D_93ce76279e534c878d4e294d153913ab_TexelSize;
        float Boolean_f7c89928036b4a47b2b1e75f2f9f5fc7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        SAMPLER(samplerTexture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        TEXTURE2D(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        SAMPLER(samplerTexture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        TEXTURE2D(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
        SAMPLER(samplerTexture2D_94d20fd6308248f5a5583d5e2884b13a);
        TEXTURE2D(Texture2D_93ce76279e534c878d4e294d153913ab);
        SAMPLER(samplerTexture2D_93ce76279e534c878d4e294d153913ab);

            // Graph Functions
            
        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);

            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;

            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;

            Out = UV;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            UnityTexture2D _Property_eb26e8ea99154af1867c084de80d5bee_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
            float4 _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0 = SAMPLE_TEXTURE2D(_Property_eb26e8ea99154af1867c084de80d5bee_Out_0.tex, _Property_eb26e8ea99154af1867c084de80d5bee_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_R_4 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.r;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_G_5 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.g;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_B_6 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.b;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_A_7 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.a;
            UnityTexture2D _Property_0e71e37c09dc48979563f0df09f1aff8_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
            float4 _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0e71e37c09dc48979563f0df09f1aff8_Out_0.tex, _Property_0e71e37c09dc48979563f0df09f1aff8_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_R_4 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.r;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_G_5 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.g;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_B_6 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.b;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_A_7 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.a;
            float _Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1;
            Unity_Preview_float(_SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_A_7, _Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1);
            UnityTexture2D _Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
            float4 _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0.tex, _Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_R_4 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.r;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_G_5 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.g;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_B_6 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.b;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_A_7 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.a;
            float _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1;
            Unity_Preview_float(_SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_A_7, _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1);
            float _Add_adc6e03685f047b9be4fb4abe876a503_Out_2;
            Unity_Add_float(_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1, _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1, _Add_adc6e03685f047b9be4fb4abe876a503_Out_2);
            UnityTexture2D _Property_fbdc7a4e3d4a4637969ef91e90723660_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_93ce76279e534c878d4e294d153913ab);
            float2 _Rotate_6f378828bd50471d9b6158e999687cb6_Out_3;
            Unity_Rotate_Degrees_float(IN.uv0.xy, float2 (0, 0), 45, _Rotate_6f378828bd50471d9b6158e999687cb6_Out_3);
            float _Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.03, _Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2);
            float _Property_1e39a59c12e34ffa9df099625a821773_Out_0 = speed;
            float _Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2;
            Unity_Multiply_float(_Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2, _Property_1e39a59c12e34ffa9df099625a821773_Out_0, _Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2);
            float2 _Vector2_08e11b11ae17434ebd3a2ae5144e713c_Out_0 = float2(_Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2, 0);
            float2 _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3;
            Unity_TilingAndOffset_float(_Rotate_6f378828bd50471d9b6158e999687cb6_Out_3, float2 (0.1, 1), _Vector2_08e11b11ae17434ebd3a2ae5144e713c_Out_0, _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3);
            float4 _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fbdc7a4e3d4a4637969ef91e90723660_Out_0.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3);
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_R_4 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.r;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_G_5 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.g;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_B_6 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.b;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_A_7 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.a;
            float _Preview_03841807ff254ad484bcf005c3120ee0_Out_1;
            Unity_Preview_float(_SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_A_7, _Preview_03841807ff254ad484bcf005c3120ee0_Out_1);
            float _Multiply_6d03599cc11740aba385ac6130e98d45_Out_2;
            Unity_Multiply_float(_Add_adc6e03685f047b9be4fb4abe876a503_Out_2, _Preview_03841807ff254ad484bcf005c3120ee0_Out_1, _Multiply_6d03599cc11740aba385ac6130e98d45_Out_2);
            float4 _Property_1a9c7f206ca842f89e29463767413541_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_1) : Color_1;
            float4 _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2;
            Unity_Multiply_float((_Multiply_6d03599cc11740aba385ac6130e98d45_Out_2.xxxx), _Property_1a9c7f206ca842f89e29463767413541_Out_0, _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2);
            float4 _Add_27e9b90506b4426a999dc298fcad1bf7_Out_2;
            Unity_Add_float4(_SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0, _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2, _Add_27e9b90506b4426a999dc298fcad1bf7_Out_2);
            surface.BaseColor = (_Add_27e9b90506b4426a999dc298fcad1bf7_Out_2.xyz);
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
        float4 _Color;
        float speed;
        float smooth;
        float Metal;
        float4 Color_1;
        float4 Texture2D_e61f2db8a8104d7ea1a8032f08426d5c_TexelSize;
        float4 Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7_TexelSize;
        float4 Texture2D_94d20fd6308248f5a5583d5e2884b13a_TexelSize;
        float4 Texture2D_93ce76279e534c878d4e294d153913ab_TexelSize;
        float Boolean_f7c89928036b4a47b2b1e75f2f9f5fc7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        SAMPLER(samplerTexture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        TEXTURE2D(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        SAMPLER(samplerTexture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        TEXTURE2D(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
        SAMPLER(samplerTexture2D_94d20fd6308248f5a5583d5e2884b13a);
        TEXTURE2D(Texture2D_93ce76279e534c878d4e294d153913ab);
        SAMPLER(samplerTexture2D_93ce76279e534c878d4e294d153913ab);

            // Graph Functions
            
        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);

            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;

            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;

            Out = UV;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_eb26e8ea99154af1867c084de80d5bee_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
            float4 _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0 = SAMPLE_TEXTURE2D(_Property_eb26e8ea99154af1867c084de80d5bee_Out_0.tex, _Property_eb26e8ea99154af1867c084de80d5bee_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_R_4 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.r;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_G_5 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.g;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_B_6 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.b;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_A_7 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.a;
            UnityTexture2D _Property_0e71e37c09dc48979563f0df09f1aff8_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
            float4 _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0e71e37c09dc48979563f0df09f1aff8_Out_0.tex, _Property_0e71e37c09dc48979563f0df09f1aff8_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_R_4 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.r;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_G_5 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.g;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_B_6 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.b;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_A_7 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.a;
            float _Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1;
            Unity_Preview_float(_SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_A_7, _Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1);
            UnityTexture2D _Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
            float4 _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0.tex, _Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_R_4 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.r;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_G_5 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.g;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_B_6 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.b;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_A_7 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.a;
            float _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1;
            Unity_Preview_float(_SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_A_7, _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1);
            float _Add_adc6e03685f047b9be4fb4abe876a503_Out_2;
            Unity_Add_float(_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1, _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1, _Add_adc6e03685f047b9be4fb4abe876a503_Out_2);
            UnityTexture2D _Property_fbdc7a4e3d4a4637969ef91e90723660_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_93ce76279e534c878d4e294d153913ab);
            float2 _Rotate_6f378828bd50471d9b6158e999687cb6_Out_3;
            Unity_Rotate_Degrees_float(IN.uv0.xy, float2 (0, 0), 45, _Rotate_6f378828bd50471d9b6158e999687cb6_Out_3);
            float _Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.03, _Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2);
            float _Property_1e39a59c12e34ffa9df099625a821773_Out_0 = speed;
            float _Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2;
            Unity_Multiply_float(_Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2, _Property_1e39a59c12e34ffa9df099625a821773_Out_0, _Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2);
            float2 _Vector2_08e11b11ae17434ebd3a2ae5144e713c_Out_0 = float2(_Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2, 0);
            float2 _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3;
            Unity_TilingAndOffset_float(_Rotate_6f378828bd50471d9b6158e999687cb6_Out_3, float2 (0.1, 1), _Vector2_08e11b11ae17434ebd3a2ae5144e713c_Out_0, _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3);
            float4 _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fbdc7a4e3d4a4637969ef91e90723660_Out_0.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3);
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_R_4 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.r;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_G_5 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.g;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_B_6 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.b;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_A_7 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.a;
            float _Preview_03841807ff254ad484bcf005c3120ee0_Out_1;
            Unity_Preview_float(_SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_A_7, _Preview_03841807ff254ad484bcf005c3120ee0_Out_1);
            float _Multiply_6d03599cc11740aba385ac6130e98d45_Out_2;
            Unity_Multiply_float(_Add_adc6e03685f047b9be4fb4abe876a503_Out_2, _Preview_03841807ff254ad484bcf005c3120ee0_Out_1, _Multiply_6d03599cc11740aba385ac6130e98d45_Out_2);
            float4 _Property_1a9c7f206ca842f89e29463767413541_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_1) : Color_1;
            float4 _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2;
            Unity_Multiply_float((_Multiply_6d03599cc11740aba385ac6130e98d45_Out_2.xxxx), _Property_1a9c7f206ca842f89e29463767413541_Out_0, _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2);
            float4 _Add_27e9b90506b4426a999dc298fcad1bf7_Out_2;
            Unity_Add_float4(_SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0, _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2, _Add_27e9b90506b4426a999dc298fcad1bf7_Out_2);
            float4 _Property_aaaae8bb72d4420f83a9241077ae3d27_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2;
            Unity_Multiply_float((_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1.xxxx), _Property_aaaae8bb72d4420f83a9241077ae3d27_Out_0, _Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2);
            float _Property_30e232d1e3554bc78c0e902a34dc153e_Out_0 = Metal;
            float _Multiply_f73f6a10ea77406f900a92572ddc5408_Out_2;
            Unity_Multiply_float(_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1, _Property_30e232d1e3554bc78c0e902a34dc153e_Out_0, _Multiply_f73f6a10ea77406f900a92572ddc5408_Out_2);
            float _Property_0f41c9559b8541c4a9a75ac19765810e_Out_0 = smooth;
            float _Multiply_774b6115e00c4702b986ae66613803cc_Out_2;
            Unity_Multiply_float(_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1, _Property_0f41c9559b8541c4a9a75ac19765810e_Out_0, _Multiply_774b6115e00c4702b986ae66613803cc_Out_2);
            surface.BaseColor = (_Add_27e9b90506b4426a999dc298fcad1bf7_Out_2.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2.xyz);
            surface.Metallic = _Multiply_f73f6a10ea77406f900a92572ddc5408_Out_2;
            surface.Smoothness = _Multiply_774b6115e00c4702b986ae66613803cc_Out_2;
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
        float4 _Color;
        float speed;
        float smooth;
        float Metal;
        float4 Color_1;
        float4 Texture2D_e61f2db8a8104d7ea1a8032f08426d5c_TexelSize;
        float4 Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7_TexelSize;
        float4 Texture2D_94d20fd6308248f5a5583d5e2884b13a_TexelSize;
        float4 Texture2D_93ce76279e534c878d4e294d153913ab_TexelSize;
        float Boolean_f7c89928036b4a47b2b1e75f2f9f5fc7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        SAMPLER(samplerTexture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        TEXTURE2D(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        SAMPLER(samplerTexture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        TEXTURE2D(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
        SAMPLER(samplerTexture2D_94d20fd6308248f5a5583d5e2884b13a);
        TEXTURE2D(Texture2D_93ce76279e534c878d4e294d153913ab);
        SAMPLER(samplerTexture2D_93ce76279e534c878d4e294d153913ab);

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
        float4 _Color;
        float speed;
        float smooth;
        float Metal;
        float4 Color_1;
        float4 Texture2D_e61f2db8a8104d7ea1a8032f08426d5c_TexelSize;
        float4 Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7_TexelSize;
        float4 Texture2D_94d20fd6308248f5a5583d5e2884b13a_TexelSize;
        float4 Texture2D_93ce76279e534c878d4e294d153913ab_TexelSize;
        float Boolean_f7c89928036b4a47b2b1e75f2f9f5fc7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        SAMPLER(samplerTexture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        TEXTURE2D(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        SAMPLER(samplerTexture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        TEXTURE2D(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
        SAMPLER(samplerTexture2D_94d20fd6308248f5a5583d5e2884b13a);
        TEXTURE2D(Texture2D_93ce76279e534c878d4e294d153913ab);
        SAMPLER(samplerTexture2D_93ce76279e534c878d4e294d153913ab);

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
        float4 _Color;
        float speed;
        float smooth;
        float Metal;
        float4 Color_1;
        float4 Texture2D_e61f2db8a8104d7ea1a8032f08426d5c_TexelSize;
        float4 Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7_TexelSize;
        float4 Texture2D_94d20fd6308248f5a5583d5e2884b13a_TexelSize;
        float4 Texture2D_93ce76279e534c878d4e294d153913ab_TexelSize;
        float Boolean_f7c89928036b4a47b2b1e75f2f9f5fc7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        SAMPLER(samplerTexture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        TEXTURE2D(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        SAMPLER(samplerTexture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        TEXTURE2D(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
        SAMPLER(samplerTexture2D_94d20fd6308248f5a5583d5e2884b13a);
        TEXTURE2D(Texture2D_93ce76279e534c878d4e294d153913ab);
        SAMPLER(samplerTexture2D_93ce76279e534c878d4e294d153913ab);

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
        float4 _Color;
        float speed;
        float smooth;
        float Metal;
        float4 Color_1;
        float4 Texture2D_e61f2db8a8104d7ea1a8032f08426d5c_TexelSize;
        float4 Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7_TexelSize;
        float4 Texture2D_94d20fd6308248f5a5583d5e2884b13a_TexelSize;
        float4 Texture2D_93ce76279e534c878d4e294d153913ab_TexelSize;
        float Boolean_f7c89928036b4a47b2b1e75f2f9f5fc7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        SAMPLER(samplerTexture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        TEXTURE2D(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        SAMPLER(samplerTexture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        TEXTURE2D(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
        SAMPLER(samplerTexture2D_94d20fd6308248f5a5583d5e2884b13a);
        TEXTURE2D(Texture2D_93ce76279e534c878d4e294d153913ab);
        SAMPLER(samplerTexture2D_93ce76279e534c878d4e294d153913ab);

            // Graph Functions
            
        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);

            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;

            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;

            Out = UV;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            float3 Emission;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_eb26e8ea99154af1867c084de80d5bee_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
            float4 _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0 = SAMPLE_TEXTURE2D(_Property_eb26e8ea99154af1867c084de80d5bee_Out_0.tex, _Property_eb26e8ea99154af1867c084de80d5bee_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_R_4 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.r;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_G_5 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.g;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_B_6 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.b;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_A_7 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.a;
            UnityTexture2D _Property_0e71e37c09dc48979563f0df09f1aff8_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
            float4 _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0e71e37c09dc48979563f0df09f1aff8_Out_0.tex, _Property_0e71e37c09dc48979563f0df09f1aff8_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_R_4 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.r;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_G_5 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.g;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_B_6 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.b;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_A_7 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.a;
            float _Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1;
            Unity_Preview_float(_SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_A_7, _Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1);
            UnityTexture2D _Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
            float4 _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0.tex, _Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_R_4 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.r;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_G_5 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.g;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_B_6 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.b;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_A_7 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.a;
            float _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1;
            Unity_Preview_float(_SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_A_7, _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1);
            float _Add_adc6e03685f047b9be4fb4abe876a503_Out_2;
            Unity_Add_float(_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1, _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1, _Add_adc6e03685f047b9be4fb4abe876a503_Out_2);
            UnityTexture2D _Property_fbdc7a4e3d4a4637969ef91e90723660_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_93ce76279e534c878d4e294d153913ab);
            float2 _Rotate_6f378828bd50471d9b6158e999687cb6_Out_3;
            Unity_Rotate_Degrees_float(IN.uv0.xy, float2 (0, 0), 45, _Rotate_6f378828bd50471d9b6158e999687cb6_Out_3);
            float _Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.03, _Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2);
            float _Property_1e39a59c12e34ffa9df099625a821773_Out_0 = speed;
            float _Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2;
            Unity_Multiply_float(_Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2, _Property_1e39a59c12e34ffa9df099625a821773_Out_0, _Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2);
            float2 _Vector2_08e11b11ae17434ebd3a2ae5144e713c_Out_0 = float2(_Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2, 0);
            float2 _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3;
            Unity_TilingAndOffset_float(_Rotate_6f378828bd50471d9b6158e999687cb6_Out_3, float2 (0.1, 1), _Vector2_08e11b11ae17434ebd3a2ae5144e713c_Out_0, _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3);
            float4 _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fbdc7a4e3d4a4637969ef91e90723660_Out_0.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3);
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_R_4 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.r;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_G_5 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.g;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_B_6 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.b;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_A_7 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.a;
            float _Preview_03841807ff254ad484bcf005c3120ee0_Out_1;
            Unity_Preview_float(_SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_A_7, _Preview_03841807ff254ad484bcf005c3120ee0_Out_1);
            float _Multiply_6d03599cc11740aba385ac6130e98d45_Out_2;
            Unity_Multiply_float(_Add_adc6e03685f047b9be4fb4abe876a503_Out_2, _Preview_03841807ff254ad484bcf005c3120ee0_Out_1, _Multiply_6d03599cc11740aba385ac6130e98d45_Out_2);
            float4 _Property_1a9c7f206ca842f89e29463767413541_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_1) : Color_1;
            float4 _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2;
            Unity_Multiply_float((_Multiply_6d03599cc11740aba385ac6130e98d45_Out_2.xxxx), _Property_1a9c7f206ca842f89e29463767413541_Out_0, _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2);
            float4 _Add_27e9b90506b4426a999dc298fcad1bf7_Out_2;
            Unity_Add_float4(_SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0, _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2, _Add_27e9b90506b4426a999dc298fcad1bf7_Out_2);
            float4 _Property_aaaae8bb72d4420f83a9241077ae3d27_Out_0 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2;
            Unity_Multiply_float((_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1.xxxx), _Property_aaaae8bb72d4420f83a9241077ae3d27_Out_0, _Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2);
            surface.BaseColor = (_Add_27e9b90506b4426a999dc298fcad1bf7_Out_2.xyz);
            surface.Emission = (_Multiply_7e37d9cf05dc484cad79af184925b5e4_Out_2.xyz);
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
        float4 _Color;
        float speed;
        float smooth;
        float Metal;
        float4 Color_1;
        float4 Texture2D_e61f2db8a8104d7ea1a8032f08426d5c_TexelSize;
        float4 Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7_TexelSize;
        float4 Texture2D_94d20fd6308248f5a5583d5e2884b13a_TexelSize;
        float4 Texture2D_93ce76279e534c878d4e294d153913ab_TexelSize;
        float Boolean_f7c89928036b4a47b2b1e75f2f9f5fc7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        SAMPLER(samplerTexture2D_e61f2db8a8104d7ea1a8032f08426d5c);
        TEXTURE2D(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        SAMPLER(samplerTexture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
        TEXTURE2D(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
        SAMPLER(samplerTexture2D_94d20fd6308248f5a5583d5e2884b13a);
        TEXTURE2D(Texture2D_93ce76279e534c878d4e294d153913ab);
        SAMPLER(samplerTexture2D_93ce76279e534c878d4e294d153913ab);

            // Graph Functions
            
        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);

            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;

            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;

            Out = UV;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
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
            UnityTexture2D _Property_eb26e8ea99154af1867c084de80d5bee_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_e61f2db8a8104d7ea1a8032f08426d5c);
            float4 _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0 = SAMPLE_TEXTURE2D(_Property_eb26e8ea99154af1867c084de80d5bee_Out_0.tex, _Property_eb26e8ea99154af1867c084de80d5bee_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_R_4 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.r;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_G_5 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.g;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_B_6 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.b;
            float _SampleTexture2D_792a977dd105424497de96b0793b3fd7_A_7 = _SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0.a;
            UnityTexture2D _Property_0e71e37c09dc48979563f0df09f1aff8_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_f3a078b8ba144c84bd6a3ef3e8bee2f7);
            float4 _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0e71e37c09dc48979563f0df09f1aff8_Out_0.tex, _Property_0e71e37c09dc48979563f0df09f1aff8_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_R_4 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.r;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_G_5 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.g;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_B_6 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.b;
            float _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_A_7 = _SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_RGBA_0.a;
            float _Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1;
            Unity_Preview_float(_SampleTexture2D_a29f22e26ecf4ab2958fea1cb12b766f_A_7, _Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1);
            UnityTexture2D _Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_94d20fd6308248f5a5583d5e2884b13a);
            float4 _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0 = SAMPLE_TEXTURE2D(_Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0.tex, _Property_d0a3a7a86c54482b996f91cd6d7409b5_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_R_4 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.r;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_G_5 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.g;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_B_6 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.b;
            float _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_A_7 = _SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_RGBA_0.a;
            float _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1;
            Unity_Preview_float(_SampleTexture2D_4b4ab5908e27447286c5ed5b3c9eab18_A_7, _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1);
            float _Add_adc6e03685f047b9be4fb4abe876a503_Out_2;
            Unity_Add_float(_Preview_6f5b08df44ed46eba2d2d6920c356e1c_Out_1, _Preview_459ab8ab2e8c4b8bb4da45edb34a3568_Out_1, _Add_adc6e03685f047b9be4fb4abe876a503_Out_2);
            UnityTexture2D _Property_fbdc7a4e3d4a4637969ef91e90723660_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_93ce76279e534c878d4e294d153913ab);
            float2 _Rotate_6f378828bd50471d9b6158e999687cb6_Out_3;
            Unity_Rotate_Degrees_float(IN.uv0.xy, float2 (0, 0), 45, _Rotate_6f378828bd50471d9b6158e999687cb6_Out_3);
            float _Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, 0.03, _Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2);
            float _Property_1e39a59c12e34ffa9df099625a821773_Out_0 = speed;
            float _Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2;
            Unity_Multiply_float(_Multiply_375aca2964bf480ba3d60f33e42a74fa_Out_2, _Property_1e39a59c12e34ffa9df099625a821773_Out_0, _Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2);
            float2 _Vector2_08e11b11ae17434ebd3a2ae5144e713c_Out_0 = float2(_Multiply_9db023f06e8f472d8fcfd6613b51a790_Out_2, 0);
            float2 _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3;
            Unity_TilingAndOffset_float(_Rotate_6f378828bd50471d9b6158e999687cb6_Out_3, float2 (0.1, 1), _Vector2_08e11b11ae17434ebd3a2ae5144e713c_Out_0, _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3);
            float4 _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0 = SAMPLE_TEXTURE2D(_Property_fbdc7a4e3d4a4637969ef91e90723660_Out_0.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat).samplerstate, _TilingAndOffset_8bda4c46d5fe40879de3e95f994b7a5d_Out_3);
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_R_4 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.r;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_G_5 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.g;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_B_6 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.b;
            float _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_A_7 = _SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_RGBA_0.a;
            float _Preview_03841807ff254ad484bcf005c3120ee0_Out_1;
            Unity_Preview_float(_SampleTexture2D_9dddf3c7f5624f66b1569b04afdfbeef_A_7, _Preview_03841807ff254ad484bcf005c3120ee0_Out_1);
            float _Multiply_6d03599cc11740aba385ac6130e98d45_Out_2;
            Unity_Multiply_float(_Add_adc6e03685f047b9be4fb4abe876a503_Out_2, _Preview_03841807ff254ad484bcf005c3120ee0_Out_1, _Multiply_6d03599cc11740aba385ac6130e98d45_Out_2);
            float4 _Property_1a9c7f206ca842f89e29463767413541_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_1) : Color_1;
            float4 _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2;
            Unity_Multiply_float((_Multiply_6d03599cc11740aba385ac6130e98d45_Out_2.xxxx), _Property_1a9c7f206ca842f89e29463767413541_Out_0, _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2);
            float4 _Add_27e9b90506b4426a999dc298fcad1bf7_Out_2;
            Unity_Add_float4(_SampleTexture2D_792a977dd105424497de96b0793b3fd7_RGBA_0, _Multiply_cfb91c7ac41b422dad5c89d5fdc48732_Out_2, _Add_27e9b90506b4426a999dc298fcad1bf7_Out_2);
            surface.BaseColor = (_Add_27e9b90506b4426a999dc298fcad1bf7_Out_2.xyz);
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

            ENDHLSL
        }
    }
    CustomEditor "ShaderGraph.PBRMasterGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}