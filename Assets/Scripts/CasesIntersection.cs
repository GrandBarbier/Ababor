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
        FindNext();
        totalCase = FindObjectsOfType<CasesNeutral>().Length;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public override void FindNext()
    {
        nextCases.Add(_gameplayManager.allCases[index+1]);
        nextCases.Add(_gameplayManager.allCases[totalCase]);
    }

   
}
