Shader "Custom/Stencil Deisapear"
{
     Properties
    {
        [IntRange] _StencilID ("Stencil ID", Range(0,255)) = 0
        [IntRange] _MaskID ("Mask ID", Range(0,255)) = 0
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
            Blend Zero One
            Zwrite off
            
            Stencil
            {
                Ref [_StencilID]
                Comp notequal
                Pass IncrWrap
                fail DecrWrap
            }
        }
    }
}