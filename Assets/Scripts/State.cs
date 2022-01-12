using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class State
{
    
    //Action of the state
    public virtual void DoState(PlayerMovement player, GameplayManager gameplayManager) 
    {
        
    }
}

public class Moving : State
{
    //Movement player
    public override void DoState(PlayerMovement player, GameplayManager gameplayManager)
    {
        PlayerMovement plMove = player.GetComponent<PlayerMovement>();
        plMove.enabled = true;
        plMove.PlayerShowMove();
        Debug.Log("e");
    }
}

public class EndTurn : State
{
    //End player Turn + next player
    public override void DoState(PlayerMovement player, GameplayManager gameplayManager)
    {
        Objectif objectif = GameObject.FindObjectOfType<Objectif>();
        gameplayManager.currentstate = new Moving();
        player.enabled = false;
        Debug.Log(player);
    }
}

/*public class CardPLay : State
{
    //player play card
    public override void DoState(GameObject player)
    {
        Debug.Log(5);
    }
}*/

