using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.VFX;

public class Marauder : MonoBehaviour
{
    public GameObject stepL, stepR;
    
    public VisualEffect vfxL, vfxR;
    
    public float delay;
    
    void Start()
    {
        
    }

    private void Update()
    {
        vfxL.SetFloat("Rotation", -transform.rotation.eulerAngles.y);
        vfxR.SetFloat("Rotation", -transform.rotation.eulerAngles.y);
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