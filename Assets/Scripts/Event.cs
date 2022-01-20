using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class Event : MonoBehaviour
{
    public List<PlayerMovement> allMove;
    public GameplayManager gameplayManager;
    public List<PlayerPoint> allPoint;
    public string eventName;
    public List<String> allEvent;
    // Start is called before the first frame update
    void Start()
    {
        allMove = gameplayManager.allMove;
        allPoint = gameplayManager.allPoint;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void EventLessMove()
    {
        foreach (PlayerMovement move in allMove)
        {
            move.actualMove -= 3;
            move.isEvent = true;
        }
        gameplayManager.ChangePlayer();
    }
    
    public void EventMoreMove()
    {
        foreach (PlayerMovement move in allMove)
        {
            move.actualMove += 3;
            move.isEvent = true;
        }
        gameplayManager.ChangePlayer();
    }




    public void GetEvent()
    {
        int rdm = Random.Range(0, allEvent.Count);
        eventName = allEvent[rdm];
    }
    
    
}
