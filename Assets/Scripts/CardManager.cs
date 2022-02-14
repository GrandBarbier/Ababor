using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CardManager : MonoBehaviour
{
    public GameObject menu;
    public GameplayManager gameplayManager;
    public int index;
    public int gmIndex;
    public bool verif;
    public Player player;
    public GameObject pl;
    public PlayerMovement m;
    public PlayerPoint p;
    
    // Start is called before the first frame update
    void Start()
    {
        gameplayManager = FindObjectOfType<GameplayManager>();
        player = gameplayManager.allPlayers[0];
    }

    // Update is called once per frame
    void Update()
    {
        pl = player.player;
        if (index != gameplayManager.playerIndex && verif)
        {
            gameplayManager.playerIndex = gmIndex;
            verif = false;
        }
    }

    public void FirstClub()
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

    public void SecondClub()
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

    public void FirstSpades()
    {
        gmIndex = gameplayManager.playerIndex;
        player.move.caseNext[0] = player.move.caseNext[0].lastCase;
        player.player.transform.position = player.move.caseNext[0].transform.position;
        player.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
        verif = true;
        // gameplayManager.playerIndex--;
    }

    public void SecondSpades()
    {
        gmIndex = gameplayManager.playerIndex;
        player.move.caseNext[0] = player.move.caseNext[0].lastCase.lastCase;
        player.player.transform.position = player.move.caseNext[0].transform.position;
        player.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
        verif = true;
        // gameplayManager.playerIndex--;

    }

    public void ThirdHeart()
    {
        player.point.gold -= 3;
        verif = true;
    }

    public void FifthHeart()
    {
        player.point.gold -= 5;
    }

    public void ThirdDiamond()
    {
        player.point.gold += 3;
    }

    public void FifthDiamond()
    {
        player.point.gold += 5;
    }

    public void ButtonSelectPlayer(int Index)
    {
        player = gameplayManager.allPlayers[Index];
    }
    
   
}
