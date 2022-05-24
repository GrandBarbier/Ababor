using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using Random = UnityEngine.Random;

public class Event : MonoBehaviour
{
    public List<PlayerMovement> allMove;
  
    private GameplayManager _gameplayManager;
    private EventManager _eventManager;

    public CasesNeutral thisCase;
    
    public List<Player> allPlayers;

    public TMP_Text tmpDescription;
    
    public string eventName;
    
    public List<String> allEvent;
    public string description;
    
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
        tmpDescription.text = "Transforme une case neutre en case perte";
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
        if (_gameplayManager.cardManager.numberClub == false)
        {
            _gameplayManager.ChangePlayer();
        }
        else
        {
            _gameplayManager.cardManager.numberClub = false;
            _gameplayManager.cardManager.ResetIndexPlayer();
            _gameplayManager.currentstate = new CardPlay();
        }
        enabled = false;
    }
    
    public void EventMoreGainCase()
    {
        tmpDescription.text = "Transforme une case neutre en case gain";
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
        if (_gameplayManager.cardManager.numberClub == false)
        {
            _gameplayManager.ChangePlayer();
        }
        else
        {
            _gameplayManager.cardManager.numberClub = false;
            _gameplayManager.cardManager.ResetIndexPlayer();
            _gameplayManager.currentstate = new CardPlay();
        }
        enabled = false;
    }

    public void GoToCase()
    {
        tmpDescription.text = "Tout les joueurs vont sur cette case";
        foreach (Player player in allPlayers)
        {
            player.move.caseNext[0] = thisCase;
            player.player.transform.position = thisCase.transform.position;
        }
        if (_gameplayManager.cardManager.numberClub == false)
        {
            _gameplayManager.ChangePlayer();
        }
        else
        {
            _gameplayManager.cardManager.numberClub = false;
            _gameplayManager.cardManager.ResetIndexPlayer();
            _gameplayManager.currentstate = new CardPlay();
        }
    }

    public void SwitchPlayerPlace()
    {
        tmpDescription.text = "Les joueurs prenne la place d'autre joueur de manière aléatoire";
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
        if (_gameplayManager.cardManager.numberClub == false)
        {
            _gameplayManager.ChangePlayer();
        }
        else
        {
            _gameplayManager.cardManager.numberClub = false;
            _gameplayManager.cardManager.ResetIndexPlayer();
            _gameplayManager.currentstate = new CardPlay();
        }
    }

    public void HideCase()
    {
        tmpDescription.text= "4 à 6 cases a effet sont caché jusqu'à ce qu'un joueur arrive dessus";
        _eventManager.HideCase();
    }

    public void AddOneEvent()
    {
        tmpDescription.text = "Transforme une case neutre en case event";
        _eventManager.AddOneEvent();
    }

    public void RemoveLoseCaeses()
    {
        tmpDescription.text = "Enlève une case perte d'or";
        _eventManager.RemoveLoseCases();
    }

    public void SwitchGainAndLoseCases()
    {
        tmpDescription.text = "Echange les cases gain et perte";
        _eventManager.SwitchGainAndLoseCases();
    }

    public void GiveGoldRanking()
    {
        tmpDescription.text = "Donne de l'or a tout les joueurs en fonction du classement";
        _eventManager.GiveGoldRanking();
    }
    
    public void GetEvent()
    {
        int rdm = Random.Range(0, allEvent.Count);
        eventName = allEvent[rdm];
        tmpDescription.transform.parent.gameObject.SetActive(true);
        tmpDescription.transform.gameObject.SetActive(true);
    }
}
