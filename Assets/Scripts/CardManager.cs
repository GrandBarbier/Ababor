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
    
    public GameplayManager gameplayManager;

    public TMP_Text text;
    public TMP_Text textTarget;
    
    public int index, gmIndex;
    
    private bool verif;
    public bool oneTarget;
    
    public Player player;
    public List<Player> allPlayer;
    public Player target;
    
    public string functionName, lastName;
  
    // Start is called before the first frame update
    void Start()
    {
        gameplayManager = FindObjectOfType<GameplayManager>();
        player = gameplayManager.allPlayers[0];
        allPlayer = gameplayManager.allPlayers;
    }

    // Update is called once per frame
    void Update()
    {
         //pl = player.player;
        if (index != gameplayManager.playerIndex && verif)
        {
            Debug.Log("nique");
            gameplayManager.playerIndex = gmIndex;
            verif = false;
        }
    }

    public void OneGreen()
    {
        gmIndex = gameplayManager.playerIndex;
        index = player.move.index;
        player.move.isLast = false;
        gameplayManager.playerIndex = index;
        player.move.enabled = true;
        player.move.actualMove = 1;
        player.move.PlayerShowMove();
        verif = true;
        player.move.actualMove = player.move.InitialMove;
        waitMenu.SetActive(false);
    }

    public void TwoGreen()
    {
        gmIndex = gameplayManager.playerIndex;
        index = player.move.index;
        player.move.isLast = false;
        gameplayManager.playerIndex = index;
        player.move.enabled = true;
        player.move.actualMove = 2;
        player.move.PlayerShowMove();
        player.move.caseNext[0].nextCases[0].isInRanged = false;
        verif = true;
        player.move.actualMove = player.move.InitialMove;
        waitMenu.SetActive(false);
    }

    public void OneBlue()
    {
        gmIndex = gameplayManager.playerIndex;
        player.move.caseNext[0] = player.move.caseNext[0].lastCase;
        player.player.transform.position = player.move.caseNext[0].transform.position;
        player.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
        verif = true;
        waitMenu.SetActive(false);
    }

    public void TwoBlue()
    {
        gmIndex = gameplayManager.playerIndex;
        player.move.caseNext[0] = player.move.caseNext[0].lastCase.lastCase;
        player.player.transform.position = player.move.caseNext[0].transform.position;
        player.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
        verif = true;
        waitMenu.SetActive(false);
    }

    public void ThreeRed()
    {
        player.point.gold -= 3;
        verif = true;
        waitMenu.SetActive(false);
    }

    public void FiveRed()
    {
        player.point.gold -= 5;
        waitMenu.SetActive(false);
    }

    public void ThreeYellow()
    {
        player.point.gold += 3;
        waitMenu.SetActive(false);
    }

    public void FiveYellow()
    {
        player.point.gold += 5;
        waitMenu.SetActive(false);
    }
    public void QueenGreen()
    {
        gmIndex = gameplayManager.playerIndex;
        player.player.transform.position = target.move.caseNext[0].transform.position;
        player.move.caseNext[0] = target.move.caseNext[0];
        player.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
        waitMenu.SetActive(false);
    }

    public void QueenBlue()
    {
        gmIndex = gameplayManager.playerIndex;
        player.player.transform.position = target.move.caseNext[0].transform.position;
        player.move.caseNext[0] = target.move.caseNext[0];
        player.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
        waitMenu.SetActive(false);
    }
    public void QueenRed()
    {
        target.point.gold -= 5;
        player.point.gold += 5;
        waitMenu.SetActive(false);
    }

    public void QueenYellow()
    {
        player.point.gold += gameplayManager.treasure;
        gameplayManager.treasure = 0;
        waitMenu.SetActive(false);
    }

    public void KingGreen()
    {
         CasesNeutral cases = player.move.caseNext[0];
         gmIndex = gameplayManager.playerIndex;
         index = gameplayManager.playerIndex;
         player.move.isLast = false;
         target.move.isLast = false;
         player.player.transform.position = target.move.caseNext[0].transform.position +Vector3.up;
         target.player.transform.position = cases.transform.position + Vector3.up;
         player.move.caseNext[0] = target.move.caseNext[0];
         target.move.caseNext[0] = cases;
         player.move.caseNext[0].ActualCaseFunction();
         target.move.caseNext[0].ActualCaseFunction();
         verif = true;
         waitMenu.SetActive(false);
    }
    
    public void KingBlue()
    {
        CasesNeutral cases = player.move.caseNext[0];
        gmIndex = gameplayManager.playerIndex;
        index = gameplayManager.playerIndex;
        player.move.isLast = false;
        target.move.isLast = false;
        player.player.transform.position = target.move.caseNext[0].transform.position+ Vector3.up;
        target.player.transform.position = cases.transform.position + Vector3.up;
        player.move.caseNext[0] = target.move.caseNext[0];
        target.move.caseNext[0] = cases;
        player.move.caseNext[0].ActualCaseFunction();
        target.move.caseNext[0].ActualCaseFunction();
        verif = true;
        waitMenu.SetActive(false);
    }

    public void KingRed()
    {
        foreach (Player pl in gameplayManager.allPlayers)
        {
            if (pl != player)
            {
                player.point.gold -= 3;
                pl.point.gold += 3;
            }
        }
        waitMenu.SetActive(false);
    }

    public void KingYellow()
    {
        foreach (Player pl in gameplayManager.allPlayers)
        {
            if (pl != player)
            {
                pl.point.gold -= 5;
                player.point.gold += 5;
            }
        }
        waitMenu.SetActive(false);
    }

    public void Jack()
    {
        Invoke(lastName,2);
        
    }
    
    public void ButtonSelectPlayer(int index)
    {
        player = allPlayer[index];
    }

    public void ButtonSelectTarget(int index)
    {
        target = allPlayer[index];
    }

    public void CallCardFunction( )
    {
        Invoke(functionName,5);
        menu.SetActive(false);
        waitMenu.SetActive(true);
    }
    
    public void CallCardFunction1Target( )
    {
        Invoke(functionName,5);
        targetMenu.SetActive(false);
        waitMenu.SetActive(true);
    }
    
    public void CloseMenu()
    {
        menu.SetActive(false);
        text.gameObject.SetActive(false);
        text.text = null;
    }

    public void CloseMenu1Target()
    {
        targetMenu.SetActive(false);
        textTarget.gameObject.SetActive(false);
        textTarget.text = null;
    }
    
    public void OpenCardMenu(string stg, Player pl, string texte)
    {
        menu.SetActive(true);
        text.gameObject.SetActive(true);
        text.text = texte;
        if (functionName != lastName)
        {
            lastName = stg;
        }
        functionName = stg;
        player = pl;
    }
    
    public void OpenCardMenu1Target(string stg, Player pl, string texte)
    {
        targetMenu.SetActive(true);
        textTarget.gameObject.SetActive(true);
        textTarget.text = texte;
        if (functionName != lastName)
        {
            lastName = stg;
        }
        functionName = stg;
        player = pl;
    }
}
