#ifndef WAVES_INCLUDED
#define WAVES_INCLUDED

void Waves_float(float3 Position, float Steepness, float Wavelength, float2 Direction, float Time, out float3 Pos, out float3 Normal)
{	
    float3 p = Position;

    float k = 2 * PI / Wavelength;
    float c = sqrt(9.8 / k);
    float2 d = normalize(Direction);
    float f = k * (dot(d, p.xy) - c * Time);
    float a = Steepness / k;
    p.x += d.x * (a * cos(f));
    p.z = a * sin(f);
    p.y += d.y * (a * cos(f));

    float3 tangent = float3(1 - d.x * d.x * (Steepness * sin(f)), d.x * (Steepness * cos(f)), -d.x * d.y * (Steepness * sin(f)));
    float3 binormal = float3(-d.x * d.y * (Steepness * sin(f)), d.y * (Steepness * cos(f)), 1 - d.y * d.y * (Steepness * sin(f)));
    float3 normal = normalize(cross(binormal, tangent));

    Pos = p;
    Normal = normal;
}

#endif