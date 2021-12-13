using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class PlayerMovement : MonoBehaviour
{
    private GameplayManager _gameplayManager;
    public List<GameObject> allCases;
    public List<GameObject> caseNext;
  [SerializeField] private int actualCase;
    public StateMachine stateMachine;
    public MousePosition mousePos;
    public GameObject child;
    public int moveValue = 5;
    public NavMeshAgent agent;
    public bool end;
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>(); // Find gamemanager
        allCases = _gameplayManager.allCases;
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetButtonDown("Fire1"))
        {
            PlayerShowMove();
            
        }
        if (Input.GetButtonUp("Fire2") && mousePos.caseTouch.CompareTag("Case") )
        {
            if (mousePos.caseTouch.GetComponent<CasesNeutral>().isInRanged)
            {
                child.transform.position = mousePos.caseTouch.transform.position + Vector3.up*2;
                caseNext[0] = mousePos.caseTouch;
                end = true;
            }
        }

        if (end)
        {
            float speed = 10f ;
          
         
            foreach (GameObject obj in allCases)
            {
                obj.GetComponent<CasesNeutral>().ResetColor();
            }
            
            if (transform.position.x != child.transform.position.x && transform.position.z != child.transform.position.z)
            {
                agent.destination = child.transform.position;
              //transform.position = Vector3.MoveTowards(transform.position, child.transform.position, speed * Time.deltaTime);
                Debug.Log(1);
               
            }
            else
            {
                end = false;
            }
           

           
        }
    }

    public void PlayerShowMove()
    {
       caseNext[0].GetComponent<CasesNeutral>().Outline(caseNext,moveValue);
    }

   
}
