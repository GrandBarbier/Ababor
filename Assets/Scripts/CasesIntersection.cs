using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CasesIntersection : Cases
{
    public int totalCase;
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
        index = _gameplayManager.allCases.IndexOf(gameObject);
//        totalCase = GameObject.FindGameObjectsWithTag("AltCase").Length;
    }

    // Update is called once per frame
    void Update()
    {
        
    }



   
}
