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
        Debug.Log("e");
    }
}

public class Acting : State
{
    //Action player
    public override void DoState(GameObject cases)
    {
       
    }
}

public class EndTurn : State
{
    //End player Turn + next player
    public override void DoState(GameObject player)
    {
        PlayerMovement plMove = player.GetComponent<PlayerMovement>();
        GameplayManager gameplayManager = GameObject.FindObjectOfType<GameplayManager>();
        Objectif objectif = GameObject.FindObjectOfType<Objectif>();
        gameplayManager.currentstate = new Moving();
        plMove.enabled = false;
        Debug.Log(player);
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