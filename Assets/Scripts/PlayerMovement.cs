using System;
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

    void Awake()
    {
        transform.position = caseNext[0].transform.position;
        
    }

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
            gameObject.transform.position = allNextCases[indexCase].transform.position + new Vector3(0,0.1f,0);
            point.numberCase += indexCase+1;
            
            if (Vector3.Distance(transform.position,child.transform.position) <= 1f ) // set end turn
            {
                caseNext[0].ActualCaseFunction();
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
            Debug.Log(1);
            if (Physics.Raycast(touchRay, out RaycastHit hit, Mathf.Infinity, mask))
            {
                Debug.Log(2);
                hitObject = hit.transform.gameObject;
                foreach (CasesNeutral cases in allCases)
                {
                    Debug.Log(3);
                    if (hit.transform.gameObject == cases.gameObject && cases.isInRanged)
                    {
                        Debug.Log(4);
                        hitObject = cases.gameObject;
                        child.transform.position = hitObject.transform.position;
                        caseNext[0] = cases;
                        indexCase = allNextCases.IndexOf(cases);
                        menuVerif.SetActive(true);
                        FindCase();
                    }
                }
            }
            else
            {
                menuVerif.SetActive(false);
                Debug.Log(5);
            }
        }
        allNextCases.Sort(_gameplayManager.SortByName);
    }
}
