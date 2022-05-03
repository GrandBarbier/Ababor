using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.VFX;

public class Marauder : MonoBehaviour
{
    public GameObject stepL, stepR;

    public ParticleSystem psL, psR;
    
    public float delay;
    
    void Start()
    {
        var mainL = psL.main;
        mainL.startRotation3D = true;
        
        var mainR = psR.main;
        mainR.startRotation3D = true;
    }

    private void Update()
    {
        var mainL = psL.main;
        mainL.startRotationYMultiplier = -(transform.rotation.eulerAngles.y/57f);
        
        var mainR = psR.main;
        mainR.startRotationYMultiplier = -(transform.rotation.eulerAngles.y/57f);
    }

    IEnumerator SetpsCoroutine(float delay)
    {
        stepL.SetActive(true);
        
        yield return new WaitForSeconds(delay);
        
        stepR.SetActive(true);
    }

    public void StartSteps()
    {
        StartCoroutine(SetpsCoroutine(delay));
    }

    public void StopSteps()
    {
        stepL.SetActive(false);
        stepR.SetActive(false);
    }
}