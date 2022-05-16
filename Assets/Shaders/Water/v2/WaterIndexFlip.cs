using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterIndexFlip : MonoBehaviour
{
    public Renderer rend;

    public int index;
    public float framerate;
    
    public Texture2D[] textures;

    private float time = 0;
    
    void Start()
    {
        
    }
    
    void Update()
    {
        time += Time.deltaTime * framerate;

        if (time >= 1)
        {
            index++;
            time = 0;
            if (index >= textures.Length)
                index = 0;
        }
        
        rend.material.SetTexture("NormalTexture", textures[index]);
    }
}