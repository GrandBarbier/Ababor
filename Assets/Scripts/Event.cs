using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class Event : MonoBehaviour
{
    public List<PlayerMovement> allMove;
    public GameplayManager _gameplayManager;
    public List<PlayerPoint> allPoint;
    public string eventName;
    public List<String> allEvent;
    // Start is called before the first frame update
    private void Awake()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
    }

    void Start()
    {
        allMove = _gameplayManager.allMove;
        allPoint = _gameplayManager.allPoint;
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

      
        _gameplayManager.actualMove.isEvent = true;
        _gameplayManager.ChangePlayer();
        enabled = false;
    }
    
    public void EventMoreMove()
    {
        foreach (PlayerMovement move in allMove)
        {
            move.actualMove += 3;
            move.isEvent = true;
        }
        
        _gameplayManager.actualMove.isEvent = true;
        _gameplayManager.ChangePlayer();
        enabled = false;
    }
    
    public void GetEvent()
    {
        int rdm = Random.Range(0, allEvent.Count);
        eventName = allEvent[rdm];
    }
}
