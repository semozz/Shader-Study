Shader "Custom/Test" {
	Properties {
		_LightPos("LightPos", Vector) = (0.0, 0.0, 0.0)
		_SpecularFactor("SpeculaFactor", Range(1, 100)) = 20
		_AmbientColor("AmbientColor", Color) = (0.1, 0.1, 0.1)
	}
	
	SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			float4 _LightPos;
			float _SpecularFactor;
			float3 _AmbientColor;
			
			struct vertIn {
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
			};
			
            struct vertOut {
                float4 pos:SV_POSITION;
                float3 diffuseColor : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
                float3 reflection : TEXCOORD3;
            };

            vertOut vert(vertIn v) {
                vertOut o;
                
                o.pos = mul (UNITY_MATRIX_MVP, v.pos);
                
                //float3 lightDir = o.pos.xyz - _LightPos;
   				//lightDir = normalize(lightDir);
   				
   				float3 lightDir = normalize(_WorldSpaceLightPos0);
   				
   				float3 viewDir = normalize(o.pos.xyz - _WorldSpaceCameraPos);
				o.viewDir = viewDir;

                float3 worldNormal = mul( (float3x3)UNITY_MATRIX_MVP, v.normal);
   				worldNormal = normalize(worldNormal);
   				
   				
   				o.pos = mul (UNITY_MATRIX_MVP, v.pos);
                
   				float4x4 modelMatrixInverse = _World2Object;
				float3 normalDirection = normalize(float3(mul(float4(v.normal, 0.0), modelMatrixInverse)));
				float3 lightDirection = normalize(float3(_WorldSpaceLightPos0));
				//float3 diffuseReflection = float3(_LightColor0) * max(0.0, dot(normalDirection, lightDirection));
                
                
                o.pos = mul (UNITY_MATRIX_MVP, v.pos);
                
				
   				o.diffuseColor = dot(-lightDirection, normalDirection);
   				o.reflection = reflect(lightDirection, normalDirection);
   				
                return o;
            }

            fixed4 frag(vertOut i) : SV_Target {
                fixed4 color;
				float3 diffuse = saturate(i.diffuseColor);

  				float3 reflection = normalize(i.reflection);
  				float3 viewDir = normalize(i.viewDir);
  				float3 specular = 0;
				if ( diffuse.x > 0 )
				{
					specular = saturate(dot(reflection, -viewDir ));
					specular = pow(specular, _SpecularFactor);
				}

				//float3 ambient = float3(0.1f, 0.1f, 0.1f);

				color = float4(_AmbientColor + diffuse + specular, 1);
				//color = float4(_AmbientColor + diffuse, 1);
				//color = float4(_AmbientColor + specular, 1);
                return color;
            }

            ENDCG
        }
    }
 
	FallBack "Diffuse"
}
