using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class Event : MonoBehaviour
{
    public List<PlayerMovement> allMove;
  
    public GameplayManager _gameplayManager;
    
    public List<Player> allPlayers;
    
    public string eventName;
    
    public List<String> allEvent;

    public List<CasesNeutral> allCase;
  
    // Start is called before the first frame update
    private void Awake()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
    }

    void Start()
    {
        allPlayers = _gameplayManager.allPlayers;
    }

 /*   public void EventLessMove()
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
        foreach (Player player in allPlayers)
        {
            player.move.actualMove += 3;
            player.move.isEvent = true;
        }
        _gameplayManager.actualMove.isEvent = true;
        _gameplayManager.ChangePlayer();
        enabled = false;
    }*/
 private void Update()
 {
     Debug.Log(enabled);
 }

    public void EventMoreLoseCase()
    {
        foreach (CasesNeutral cases in _gameplayManager.allCases)
        {
            if (cases.nameFunction == "NeutralCase")
            {
             allCase.Add(cases);   
            }
        }

        int rdm = Random.Range(0, allCase.Count);
        allCase[rdm].nameFunction = "LoseCase";
        allCase[rdm].baseColor = Color.red;
        allCase[rdm].ResetColor();
        _gameplayManager.ChangePlayer();
        enabled = false;
    }
    
    public void EventMoreGainCase()
    {
        foreach (CasesNeutral cases in _gameplayManager.allCases)
        {
            if (cases.nameFunction == "NeutralCase")
            {
                allCase.Add(cases);   
            }
        }
        int rdm = Random.Range(0, allCase.Count);
        allCase[rdm].nameFunction = "GainCase";
        allCase[rdm].baseColor = Color.yellow;
        allCase[rdm].ResetColor();
        _gameplayManager.ChangePlayer();
        enabled = false;
    }
    
    public void GetEvent()
    {
        int rdm = Random.Range(0, allEvent.Count);
        eventName = allEvent[rdm];
    }
    
}
