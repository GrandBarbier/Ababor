using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class GameplayManager : MonoBehaviour
{
    public List<GameObject> allPlayer = new List<GameObject>();
    public List<GameObject> allCases = new List<GameObject>();
    public int numberCase;
    public int playerIndex;
    public State currentstate;
  //  public List<GameObject> allAltCases = new List<GameObject>();
    // Start is called before the first frame update
    void Awake()
    {
        allCases = GameObject.FindGameObjectsWithTag("Case").ToList();
        allPlayer = GameObject.FindGameObjectsWithTag("Player").ToList();
        allCases.Reverse();
        numberCase = allCases.Count;
        allCases.Sort(SortByName);
        currentstate = new Moving();
    }

    void Start()
    {
        foreach (GameObject obj in allPlayer)
        {
           obj.GetComponent<PlayerMovement>().enabled = false;
           
        }
        currentstate.DoState(allPlayer[playerIndex]);
    }

    // Update is called once per frame
    void Update()
    {

    }
    
    
    private int SortByName(GameObject object1, GameObject object2) // function to sort cases
    {
       return  object1.GetComponent<CasesNeutral>().index.CompareTo(object2.GetComponent<CasesNeutral>().index);
    }

    public void ButtonStart()
    {
        currentstate.DoState(allPlayer[playerIndex]);
    }

    public void ResetIndex()
    {
        playerIndex = 0;
    }
}
