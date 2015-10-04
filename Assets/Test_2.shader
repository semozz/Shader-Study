Shader "Custom/Test_2" {
	Properties {
		_LightColor("LightColor", Color) = (1.0, 1.0, 1.0)
	}
	
	SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			float3 _LightColor;
			
			struct vertIn {
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
			};
			
            struct vertOut {
                float4 pos:SV_POSITION;
                float3 diffuseColor : TEXCOORD1;
            };

            vertOut vert(vertIn v) {
                vertOut o;
                
                o.pos = mul (UNITY_MATRIX_MVP, v.pos);
                
                float4x4 modelMatrixInverse = _World2Object;
				float3 normalDirection = normalize(float3(mul(float4(v.normal, 0.0), modelMatrixInverse)));
				float3 lightDirection = normalize(float3(_WorldSpaceLightPos0));
				
                o.diffuseColor = dot(-lightDirection, normalDirection);
   				
   				return o;
            }

			fixed4 frag(vertOut i) : SV_Target {
                fixed4 color;
                //float3 diffuse = saturate(i.diffuseColor);
				float3 diffuse = (i.diffuseColor + float3(1, 1, 1) ) / 2.0f;
				
				diffuse = ceil(diffuse * 5) / 5.0f;
				color = float4(_LightColor * diffuse.rgb, 1);
				
				return color;
            }

            ENDCG
        }
    }
 
	FallBack "Diffuse"
}
