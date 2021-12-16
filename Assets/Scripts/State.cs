using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class State
{
    
    //Action of the state
    public virtual void DoState(GameObject player) 
    {
        
    }
}

public class Moving : State
{
    
    //Movement player
    public override void DoState(GameObject player)
    {
        PlayerMovement plMove = player.GetComponent<PlayerMovement>();
        plMove.enabled = true;
        plMove.PlayerShowMove();
    }
}

public class Acting : State
{
    //Action player
    public override void DoState(GameObject player)
    {
        Debug.Log(3);
    }
}

public class EndTurn : State
{
    //End player Turn + next player
    public override void DoState(GameObject player)
    {
        PlayerMovement plMove = player.GetComponent<PlayerMovement>();
        GameplayManager gameplayManager = GameObject.FindObjectOfType<GameplayManager>();
        gameplayManager.currentstate = new Moving();
        gameplayManager.playerIndex++;
        plMove.enabled = false;
        if (gameplayManager.playerIndex>= gameplayManager.allPlayer.Count)
        {
            gameplayManager.ResetIndex();
        }
        gameplayManager.ButtonStart();
    }
}

public class CardPLay : State
{
    //player play card
    public override void DoState(GameObject player)
    {
        Debug.Log(5);
    }
}

public class Playerturn : State
{
    public override void DoState(GameObject player)
    {
        
    }
}