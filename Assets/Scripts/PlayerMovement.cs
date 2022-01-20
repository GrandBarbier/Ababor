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
    public GameObject child;
    public int actualMove = 5;
    public NavMeshAgent agent;
    public bool end;
    public int InitialMove;
    public  bool isEvent;
    [SerializeField] 
    private LayerMask mask;
    private Camera cam;
    public GameObject menuVerif;
    public GameObject hitObject;
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>(); // Find gamemanager
        foreach (GameObject obj in _gameplayManager.allCases)
        {
            allCases.Add(obj.GetComponent<CasesNeutral>());
        }
        
        _gameplayManager.activPlayer = gameObject;
        cam = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.touchCount == 1)
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
        }
        
        if (end)
        {
            _gameplayManager.cameraControler.GoToPlayer();
            PlayerResetCase(); 
            agent.destination = child.transform.position;
            
            if (Vector3.Distance(transform.position,child.transform.position) <= 1f ) // set end turn
            {
                Debug.Log(4);
                caseNext[0].ActualCaseFunction();
                agent.speed = 0;
                isEvent = false;
                end = false;
            }

            if (isEvent == false)
            {
                actualMove = InitialMove;
            }
        }
        
    }

    public void PlayerShowMove()  // change color of all case in range
    {
       caseNext[0].GetComponent<CasesNeutral>().Outline(caseNext,actualMove);
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
}
