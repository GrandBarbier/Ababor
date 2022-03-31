using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class Event : MonoBehaviour
{
    public List<PlayerMovement> allMove;
  
    private GameplayManager _gameplayManager;
    private EventManager _eventManager;

    public CasesNeutral thisCase;
    
    public List<Player> allPlayers;
    
    public string eventName;
    
    public List<String> allEvent;

    public List<CasesNeutral> allCase, casesToUnhide;

    public Material basicCaseMat,loseCaseMat,gainCaseMat;
    
    // Start is called before the first frame update
    private void Awake()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
        _eventManager = FindObjectOfType<EventManager>();

    }

    void Start()
    {
        thisCase = gameObject.GetComponent<CasesNeutral>();
        allPlayers = _gameplayManager.allPlayers;
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
        allCase[rdm].baseSecondMat = loseCaseMat;
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
        allCase[rdm].baseSecondMat = gainCaseMat;
        allCase[rdm].ResetColor();
        _gameplayManager.ChangePlayer();
        enabled = false;
    }

    public void GoToCase()
    {
        foreach (Player player in allPlayers)
        {
            player.move.caseNext[0] = thisCase;
            player.player.transform.position = thisCase.transform.position;
        }
        _gameplayManager.ChangePlayer();
    }

    public void SwitchPlayerPlace()
    {
        List<CasesNeutral> casePlayer = new List<CasesNeutral>();
        foreach (Player player in allPlayers)
        {
            casePlayer.Add(player.move.caseNext[0]);
        }

        for (int i = 0; i < allPlayers.Count; i++)
        {
            int rdm = Random.Range(0, casePlayer.Count);
            allPlayers[i].move.caseNext[0] = casePlayer[rdm];
            allPlayers[i].player.transform.position = casePlayer[rdm].transform.position + Vector3.up;
       //     allPlayers[i].move.caseNext[0].ActualCaseFunction();
        }
        _gameplayManager.ChangePlayer();
    }

    public void HideCase()
    {
            _eventManager.HideCase();
    }
    
    public void GetEvent()
    {
        int rdm = Random.Range(0, allEvent.Count);
        eventName = allEvent[rdm];
    }

    public void ResetEvent()
    {
        
    }
}
