using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleDestroyer : MonoBehaviour
{
    public ParticleSystem ps;

    public float time;
    
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (ps.time >= time)
        {
            Destroy(gameObject);
        }
    }
}
