using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CasesNeutral : Cases
{
    
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
        index = _gameplayManager.allCases.IndexOf(gameObject);
        FindNext();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
