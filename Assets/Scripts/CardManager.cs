using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CardManager : MonoBehaviour
{
    public GameObject menu;
    public GameplayManager gameplayManager;
   
    
    // Start is called before the first frame update
    void Start()
    {
        gameplayManager = FindObjectOfType<GameplayManager>();
    }

    // Update is called once per frame
    void Update()
    {
       
        
    }

    public void FirstClub()
    {
        Player player = gameplayManager.allPlayers[0];
        player.move.enabled = true;
        
    }
    public void SecondClub()
    {
        Player player = gameplayManager.allPlayers[0];
        player.move.enabled = true;
        player.move.actualMove = 2;
        player.move.PlayerShowMove();
        player.move.caseNext[0].nextCases[0].isInRanged = false;

    }

    public void FirstSpades()
    {
        Player player = gameplayManager.allPlayers[0];
        player.move.caseNext[0] = player.move.caseNext[0].lastCase;
        player.player.transform.position = player.move.caseNext[0].transform.position;
        player.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex--;
    }

    public void SecondSpades()
    {
        Player player = gameplayManager.allPlayers[0];
        player.move.caseNext[0] = player.move.caseNext[0].lastCase.lastCase;
        player.player.transform.position = player.move.caseNext[0].transform.position;
        player.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex--;
    }

    public void ThirdHeart()
    {
        Player player = gameplayManager.allPlayers[0];
        player.point.gold -= 3;
    }

    public void FifthHeart()
    {
        Player player = gameplayManager.allPlayers[0];
        player.point.gold -= 5;
    }

    public void ThirdDiamond()
    {
        Player player = gameplayManager.allPlayers[0];
        player.point.gold += 3;
    }

    public void FifthDiamond()
    {
        Player player = gameplayManager.allPlayers[0];
        player.point.gold += 5;
    }

   
}
