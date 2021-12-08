using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CasesNeutral : Cases
{
    
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
       
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Outline()
    {
        for (int i = 0; i < nextCases.Count; i++)
        {
           nextCases[i].GetComponent<CasesNeutral>().GetComponent<Renderer>().material.color = Color.blue;
        //  gameObject.GetComponent<Renderer>().material.color = Color.blue;
        }
        
    }
    
}
