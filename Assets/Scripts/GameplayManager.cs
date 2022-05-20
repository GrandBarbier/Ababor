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
    public List<GameObject> menuTrade = new List<GameObject>();
    public GameObject verifMenu,verifMenu2,endMenu,description,objectifMenu,changeTurnBox,changeOrderBox,menuSetting,menuCardExpliquation;
   
    public List<Button> buttonTrade;
    public Queue<Button> buttonQueue;
    
    public List<CasesNeutral> allCases = new List<CasesNeutral>();

    public int playerIndex, treasure, turnWait, islandIndex, playerInTurn, indexTrade;
    public List<int> goldTrade;

    public bool lastTurn,uiTurned,tradeOpen,objectifOpen;
    
    public State currentstate;
    
    public Objectif objectif;
    
    public TMP_Text endText, showPlayerEnd, showExchange;
    public List<TMP_Text> textGold = new List<TMP_Text>();
    
    public Queue<Player> playerQueue = new Queue<Player>();
    public List<Player> allPlayers = new List<Player>();
    public Player endPlayer;
    public Player activPlayer;

    private Queue<PlayerMovement> moveQueue = new Queue<PlayerMovement>();
    public PlayerMovement actualMove;
    public List<PlayerMovement> testmove;
    
    public Queue<PlayerPoint> pointQueue = new Queue<PlayerPoint>();
    public PlayerPoint actualPoint;
    public PlayerPoint playerGive;
    public PlayerPoint playerReceive;
    
    public CardManager cardManager;

    public EndMenu endCalcul;

  [SerializeField]  private AudioSource audioSource;
  [SerializeField]  private AudioSource sfxSource;

  [SerializeField]  private Slider sliderVolume;
  [SerializeField]  private Slider sliderSFX;
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
        SoundSlider();
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

        if (Input.touchCount>0)
        {
            foreach (GameObject obj in GameObject.FindGameObjectsWithTag("Feedback"))
            {
                obj.SetActive(false);
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
    
    public void ChangePlayer()
    {
        Debug.Log("tour+1");
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
            StartCoroutine("ChangeOrderBox");
        }
        else if (endPlayer != null)
        {
            StartCoroutine("ShowPlayerEnd");
        }
        else
        {
            StartCoroutine("ChangeTurnBox");
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
            playerIndex = 0;
        }
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
    
    public void CloseObjectif()
    {
        objectifMenu.SetActive(false);
    }

    public void GiveGold()
    {
        playerGive.gold -= goldTrade[playerGive.index];
        playerReceive.gold += goldTrade[playerGive.index];
        menuTrade[playerGive.index].SetActive(false);
        StartCoroutine("ShowGoldExchange");
        tradeOpen = false;
    }

    public void GoldChangeMore(int value)
    {
        goldTrade[value] += 1;
        if (goldTrade[value] >= playerGive.gold)
        {
            goldTrade[value] = playerGive.gold;
        }
        textGold[value].text = goldTrade[value].ToString();
    }

    public void GoldChangeLess(int value)
    {
        goldTrade[value] -= 1;
        if (goldTrade[value] <=0)
        {
            goldTrade[value] = 0;
        }
        textGold[value].text = goldTrade[value].ToString();
    }
    
    public void OpenMenuTrade(int index)
    {
        
        switch (index)
        {
            case 0 :
                if (tradeOpen == false)
                {
                    menuTrade[0].SetActive(true);
                    tradeOpen =true;
                }
                break;
            case 1:
                
                if (tradeOpen == false)
                {
                    menuTrade[1].SetActive(true);
                    tradeOpen =true;
                }
               
                break;
            case 2 :
                if (tradeOpen == false)
                {
                    menuTrade[2].SetActive(true);
                    tradeOpen = true;
                }
              
                break;
            case 3 :
                if (tradeOpen == false)
                {
                    menuTrade[3].SetActive(true);
                    tradeOpen = true;
                }
                break;
        }
        textGold[index].text = "0";
        goldTrade[index] = 0;
        playerGive = allPlayers[index].point;
    }

    public void CloseTrade()
    {
        foreach (GameObject obj in menuTrade)
        {
            obj.SetActive(false);
            tradeOpen = false;
        }
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

    public void ButtonSetting()
    {
      menuSetting.SetActive(true);  
    }

    public void CloseSetting()
    {
        menuSetting.SetActive(false);
    }

    public void ButtonCard()
    {
        menuCardExpliquation.SetActive(true);
    }

    public void CloseCardExpliquation()
    {
        menuCardExpliquation.SetActive(false);
    }

    public void CancelMove()
    {
        currentstate = new CardPlay();
        currentstate.DoState(actualMove, this);
        verifMenu.SetActive(true);
        verifMenu2.SetActive(true);
        description.gameObject.SetActive(false);
        actualMove.PlayerResetCase();
    }
    
    IEnumerator ChangeTurnBox()
    {
        changeTurnBox.SetActive(true);
        yield return new WaitForSeconds(5f);
        changeTurnBox.SetActive(false);
    }

    IEnumerator ChangeOrderBox()
    {
        changeOrderBox.SetActive(true);
        yield return new WaitForSeconds(5f);
        changeOrderBox.SetActive(false);
    }

    IEnumerator ShowPlayerEnd()
    {
        int text = endPlayer.move.index + 1;
        showPlayerEnd.text += text.ToString();
        showPlayerEnd.gameObject.SetActive(true);
        yield return new WaitForSeconds(5f);
        showPlayerEnd.gameObject.SetActive(false);
    }

    IEnumerator ShowGoldExchange()
    {
        int textReveive = playerReceive.index+1;
        int textGive = playerGive.index+1;
        int textGold = goldTrade[playerGive.index];
        showExchange.text = "Le joueur " + textGive;
        showExchange.text += " donne " + textGold + " d'or au joueur " + textReveive;
        
        showExchange.gameObject.SetActive(true);
        yield return new WaitForSeconds(5f);
        showExchange.gameObject.SetActive(false);
    }

    public void SoundSlider()
    {
        audioSource.volume = sliderVolume.value;
    }
    
    public void SFXSlider()
    {
        audioSource.volume = sliderSFX.value;
    }

    public void ReturnMenu()
    {
        SceneManager.LoadScene(0);
    }
}

public class Player
{
    public GameObject player;
    public PlayerMovement move;
    public PlayerPoint point;
}