using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class GameplayManager : MonoBehaviour
{
    public List<GameObject> allPlayer = new List<GameObject>();
    public List<GameObject> allCases = new List<GameObject>();
    public GameObject activPlayer;
    public int playerIndex;
    public State currentstate;
    private CameraController cameraControler;
    
    void Awake()
    {
        allCases = GameObject.FindGameObjectsWithTag("Case").ToList();
        allPlayer = GameObject.FindGameObjectsWithTag("Player").ToList();
        allCases.Reverse();
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
        activPlayer = allPlayer[playerIndex];
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
    
    public void ChangePlayer()
    {
        
        State endTurn = new EndTurn();
        endTurn.DoState(allPlayer[playerIndex]);
       playerIndex++;
        if (playerIndex>= allPlayer.Count)
        {
            ResetIndex();
        }
        cameraControler.GoToPlayer();
        ButtonStart();
    }
}
