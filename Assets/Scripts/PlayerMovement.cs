using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class PlayerMovement : MonoBehaviour
{
    private GameplayManager _gameplayManager;
    public List<GameObject> allCases;
    public List<GameObject> caseNext;
    public MousePosition mousePos;
    public GameObject child;
    public int moveValue = 5;
    public NavMeshAgent agent;
    public bool end;

    public StateMachine stateMachine;
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>(); // Find gamemanager
        allCases = _gameplayManager.allCases;
        stateMachine = FindObjectOfType<StateMachine>();
    }

    // Update is called once per frame
    void Update()
    {
        
        if (Input.GetButtonUp("Fire1") && mousePos.caseTouch.CompareTag("Case") )
        {
            if (mousePos.caseTouch.GetComponent<CasesNeutral>().isInRanged)
            {
                child.transform.position = mousePos.caseTouch.transform.position;
                caseNext[0] = mousePos.caseTouch;
                end = true;
                Debug.Log(2);
            }
        }

        if (end)
        {
            PlayerResetCase();
            agent.destination = child.transform.position;
            if (Vector3.Distance(transform.position,child.transform.position) <= 2f )
            {
                Debug.Log(3);
                State endTurn = new EndTurn();
                endTurn.DoState(gameObject);
                end = false;
            }
        }
    }

    public void PlayerShowMove()
    {
       caseNext[0].GetComponent<CasesNeutral>().Outline(caseNext,moveValue);
    }

    public void PlayerResetCase()
    {
        foreach (GameObject obj in allCases)
        {
            obj.GetComponent<CasesNeutral>().ResetColor();
        }
    }

   
}
