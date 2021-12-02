using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor.IMGUI.Controls;
using UnityEngine;

public abstract class State
{
    
    //Action of the state
    public virtual void DoState() 
    {
        
    }
}

public class Moving : State
{
    //Movement player
    public override void DoState()
    {
        Debug.Log(2);
    }
}

public class Acting : State
{
    //Action player
    public override void DoState()
    {
        Debug.Log(3);
    }
}

public class EndTurn : State
{
    //End player Turn + next player
    public override void DoState()
    {
        Debug.Log(4);
    }
}

public class CardPLay : State
{
    //player play card
    public override void DoState()
    {
        Debug.Log(5);
    }
}