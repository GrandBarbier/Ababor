using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class Event : MonoBehaviour
{
    public List<PlayerMovement> allMove;
  
    public GameplayManager _gameplayManager;

    public CasesNeutral thisCase;
    
    public List<Player> allPlayers;
    
    public string eventName;
    
    public List<String> allEvent;

    public List<CasesNeutral> allCase;

    public Material basicCaseMat,loseCaseMat,gainCaseMat;
    
    // Start is called before the first frame update
    private void Awake()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
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
            allPlayers[i].player.transform.position = casePlayer[rdm].transform.position;
       //     allPlayers[i].move.caseNext[0].ActualCaseFunction();
        }
    }

    public void HideCase()
    {
        List<CasesNeutral> caseSpecial = new List<CasesNeutral>();
        allCase = _gameplayManager.allCases;
        foreach (CasesNeutral cases in allCase)
        {
            if (cases.nameFunction != "NeutralCase")
            {
                caseSpecial.Add(cases);
            }
        }

        for (int i = 0; i < 5; i++)
        {
            int rdm = Random.Range(0, caseSpecial.Count);
            caseSpecial[rdm].baseSecondMat = basicCaseMat;
            caseSpecial[rdm].ResetColor();
         /*Material[] caseMats = caseSpecial[rdm].renderer.materials;
            caseMats[1] = basicCaseMat;
            caseSpecial[rdm].renderer.materials = caseMats;*/
            caseSpecial.RemoveAt(rdm);
            allCase.RemoveAt(rdm);
        }
        _gameplayManager.ChangePlayer();
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
