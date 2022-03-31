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
        player.enabled = true;
        player.PlayerShowMove();
        gameplayManager.ResetAllPlayerButton();
        gameplayManager.ShowActualPlayer();
    }
}

public class EndTurn : State
{
    //End player Turn + next player
    public override void DoState(PlayerMovement player, GameplayManager gameplayManager)
    {
        gameplayManager.currentstate = new CardPlay();
        gameplayManager.currentstate.DoState(player,gameplayManager);
        gameplayManager.ResetMove();
       
    }
}


public class CardPlay : State
{
    //player play card
    public override void DoState(PlayerMovement player, GameplayManager gameplayManager)
    {
        gameplayManager.OpenVerifMenu();
    }
}

