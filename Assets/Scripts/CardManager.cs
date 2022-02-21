using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class CardManager : MonoBehaviour
{
    public GameObject menu;
    public GameplayManager gameplayManager;
    public int index, gmIndex;
    public bool verif;
    public Player player;
    public GameObject pl;
    public GameObject m;
    public List<Player> allPlayer;
    public Player target;
    public string functionName;
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
            gameplayManager.playerIndex = gmIndex;
            verif = false;
            
        }

        m = player.player;
    }

    public void GreenFirst()
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
    }

    public void GreenSecond()
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
    }

    public void BlueFirst()
    {
        gmIndex = gameplayManager.playerIndex;
        player.move.caseNext[0] = player.move.caseNext[0].lastCase;
        player.player.transform.position = player.move.caseNext[0].transform.position;
        player.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
        verif = true;
    }

    public void BlueSecond()
    {
        gmIndex = gameplayManager.playerIndex;
        player.move.caseNext[0] = player.move.caseNext[0].lastCase.lastCase;
        player.player.transform.position = player.move.caseNext[0].transform.position;
        player.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
        verif = true;
    }

    public void RedThird()
    {
        player.point.gold -= 3;
        verif = true;
    }

    public void RedFifth()
    {
        player.point.gold -= 5;
    }

    public void YellowThird()
    {
        player.point.gold += 3;
    }

    public void YellowFifth()
    {
        player.point.gold += 5;
    }

    public void BlueQueen()
    {
        gmIndex = gameplayManager.playerIndex;
        player.player.transform.position = target.move.caseNext[0].transform.position;
        player.move.caseNext[0] = target.move.caseNext[0];
        player.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
    }

    public void GreenQueen()
    {
        gmIndex = gameplayManager.playerIndex;
        player.player.transform.position = target.move.caseNext[0].transform.position;
        player.move.caseNext[0] = target.move.caseNext[0];
        player.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
    }

    public void RedQueen()
    {
        player.point.gold -= 5;
        target.point.gold += 5;
    }

    public void YellowQueen()
    {
        player.point.gold += gameplayManager.commonPot;
        gameplayManager.commonPot = 0;
    }

    public void GreenKing()
    {
         CasesNeutral cases = player.move.caseNext[0];
         gmIndex = gameplayManager.playerIndex;
         index = gameplayManager.playerIndex;
         player.move.isLast = false;
         player.player.transform.position = target.move.caseNext[0].transform.position;
         target.player.transform.position = cases.transform.position;
         player.move.caseNext[0] = target.move.caseNext[0];
         target.move.caseNext[0] = cases;
         player.move.caseNext[0].ActualCaseFunction();
         target.move.caseNext[0].ActualCaseFunction();
         verif = true;
    }
    
    public void BlueKing()
    {
        
        gmIndex = player.move.index;
        player.player.transform.position = target.move.caseNext[0].transform.position;
        target.player.transform.position = player.move.caseNext[0].transform.position;
        player.move.caseNext[0].ActualCaseFunction();
        target.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
    }

    public void RedKing()
    {
        foreach (Player pl in gameplayManager.allPlayers)
        {
            if (pl != player)
            {
                player.point.gold -= 3;
                pl.point.gold += 3;
            }
        }
    }

    public void YellowKing()
    {
        foreach (Player pl in gameplayManager.allPlayers)
        {
            if (pl != player)
            {
                pl.point.gold -= 5;
                player.point.gold += 5;
            }
        }
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
      //  player = pl;
        Invoke(functionName,0);
      //  menu.SetActive(false);
    }

    public void OpenCardMenu(string stg, Player pl)
    {
        menu.SetActive(true);
        functionName = stg;
    }
}
