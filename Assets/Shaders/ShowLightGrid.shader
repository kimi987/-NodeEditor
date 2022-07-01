Shader "ForwardPlus/ShowLightGrid"
{
	Properties
	{
		//[HideInInspector] _MainTex ("Texture", 2D) = "white" {}
		_HeatMap("HeatMapTexture", 2D) = "white" {}
		_GridColor("GridColor", Color) = (0, 0, 0, 1)
		_Show("Show", Range(0, 1)) = 0.8
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			HLSLPROGRAM
			#pragma vertex LitPassVertex
			#pragma fragment frag
			
			#include "ForwardPlus.hlsl"
			//sampler2D _MainTex;
			sampler2D _GridMainRT;
			//sampler2D heatmap;
			sampler2D _HeatMap;

			float4 _GridColor;
			float _Show;

			half4 frag (Varyings i) : SV_Target
			{
				float2 uv = (i.clipPosition.xy / i.clipPosition.w) * 0.5 + 0.5;
				
				float2 uv_tiles = uv * _ScreenParams.xy / _TileSize;
				
				float2 xy = abs(frac(uv_tiles) * 2 - 1);
				float VAL = 8;
				float reticolo = 1.0 - step(pow(pow(xy.x, VAL) + pow(xy.y, VAL), 1.0 / VAL), 0.93);
				reticolo *= 0.25;

				//fixed4 col = tex2D(_MainTex, i.uv);

				
				// uint2 grid = _LightsGridRT[(uint2)uv];
				uint2 numFrustums = ceil(_ScreenParams.xy / _TileSize);
				uint2 index = floor(uv* numFrustums);
				LightIndex lightIndex = _LightIndexes[index.x + index.y * numFrustums.x];

				uv.y = 1.0 - uv.y;
				half4 col = tex2D(_GridMainRT, uv);
				/*if (grid.y > 0)
					return fixed4(1.0, 0.0, 0.0, 1.0);
				else
					return fixed4(0.0, 1.0, 0.0, 1.0);*/

				// float heat_uv_x = grid.y * 0.015625;
				uint n = lightIndex.buff & 0x0000000f;
				float heat_uv_x = n * 0.015625; 

				//float4 heat = tex2D(heatmap, float2(heat_uv_x, 0.5f));
				float4 heat = tex2D(_HeatMap, float2(heat_uv_x, 0.5f));

				half4 ris = heat * (1.0 - reticolo) + _GridColor * reticolo;

				ris = col * (1 - _Show) + ris * _Show;

				ris.a = 1;

				return ris;
			}
			ENDHLSL
		}
	}
}
