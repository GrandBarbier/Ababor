using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;

public class GameplayManager : MonoBehaviour
{
    public List<GameObject> allPlayer = new List<GameObject>();
    public List<GameObject> allCases = new List<GameObject>();
    public GameObject activPlayer;
    public int playerIndex;
    public State currentstate;
    public CameraControlerCHIBRE cameraControler;
    public Objectif objectif;
    public List<PlayerMovement> allMove;
    public List<PlayerPoint> allPoint;
    public PlayerMovement actualMove;
    public PlayerPoint actualPoint;
    public TMP_Text endText;
    void Awake()
    {
        allCases = GameObject.FindGameObjectsWithTag("Case").ToList();
        allPlayer = GameObject.FindGameObjectsWithTag("Player").ToList();
        allCases.Reverse();
        allCases.Sort(SortByName);
        foreach (GameObject obj in allPlayer)
        {
            obj.GetComponent<PlayerMovement>().enabled = false;
            allMove.Add(obj.GetComponent<PlayerMovement>());
            allPoint.Add(obj.GetComponent<PlayerPoint>());
        }
        currentstate = new Moving();
    }

    void Start()
    {
        
        currentstate.DoState(allMove[playerIndex], this);
    }

    // Update is called once per frame
    void Update()
    {
        activPlayer = allPlayer[playerIndex];
        actualMove = allMove[playerIndex];
        actualPoint = allPoint[playerIndex];
    }
    
    
    private int SortByName(GameObject object1, GameObject object2) // function to sort cases
    {
       return  object1.GetComponent<CasesNeutral>().index.CompareTo(object2.GetComponent<CasesNeutral>().index);
    }

    public void ButtonStart()
    {
        currentstate.DoState(allMove[playerIndex], this);
    }

    public void ResetIndex()
    {
        playerIndex = 0;
       
    }
    
    public void ChangePlayer()
    {
        
        State endTurn = new EndTurn();
        endTurn.DoState(allMove[playerIndex], this);
        playerIndex++;
        if (playerIndex>= allPlayer.Count)
        {
            ResetIndex();
        }
        foreach (string stg in objectif.actualObjectif)
        {
            objectif.Invoke(stg,0);
        }
        
        cameraControler.GoToPlayer();
        ButtonStart();
        //Debug.Log(5);
    }

    public void ButtonYes()
    {
        
        actualMove.end = true;
        actualMove.menuVerif.SetActive(false);
    }


    public void FindBestPlayer()
    {
        int best = 0;
        string bestPlayer;
        foreach (PlayerPoint point in allPoint)
        {
            if (point.point >= best)
            {
                best = point.point;
                bestPlayer = point.player.name;
                endText.text = "Gagnant : " + bestPlayer + " Point : " + best;
            }
        }
    }
}
