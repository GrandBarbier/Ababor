using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using UnityEngine;
using UnityEngine.AI;

public class PlayerMovement : MonoBehaviour
{
    private GameplayManager _gameplayManager;
    public List<GameObject> allCases;
    public List<CasesNeutral> caseNext;
    public GameObject child;
    public int actualMove = 5;
    public NavMeshAgent agent;
    public bool end;
    public int InitialMove;

    [SerializeField] 
    private LayerMask mask;
    
    private Camera cam;
    
    public StateMachine stateMachine;
    
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>(); // Find gamemanager
        allCases = _gameplayManager.allCases;
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
                    if (hit.transform.gameObject.GetComponent<CasesNeutral>().isInRanged)
                    {
                        child.transform.position = hit.transform.position;
                        caseNext[0] = hit.transform.gameObject.GetComponent<CasesNeutral>();
                        end = true;
                    }
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
