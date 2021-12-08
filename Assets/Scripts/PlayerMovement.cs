using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    private GameplayManager _gameplayManager;
    [SerializeField] List<GameObject> casesPart = new List<GameObject>();
    [SerializeField] List<GameObject> cases = new List<GameObject>();
    [SerializeField] List<GameObject> newCases = new List<GameObject>();
    public List<GameObject> nextPart;
    public List<GameObject> caseNext;
  [SerializeField] private int actualCase;

  public int moveValue = 5;
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>(); // Find gamemanager
        cases = _gameplayManager.allCases ; // assign the cases
        casesPart = _gameplayManager.allPart; // assign the alternative cases
        
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetButtonDown("Fire1"))
        {
            PlayerShowMove(); 
            Debug.Log(nextPart);
        }
    }

    
/*    public void PlayerShowMove1()
    {
        bool startAlt = false;
        int value = 0;
        for (int i = 0; i < moveValue; i++)
        {
            cases[actualCase + i + 1].GetComponent<Renderer>().material.color = Color.blue;
            if (cases[i].layer == 6)
            {
              
               // startAlt = true;
                //value = i;
                
                foreach (GameObject part in nextPart)
                {
                    for (int j = 0; j < moveValue - i; j++)
                    {
                        newCases.Add(part.transform.GetChild(j).gameObject);
                        newCases[j].GetComponent<Renderer>().material.color = Color.blue;
                    }
                }
            }

          /*  if (startAlt)
            {
                Test(value);
            }
           
            
        }
    }*/

    public void PlayerShowMove()
    {
        List<int> next = new List<int>();
        for (int i = 0; i < moveValue; i++)
        {
            for (int j = 0; j < caseNext.Count; j++)
            {
                    caseNext[j].GetComponent<CasesNeutral>().Outline();
                    caseNext = caseNext[j].GetComponent<CasesNeutral>().nextCases;
            }
            Debug.Log(i);
        }
    }
    

   
    
    
    
}
