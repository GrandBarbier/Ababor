using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using Unity.Collections.LowLevel.Unsafe;
using UnityEngine;
using UnityEngine.AI;

public class PlayerMovement : MonoBehaviour
{
    private GameplayManager _gameplayManager;
   
    public List<CasesNeutral> allCases;
    public List<CasesNeutral> caseNext;
    public List<CasesNeutral> allNextCases;

    public int actualMove = 5;
    public int InitialMove;
    
    public NavMeshAgent agent;
    
    public bool end;
    public  bool isEvent;
    
    [SerializeField] 
    
    private LayerMask mask;
    
    private Camera cam;
    
    public GameObject menuVerif;
    public GameObject hitObject;
    public GameObject child;
    
    public Event[] allEvent;
    
    public bool isLast;

    public PlayerPoint point;
    
    public int index, indexCase;
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>(); // Find gamemanager
        allCases = _gameplayManager.allCases;
        allEvent = FindObjectsOfType<Event>();
        _gameplayManager.activPlayer = gameObject;
        cam = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.touchCount == 1)
        {
            CaseToMove();
        }

        if (end)
        {
            menuVerif.SetActive(false);
            PlayerResetCase(); 
           // agent.destination = child.transform.position;
           
            gameObject.transform.position = allNextCases[indexCase].transform.position;
            point.numberCase += indexCase+1;
            //Vector3.MoveTowards(transform.position, child.transform.position,10);
                
            if (Vector3.Distance(transform.position,child.transform.position) <= 1f ) // set end turn
            {
                caseNext[0].ActualCaseFunction();
                agent.speed = 0;
                isEvent = false;
                end = false;
            }
            
            if (isEvent)
            { 
                foreach (Event evt in allEvent) 
                {
                     evt.enabled = true;
                }
            }
            
            if (isEvent == false)
            {
                actualMove = InitialMove;
            }

            allNextCases.Clear();
        }
    }

    public void PlayerShowMove()  // change color of all case in range
    {
       caseNext[0].Outline(caseNext,actualMove);
       
    }

    public void PlayerResetCase() // Reset the color of all cases
    {
        foreach (CasesNeutral obj in allCases)
        {
            obj.ResetColor();
        }
    }

    public int FindCase()
    {

        for (int i = 0; i < allCases.Count; i++)
        {
            if (allCases[i].gameObject == hitObject)
            {
                caseNext[0] = allCases[i];
            }
        }
        
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

    public void CaseToMove()
    {
        if (Input.GetTouch(0).phase == TouchPhase.Ended)
        {
            var touchRay = cam.ScreenPointToRay(Input.GetTouch(0).position);

            if (Physics.Raycast(touchRay, out RaycastHit hit, Mathf.Infinity, mask))
            {
                foreach (CasesNeutral cases in allCases)
                {
                    if (hit.transform.gameObject == cases.gameObject && cases.isInRanged)
                    {
                        hitObject = cases.gameObject;
                        child.transform.position = hitObject.transform.position;
                        caseNext[0] = cases;
                        indexCase = allNextCases.IndexOf(cases);
                        menuVerif.SetActive(true);
                        FindCase();
                        agent.speed = 7;
                    }
                }
            }
            else
            {
                menuVerif.SetActive(false);
            }
        }
        allNextCases.Sort(_gameplayManager.SortByName);
    }
}
