using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameplayManager : MonoBehaviour
{
    public List<GameObject> players = new List<GameObject>();
    public List<GameObject> island = new List<GameObject>();
    public GameObject verifMenu,verifMenu2,/*endMenu,*/ secondIsle, firstIsle, menuTrade,description,objectifMenu;
   
    public List<Button> buttonTrade;
    public Queue<Button> buttonQueue;
    
    public List<CasesNeutral> allCases = new List<CasesNeutral>();

    public int playerIndex, treasure, turnWait, islandIndex, goldTrade, playerInTurn;

    public bool lastTurn,uiTurned,objectifOpen;
    
    public State currentstate;
    
    public Objectif objectif;
    
    public TMP_Text endText,textGold;
    
    public Queue<Player> playerQueue = new Queue<Player>();
    public List<Player> allPlayers = new List<Player>();
    public Player endPlayer;
    public Player activPlayer;

    public Queue<PlayerMovement> moveQueue = new Queue<PlayerMovement>();
    public PlayerMovement actualMove;
    public List<PlayerMovement> testmove;
    
    public Queue<PlayerPoint> pointQueue = new Queue<PlayerPoint>();
    public PlayerPoint actualPoint;
    public PlayerPoint playerGive;
    public PlayerPoint playerReceive;
    
    public CardManager cardManager;

  //  public EndMenu endCalcul;

    void Awake()
    { 
        
        GetCases();
        for (int i = 0; i < players.Count; i++)
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
        activPlayer = allPlayers[0];
        foreach (Player player in allPlayers)
        {
            playerQueue.Enqueue(player);
            moveQueue.Enqueue(player.move);
            pointQueue.Enqueue(player.point);
        }

        testmove = moveQueue.ToList();
        currentstate.DoState(allPlayers[playerIndex].move, this);
        ShowActualPlayer();
        
    }

    // Update is called once per frame
    void Update()
    {
        activPlayer = allPlayers[playerIndex];
        actualMove = allPlayers[playerIndex].move;
        actualPoint = allPlayers[playerIndex].point;
        
        if (playerIndex < 0)
        {
            playerIndex = 0;
        }

        if (lastTurn)
        {
            if (turnWait == 0)
            { 
                NextIsland();    
            }
        }

        if (objectifOpen && Input.touchCount>0)
        {
            objectifMenu.SetActive(false);
            objectifOpen = false;
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
        ShowActualPlayer();
    }

    public void ButtonYes()
    {
        actualMove.end = true;
        cardManager.verif = false;
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
        playerQueue.Enqueue(allPlayers[0]);
        playerQueue.Dequeue();
        allPlayers = playerQueue.ToList();
        moveQueue.Enqueue(allPlayers[0].move);
        moveQueue.Dequeue();
        testmove = moveQueue.ToList();
        buttonTrade.Add(buttonTrade[0]);
        buttonTrade.RemoveAt(0);
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
        ShowActualPlayer();
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
        verifMenu2.SetActive(true);
       // Debug.Log("testing");
    }

   /*public void OpenEndMenu()
    {
       endMenu.SetActive(true);
       for (int i = 0; i < allPlayers.Count; i++)
       {
           endCalcul.PointCalcul(allPlayers[i].point,i);
       }
    }*/
    
    public void ButtonVerifMenuMove()
    {
        currentstate = new Moving();
        currentstate.DoState(actualMove, this);
        verifMenu.SetActive(false);
        verifMenu2.SetActive(false);
        description.gameObject.SetActive(false);
        ResetLast();
    }

    public void ButtonEnd()
    {
        currentstate = new EndTurn();
        currentstate.DoState(actualMove,this);
        verifMenu.SetActive(false);
        verifMenu2.SetActive(false);
    }

    public void ResetLast()
    {
        allPlayers[allPlayers.Count -1].move.isLast = true;
    }

    public void GetCases()
    {
        foreach (GameObject obj in GameObject.FindGameObjectsWithTag("Case").ToList())
        {
            allCases.Add(obj.GetComponent<CasesNeutral>());
            allCases.Reverse();
            allCases.Sort(SortByName);
        }
    }

    public void NextIsland()
    {
        ChangePlayer();
        foreach (Player player in allPlayers)
        {
            player.move.caseNext[0] = allCases[0];
            player.player.transform.position = player.move.caseNext[0].transform.position;
            player.move.isEnd = false;
        }

      /*  if (allPlayers[0].move.isLast)
        {
        }
        else
        {
            ChangePlayerOrder();
            playerIndex = 0;
        }*/
        island[islandIndex].SetActive(true);
        island[islandIndex-1].SetActive(false);
        allCases.Clear();
        GetCases();
        foreach (Player player in allPlayers)
        {
            player.move.caseNext[0] = allCases[0];
        }
        lastTurn = false;
        turnWait = -1;
    }

    public IEnumerator OpenObjectif()
    {
        objectifMenu.SetActive(true);
        yield return new WaitForSeconds(.2f);
        objectifOpen = true;
    }

    public void GiveGold()
    {
        playerGive.gold -= goldTrade;
        playerReceive.gold += goldTrade;
        goldTrade = 0;
        menuTrade.SetActive(false);
    }

    public void GoldChange(int value)
    {
        goldTrade += value;
        if (goldTrade <=0)
        {
            goldTrade = 0;
        }

        if (goldTrade >= playerGive.gold)
        {
            goldTrade = playerGive.gold;
        }
        textGold.text = goldTrade.ToString();
    }

    public void OpenMenuTrade(PlayerPoint point)
    {
        foreach (Button button in buttonTrade)
        {
            if (EventSystem.current.currentSelectedGameObject == button.gameObject)
            {
                menuTrade.transform.rotation = button.gameObject.transform.rotation;
            }
        }
        bool open = menuTrade.activeSelf;
        textGold.text = "0";
        menuTrade.SetActive(!open);
        playerGive = point;
    }

    public void TargetTrade(PlayerPoint point)
    {
        playerReceive = point;
    }

    public void TurnUi()
    {
        if (uiTurned == false)
        {
            for (int i = 0; i < buttonTrade.Count; i++)
            {
                switch (i)
                {
                    case 3:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0,0,140);
                        break;
                    case 2:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0, 0, -140);
                        break;
                    case 1:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0, 0, -45);
                        break;
                    case 0:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0, 0, 45);
                        break;
                }
            }
            uiTurned = true;
        }
        else
        {
            for (int i = 0; i < buttonTrade.Count; i++)
            {
                switch (i)
                {
                    case 3:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0,0,180);
                        break;
                    case 2:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0, 0, 180);
                        break;
                    case 1:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0, 0, 0);
                        break;
                    case 0:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0, 0, 0);
                        break;
                }
            }
            uiTurned = false; 
        }
    }

    public void ChangeIsleButton()
    {
        islandIndex++;
        island[islandIndex].SetActive(true);
        island[islandIndex-1].SetActive(false);
        GetCases();
        foreach (Player player in allPlayers)
        {
            player.move.caseNext[0] = allCases[0];
        }
    }

    public void ShowActualPlayer()
    {
        playerInTurn = allPlayers[playerIndex].move.index;
        foreach (Button button in buttonTrade)
        {
            if (buttonTrade.IndexOf(button) == playerInTurn)
            {
                button.image.color = Color.white;
            }
            else
            {
                button.image.color = Color.gray;
            }
        }
    }

    public void CheckLast()
    {
        Debug.Log(playerQueue.Peek().move);
        playerQueue.Dequeue();
    }

    public void ResetAllPlayerButton()
    {
        foreach (Button button in buttonTrade)
        {
            button.image.color = Color.white;
        }
    }

    public void ButtonObjectif()
    {
        StartCoroutine(OpenObjectif());
    }
}

public class Player
{
    public GameObject player;
    public PlayerMovement move;
    public PlayerPoint point;
}