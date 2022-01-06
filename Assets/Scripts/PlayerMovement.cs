using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using UnityEngine;
using UnityEngine.AI;

public class PlayerMovement : MonoBehaviour
{
    private GameplayManager _gameplayManager;
    public List<GameObject> allCases;
    public List<GameObject> caseNext;
    public MousePosition mousePos;
    public GameObject child;
    public int actualMove = 5;
    public NavMeshAgent agent;
    public bool end;
    public int InitialMove;
    public StateMachine stateMachine;
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>(); // Find gamemanager
        allCases = _gameplayManager.allCases;
        _gameplayManager.activPlayer = gameObject;
    }

    // Update is called once per frame
    void Update()
    {
        
        if (Input.GetButtonUp("Fire1") && mousePos.caseTouch.CompareTag("Case") )
        {
            if (mousePos.caseTouch.GetComponent<CasesNeutral>().isInRanged) // get case to go to
            {
                child.transform.position = mousePos.caseTouch.transform.position;
                caseNext[0] = mousePos.caseTouch;
                end = true;
            }
        }

        if (end)
        {
            PlayerResetCase(); 
            agent.destination = child.transform.position;
            
            if (Vector3.Distance(transform.position,child.transform.position) <= 1f ) // set end turn
            {
                caseNext[0].GetComponent<CasesNeutral>().ActualCaseFunction();
                end = false;
            }
        }
    }

    public void PlayerShowMove()  // change color of all case in range
    {
       caseNext[0].GetComponent<CasesNeutral>().Outline(caseNext,actualMove);
    }

    public void PlayerResetCase() // Reset the color of all cases
    {
        foreach (GameObject obj in allCases)
        {
            obj.GetComponent<CasesNeutral>().ResetColor();
        }
    }

    public int FindCase()
    {
        int number = 0;
        for (int i = 0; i < allCases.Count; i++)
        {
            if (allCases[i] == caseNext[0] )
            {
                 number = i;
            }
        }

        return number;
    }
}
