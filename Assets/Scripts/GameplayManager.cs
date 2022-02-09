using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;

public class GameplayManager : MonoBehaviour
{
    public List<GameObject> players = new List<GameObject>();
    public List<GameObject> allCases = new List<GameObject>();
    public GameObject activPlayer;
    public int playerIndex;
    public State currentstate;
    public Objectif objectif;
    public List<PlayerMovement> allMove;
    public List<PlayerPoint> allPoint;
    public PlayerMovement actualMove;
    public PlayerPoint actualPoint;
    public TMP_Text endText;
    public Queue<GameObject> playerQueue = new Queue<GameObject>();
    public Queue<PlayerMovement> moveQueue = new Queue<PlayerMovement>();
    public Queue<PlayerPoint> pointQueue = new Queue<PlayerPoint>();
    public GameObject verifMenu,endMenu;
    public List<Player> allPlayers = new List<Player>();
    void Awake()
    {
        allCases = GameObject.FindGameObjectsWithTag("Case").ToList();
        players = GameObject.FindGameObjectsWithTag("Player").ToList();

        for (int i = 0; i < players.Count; i++)
        {
            Player pl = new Player();
             pl.player = players[i];
             pl.move = players[i].GetComponent<PlayerMovement>();
             pl.point = players[i].GetComponent<PlayerPoint>();
            allPlayers.Add(pl);
           
        }
        allCases.Reverse();
        allCases.Sort(SortByName);
        foreach (Player obj in allPlayers)
        {
            obj.move.enabled = false;
            allMove.Add(obj.move);
            allPoint.Add(obj.point);
        }
       
        currentstate = new CardPlay();
        
    }

    void Start()
    {
        foreach (GameObject player in players)
        {
            playerQueue.Enqueue(player);
        }
        foreach (PlayerMovement move in allMove)
        {
            moveQueue.Enqueue(move);
        }
        foreach (PlayerPoint point in allPoint)
        {
            pointQueue.Enqueue(point);
        }
        currentstate.DoState(allMove[playerIndex], this);
    }

    // Update is called once per frame
    void Update()
    {
        activPlayer = allPlayers[playerIndex].player;
        actualMove = allPlayers[playerIndex].move;
        actualPoint = allPlayers[playerIndex].point;
        if (playerIndex <= 0)
        {
            playerIndex = 0;
        }
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
       
        currentstate = new EndTurn();
        currentstate.DoState(allMove[playerIndex], this);
        
        playerIndex++;
        if (playerIndex >= allPlayers.Count)
        {
            playerIndex = 0;
        }
        foreach (string stg in objectif.actualObjectif)
        {
            objectif.Invoke(stg,0);
        }
        if (actualMove.isLast)
        {
            ChangePlayerOrder();
        }
        ButtonStart();
        Debug.Log(5);
    }

    public void ButtonYes()
    {
        actualMove.menuVerif.SetActive(false);
        actualMove.end = true;
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

    public void ChangePlayerOrder()
    {
        
        actualMove.isLast = false;
        allMove[0].isLast = true;
        playerQueue.Dequeue(); 
        playerQueue.Enqueue(players[0]); 
      /*  moveQueue.Dequeue();
        moveQueue.Enqueue(allMove[0]);
        pointQueue.Dequeue();
        pointQueue.Enqueue(allPoint[0]);*/
        players = playerQueue.ToList();
        allMove = moveQueue.ToList();
        allPoint = pointQueue.ToList();
        
    }

    public void ResetMove()
    {
        foreach (PlayerMovement move in allMove)
        {
            move.enabled = false;
        }
        
    }

    public void OpenVerifMenu()
    {
        verifMenu.SetActive(true);
    }

    public void OpenEndMenu()
    {
        endMenu.SetActive(true);
    }
    public void ButtonVerifMenuMove()
    {
        currentstate = new Moving();
        currentstate.DoState(actualMove, this);
        verifMenu.SetActive(false);
    }

    public void ButtonEnd()
    {
        currentstate = new EndTurn();
        currentstate.DoState(actualMove,this);
        verifMenu.SetActive(false);
    }
}

public class Player
{
    public GameObject player;
    public PlayerMovement move;
    public PlayerPoint point;
}