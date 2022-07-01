#ifndef UNIVERSAL_COMMON_INCLUDED
#define UNIVERSAL_COMMON_INCLUDED

struct ForwardLight
{
    float3 m_worldPos;
    float m_enabled;
    float3 m_color;
    float m_range;
    float m_lightAttenuation;
};

struct LightIndex
{
    int buff;
};

#endif