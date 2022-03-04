using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameplayManager : MonoBehaviour
{
    public List<GameObject> players = new List<GameObject>();
    public List<GameObject> island = new List<GameObject>();
    public GameObject verifMenu,endMenu, secondIsle, firstIsle;
    
    public List<CasesNeutral> allCases = new List<CasesNeutral>();

    public int playerIndex, treasure, turnWait, islandIndex;

    public bool lastTurn;
    
    public State currentstate;
    
    public Objectif objectif;
    
    public TMP_Text endText;
    
    public Queue<Player> playerQueue = new Queue<Player>();
    public List<Player> allPlayers = new List<Player>();
    public Player endPlayer;
    public Player activPlayer;
    
    public Queue<PlayerMovement> moveQueue = new Queue<PlayerMovement>();
    public PlayerMovement actualMove;
    
    public Queue<PlayerPoint> pointQueue = new Queue<PlayerPoint>();
    public PlayerPoint actualPoint;
    
   
    
    public CardManager cardManager;

    void Awake()
    { 
        
        GetCase();
        for(int i = 0; i < players.Count; i++)
        {
            Player pl = new Player();
             pl.player = players[i];
             pl.move = players[i].GetComponent<PlayerMovement>();
             pl.point = players[i].GetComponent<PlayerPoint>();
            allPlayers.Add(pl);
        }
        currentstate = new CardPlay();
    }

    void Start()
    {
        foreach (Player player in allPlayers)
        {
            playerQueue.Enqueue(player);
            moveQueue.Enqueue(player.move);
            pointQueue.Enqueue(player.point);
        }
        currentstate.DoState(allPlayers[playerIndex].move, this);
    }

    // Update is called once per frame
    void Update()
    {
        activPlayer = allPlayers[playerIndex];
        actualMove = allPlayers[playerIndex].move;
        actualPoint = allPlayers[playerIndex].point;
        if (playerIndex <= 0)
        {
            playerIndex = 0;
        }

        if (lastTurn)
        {
            if (turnWait == 0)
            {
                WaitForNextIsland();  
            }
        }
    }

    public int SortByName(CasesNeutral object1, CasesNeutral object2) // function to sort cases
    {
       return  object1.index.CompareTo(object2.index);
    }

    public void ButtonStart()
    {
        currentstate.DoState(allPlayers[playerIndex].move, this);
    }

    public void ResetIndex()
    {
        playerIndex = 0;
    }
    
    public void ChangePlayer()
    {
        currentstate = new EndTurn(); 
        currentstate.DoState(allPlayers[playerIndex].move, this);
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
        foreach (Player player in allPlayers)
        {
            if (player.point.point >= best)
            {
                best = player.point.point;
                bestPlayer = player.point.player.name;
                endText.text = "Gagnant : " + bestPlayer + " Point : " + best;
            }
        }
    }

    public void ChangePlayerOrder()
    {
        actualMove.isLast = false;
        allPlayers[0].move.isLast = true;
        playerQueue.Dequeue(); 
        playerQueue.Enqueue(allPlayers[0]);
        allPlayers = playerQueue.ToList();
        turnWait--;
        if (playerIndex >= allPlayers.Count)
        {
            playerIndex = 0;
        }
        for (int i = 0; i < allPlayers.Count; i++)
        {
            allPlayers[i].move.index = i;
        }
        foreach (Player player in allPlayers)
        {
            player.move.index = allPlayers.IndexOf(player);
        }
    }

    public void ResetMove()
    {
        foreach (Player  player in allPlayers )
        {
            player.move.enabled = false;
        }
    }

    public void OpenVerifMenu()
    {
        verifMenu.SetActive(true);
    }

    public void OpenEndMenu()
    {
       // endMenu.SetActive(true);
       SceneManager.LoadScene("Test clovis 2nd scene");
    }
    public void ButtonVerifMenuMove()
    {
        currentstate = new Moving();
        currentstate.DoState(actualMove, this);
        verifMenu.SetActive(false);
        ResetLast();
        
    }

    public void ButtonEnd()
    {
        currentstate = new EndTurn();
        currentstate.DoState(actualMove,this);
        verifMenu.SetActive(false);
    }

    public void ResetLast()
    {
        allPlayers[allPlayers.Count -1].move.isLast = true;
    }

    public void GetCase()
    {
        foreach (GameObject obj in GameObject.FindGameObjectsWithTag("Case").ToList())
        {
            allCases.Add(obj.GetComponent<CasesNeutral>());
            allCases.Reverse();
            allCases.Sort(SortByName); 
        }
    }

    public void WaitForNextIsland()
    {
        objectif.lastCase = true;
        ChangePlayer();
        foreach (Player player in allPlayers)
        {
            player.move.caseNext[0] = allCases[0];
            player.player.transform.position = player.move.caseNext[0].transform.position;
            player.move.isEnd = false;
        }

        if (allPlayers[0].move.isLast)
        {
        }
        else
        {
            ChangePlayerOrder();
        }
        secondIsle.SetActive(true);
        firstIsle.SetActive(false);
        GetCase();
        foreach (Player player in allPlayers)
        {
            player.move.caseNext[0] = allCases[0];
        }
        lastTurn = false;
        turnWait = -1;
    }
}

public class Player
{
    public GameObject player;
    public PlayerMovement move;
    public PlayerPoint point;
}