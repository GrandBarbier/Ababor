Shader "Custom/ReciveBook"
{
   Properties
  {
      [IntRange] _StencilID ("Stencil ID", Range(0,255)) = 0
      [IntRange] _MaskID ("Mask ID", Range(0,255)) = 0
      _BaseMap ("Texture", 2D) = "white" {}
  }
  SubShader
  {
      Tags
      {
          "RenderType"="Opaque"
          "RenderPipline" = "UniversalPipline"
          "Queue" = "Geometry"
      }   
      
      Pass
      {
        Blend One Zero
        Zwrite On
        
        Stencil
        {
            Ref [_StencilID]
            Comp equal
            Pass keep
            fail keep
        }
        
        HLSLPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"            

        struct Attributes
        {
            float4 positionOS   : POSITION;
            float2 uv           : TEXCOORD0;
        };

        struct Varyings
        {
            float4 positionHCS  : SV_POSITION;
            float2 uv           : TEXCOORD0;
        };

        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);

        CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
        CBUFFER_END

        Varyings vert(Attributes IN)
        {
            Varyings OUT;
            OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
            OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
            return OUT;
        }

        half4 frag(Varyings IN) : SV_Target
        {
            half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);
            return color;
        }
        ENDHLSL
      }   
  }
}