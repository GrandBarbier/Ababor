Shader "Unlit/VoronoiTest"
{
    Properties
	{
	    _VorA ("VorA",float) = 117.12
	    _VorB ("VorB",float) = 341.7
	    _VorC ("VorC",float) = 269.5
	    _VorD ("VorD",float) = 123.3
	    _VorE ("VorE",float) = 43458.5453
	    _VorF ("VorF",float) = 6.2236
	    
	    
	    _Color ("Color", Color) = (1,1,1,1)
        _Speed ("Speed", Float) = 1
        _Scale ("_Scale", float) = 6
        _Dist ("_Dist", float) = 1
        _Threshold("_Threshold", float) = 1
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			float _VorA, _VorB, _VorC, _VorD,_VorE, _VorF;
			
			float2 random2(float2 p)
			{
				return frac(sin(float2(dot(p,float2(_VorA, _VorB)),dot(p,float2(_VorC,_VorD))))*_VorE);
			}
			
	
			float _Speed, _Scale, _Dist, _Threshold;
			
			fixed4 _Color;
			
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = _Color;
				
				float2 uv = i.uv;
				uv *= _Scale; //Scaling amount (larger number more cells can be seen)
				float2 iuv = floor(uv); //gets integer values no floating point
				float2 fuv = frac(uv); // gets only the fractional part
				float minDist = _Dist;  // minimun distance
				for (int y = -1; y <= 1; y++)
				{
					for (int x = -1; x <= 1; x++)
					{
						// Position of neighbour on the grid
						float2 neighbour = float2(float(x), float(y));
						// Random position from current + neighbour place in the grid
						float2 pointv = random2(iuv + neighbour);
						// Move the point with time
						pointv = 0.5 + 0.5*sin(_Time.z * _Speed + _VorF*pointv);//each point moves in a certain way
																		// Vector between the pixel and the point
						float2 diff = neighbour + pointv - fuv;
						// Distance to the point
						float dist = length(diff);
						// Keep the closer distance
						minDist = min(minDist, dist);
					}
				}
				// Draw the min distance (distance field)
				col += minDist * minDist * _Dist; // squared it to to make edges look sharper
				return col;
			}
		ENDCG
		}
	}
}
