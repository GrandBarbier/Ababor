using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class CardManager : MonoBehaviour
{
    public GameObject menu;
    public GameObject waitMenu;
    public GameObject targetMenu;
    public GameObject useCard;
    
    public Image playerSelected;
    public Image targetSelected;
    public Image player1Target;
    
    public GameplayManager gameplayManager;

    public TMP_Text text;
    public TMP_Text textTarget;
    public TMP_Text goldQueen;
    
    public int index, gmIndex;
    
    public bool verif;
    public bool oneTarget;
    public bool numberClub; // use to fix problem of number club card
    public bool headBlueGreen; // use to fix problem fix blue/green heads card 
    public bool openMove;
    public List<bool> playerPlayed;
    
    public Player player;
    public List<Player> allPlayer;
    public Player target;

    public Button button;
    public Button buttonTarget;

    public string functionName, lastName;

    public HardwareManager hardManager;
    

    // Start is called before the first frame update
    void Start()
    {
        gameplayManager = FindObjectOfType<GameplayManager>();
        player = gameplayManager.allPlayers[0];
        allPlayer = gameplayManager.allPlayers;
        foreach (Player pl in allPlayer)
        {
            playerPlayed.Add(pl.point.playedCard);
        }
        hardManager.Colorize();
    }

    // Update is called once per frame
    void Update()
    {
        if (index != gameplayManager.playerIndex && verif)
        {
            gameplayManager.playerIndex = gmIndex;
            ResetIndexPlayer();
            verif = false;
        }

        if (target == null)
        {
            button.gameObject.SetActive(false);
            buttonTarget.gameObject.SetActive(false);
        }
        else
        {
            button.gameObject.SetActive(true);
            buttonTarget.gameObject.SetActive(true);
        }

        goldQueen.text = "Or du trésor : " + gameplayManager.treasure.ToString();
    }

    public void OneGreen()
    {
        gmIndex = gameplayManager.playerIndex;
        index = target.move.index;
        target.move.isLast = false;
        gameplayManager.playerIndex = index;
        target.move.enabled = true;
        target.move.actualMove = 1;
        gameplayManager.currentstate = new Moving();
        gameplayManager.currentstate.DoState(target.move,gameplayManager);
        target.move.PlayerShowMove();
        verif = true;
        target.move.actualMove = target.move.InitialMove;
        waitMenu.SetActive(false);
        numberClub = true;
        useCard.SetActive(true);
    }

    public void TwoGreen()
    {
        gmIndex = gameplayManager.playerIndex;
        index = target.move.index;
        target.move.isLast = false;
        gameplayManager.playerIndex = index;
        target.move.enabled = true;
        target.move.actualMove = 2;
        target.move.PlayerShowMove();
        for (int i = 0; i < target.move.allNextCases.Count/2; i++)
        {
            if (target.move.caseNext[0].nextCases[i].nameFunction != "EndCase")
            {
                target.move.caseNext[0].nextCases[i].isInRange = false;
                target.move.caseNext[0].nextCases[i].ResetColor();
            }
        }
        verif = true;
        target.move.actualMove = target.move.InitialMove;
        waitMenu.SetActive(false);
        numberClub = true;
        useCard.SetActive(true);
    }

    public void OneBlue()
    {
        gmIndex = gameplayManager.playerIndex;
      /*  if (target.move.caseNext[0] == target.move.caseNext[0].lastCase)
        {
        }
        else
        {*/
            target.move.caseNext[0] = target.move.caseNext[0].lastCase;
            Debug.Log("1blue");
      //  }
        target.player.transform.position = target.move.caseNext[0].playerSpot[target.move.index].transform.position;
        target.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
        numberClub = true;
        verif = true;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        gameplayManager.playerIndex--;
        useCard.SetActive(true);
    }

    public void TwoBlue()
    {
        gmIndex = gameplayManager.playerIndex;
        target.move.caseNext[0] = target.move.caseNext[0].lastCase.lastCase;
        Debug.Log("2blue");
        target.player.transform.position = target.move.caseNext[0].playerSpot[target.move.index].transform.position;
        target.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
        verif = true;
        numberClub = true;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        gameplayManager.playerIndex--;
        useCard.SetActive(true);
    }

    public void ThreeRed()
    {
        target.point.gold -= 3;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void FiveRed()
    {
        target.point.gold -= 5;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void ThreeYellow()
    {
        target.point.gold += 3;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void FiveYellow()
    {
        target.point.gold += 5;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
        StartCoroutine("ShowThrowCard");
    }
    public void QueenGreen()
    {
        gmIndex = gameplayManager.playerIndex;
        player.player.transform.position = target.move.caseNext[0].playerSpot[player.move.index].transform.position;
        player.move.caseNext[0] = target.move.caseNext[0];
        player.move.caseNext[0].ActualCaseFunction();
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        numberClub = true;
        useCard.SetActive(true);
    }

    public void QueenBlue()
    {
        gmIndex = gameplayManager.playerIndex;
        player.player.transform.position = target.move.caseNext[0].playerSpot[player.move.index].transform.position;
        player.move.caseNext[0] = target.move.caseNext[0];
        player.move.caseNext[0].ActualCaseFunction();
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        numberClub = true;
        useCard.SetActive(true);
    }
    
    public void QueenRed()
    {
        player.point.gold -= 5;
        target.point.gold += 5;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void QueenYellow()
    {
        target.point.gold += gameplayManager.treasure;
        gameplayManager.treasure = 0;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
        goldQueen.gameObject.SetActive(false);
    }

    public void KingGreen()
    {
         CasesNeutral cases = player.move.caseNext[0];
         gmIndex = gameplayManager.playerIndex;
         index = gameplayManager.playerIndex;
         player.move.isLast = false;
         target.move.isLast = false;
         player.player.transform.position = target.move.caseNext[0].playerSpot[player.move.index].transform.position;
         target.player.transform.position = cases.playerSpot[target.move.index].transform.position;
         player.move.caseNext[0] = target.move.caseNext[0];
         target.move.caseNext[0] = cases;
         verif = true;
         waitMenu.SetActive(false);
         gameplayManager.OpenVerifMenu();
         useCard.SetActive(true);
    }
    
    public void KingBlue()
    {
        CasesNeutral cases = player.move.caseNext[0];
        gmIndex = gameplayManager.playerIndex;
        index = gameplayManager.playerIndex;
        player.move.isLast = false;
        target.move.isLast = false;
        player.player.transform.position = target.move.caseNext[0].playerSpot[player.move.index].transform.position;
        target.player.transform.position = cases.playerSpot[target.move.index].transform.position;
        player.move.caseNext[0] = target.move.caseNext[0];
        target.move.caseNext[0] = cases;
        verif = true;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void KingRed()
    {
        foreach (Player pl in gameplayManager.allPlayers)
        {
            if (pl != target)
            {
                target.point.gold -= 3;
                pl.point.gold += 3;
            }
        }
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void KingYellow()
    {
        foreach (Player pl in gameplayManager.allPlayers)
        {
            if (pl != target)
            {
                pl.point.gold -= 5;
                target.point.gold += 5;
            }
        }
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void Jack()
    {
        waitMenu.SetActive(false);
        Invoke(lastName,1);
        index = gameplayManager.playerIndex;
        verif = true;
        useCard.SetActive(true);
    }
    
    public void ButtonSelectPlayer(int index)
    {
        player = allPlayer[index];
    }

   public void ButtonSelectTarget(int index)
    {
        target = allPlayer[index];
    }

    public void ButtonSelect1Target(int index)
    {
        target = allPlayer[index];
    }

    public void CallCardFunction()
    {
        
        if (player == target)
        {
            Debug.Log("non");
        }
        else
        {
            Invoke(functionName, 5);
            if (functionName == "Jack")
            {
                functionName = lastName;
            }
            menu.SetActive(false);
            waitMenu.SetActive(true);
        }
        playerPlayed[player.point.index] = true;
        hardManager.ShutLightsPlayer(player.point.index);
    }

    public void CallCardFunction1Target()
    {
        
        if (  functionName == "QueenGreen" && target == player)
        {
            Debug.Log("non");
        }
        else if (functionName == "KingGreen" && target == player)
        {
            Debug.Log("non x2");
        }
        else
        {
            Invoke(functionName, 5);
            if (functionName == "Jack")
            {
                functionName = lastName;
            }
            targetMenu.SetActive(false);
            waitMenu.SetActive(true);
        }
        playerPlayed[player.point.index] = true;
        hardManager.ShutLightsPlayer(player.point.index);
    }

    public void CloseMenu()
    {
        menu.SetActive(false);
        text.gameObject.SetActive(false);
        text.text = null;
        if (waitMenu.activeSelf == false)
        {
            gameplayManager.OpenVerifMenu();
        }
    }

    public void CloseMenu1Target()
    {
        targetMenu.SetActive(false);
        textTarget.gameObject.SetActive(false);
        textTarget.text = null;
        if (waitMenu.activeSelf == false)
        {
            gameplayManager.OpenVerifMenu();
        }
        goldQueen.gameObject.SetActive(false);
    }
    
    public void OpenCardMenu(string stg, Player pl, string texte,int index)
    {
        switch (index)
        {
            case 0 :
                menu.transform.rotation = Quaternion.Euler(0,0,0);
                break;
            case 1:
                menu.transform.rotation = Quaternion.Euler(0,0,0);
                break;
            case 2:
                menu.transform.rotation = new Quaternion(0, 0, 180,0);
                break;
            case 3:
                menu.transform.rotation = new Quaternion(0,0,180,0);
                break;
        }
        
        if (waitMenu.activeSelf == false || stg == "Jack")
        {
            menu.SetActive(true);
            text.gameObject.SetActive(true);
            gameplayManager.verifMenu.SetActive(false);
            gameplayManager.verifMenu2.SetActive(false);
            text.text = texte;
            if (functionName == "Jack")
            {
                functionName = stg;
            }
            else
            {
                lastName = functionName;
                functionName = stg;
            }
            player = pl;
        }
    }

    public void OpenCardMenu1Target(string stg, Player pl, string texte, int index)
    {
        switch (index)
        {
            case 0 :
                targetMenu.transform.rotation = Quaternion.Euler(0,0,0);
                break;
            case 1:
                targetMenu.transform.rotation = Quaternion.Euler(0,0,0);
                break;
            case 2:
                targetMenu.transform.rotation = new Quaternion(0,0,180,0);
                break;
            case 3:
                targetMenu.transform.rotation = new Quaternion(0,0,180,0);
                break;
        }

        if (waitMenu.activeSelf == false|| stg == "Jack")
        {
            targetMenu.SetActive(true);
            textTarget.gameObject.SetActive(true);
            gameplayManager.verifMenu.SetActive(false);
            gameplayManager.verifMenu2.SetActive(false);
            textTarget.text = texte;
            if (functionName == "Jack")
            {
                functionName = stg;
            }
            else
            {
                lastName = functionName;
                functionName = stg;
            }
            player = pl;
        }
        
        
        if (functionName == "QueenYellow")
        {
            goldQueen.gameObject.SetActive(true);
        }
    }

    public void ResetIndexPlayer()
    {
        gameplayManager.activPlayer.move.enabled = false;
        gameplayManager.playerIndex = gmIndex;
    }
    
    

    IEnumerator ShowThrowCard()
    {
        useCard.SetActive(true);
        yield return new WaitForSeconds(5f);
        useCard.SetActive(false);
    }
}
