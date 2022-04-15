using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor.ShaderGraph.Internal;
using UnityEngine;

public class CausticAnimation : MonoBehaviour
{
    public List<Texture2D> tex;

    public float framerate;

    public int index;

    public Material m;

    private void Awake()
    {
    }

    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        index = (int)(Time.time * framerate) % tex.Count;
        
        m.SetTexture("MainTex", tex[index]);
    }
}
