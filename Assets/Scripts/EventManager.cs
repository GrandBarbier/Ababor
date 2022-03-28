using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;
using UnityEngine.SocialPlatforms;
using Random = UnityEngine.Random;

public class EventManager : MonoBehaviour
{
    public List<Player> allPlayers = new List<Player>();

    public List<CasesNeutral> allCase, hiddenCases;
    private GameplayManager _gameplayManager;
    public Material basicCaseMat,loseCaseMat,gainCaseMat,eventCaseMat;

    public  Player[] worstPlayer;

    // Start is called before the first frame update
    void Awake()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
    }

    private void Start()
    {
        worstPlayer = new Player[allPlayers.Count];
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private bool CheckIfHidden(CasesNeutral cases)
    {
        for (int i = 0; i < hiddenCases.Count; i++)
        {
            if (cases == hiddenCases[i])
                return true;
        }
        return false;
    }

    public void AddOneEvent()
    {
        List<CasesNeutral> neutralCases = new List<CasesNeutral>();
        foreach (CasesNeutral cases in _gameplayManager.allCases)
        {
            if (cases.nameFunction == "NeutralCase")
            {
                neutralCases.Add(cases);
            }
        }

        if (neutralCases.Count >= 1)
        {
            int i = Random.Range(0, neutralCases.Count);
            neutralCases[i].nameFunction = "EventCase";
            neutralCases[i].baseSecondMat = eventCaseMat;
            neutralCases[i].ResetColor();
            neutralCases.Clear();
        }
        _gameplayManager.ChangePlayer();
    }

    public void RemoveLoseCases()
    {
        List<CasesNeutral> loseCases = new List<CasesNeutral>();

        foreach (CasesNeutral cases in _gameplayManager.allCases)
        {
            if (cases.nameFunction == "LoseCase")
            {
                loseCases.Add(cases);
            }
        }

        if (loseCases.Count >= 1)
        {
            int i = Random.Range(0, loseCases.Count);
            loseCases[i].nameFunction = "NeutralCase";
            loseCases[i].baseSecondMat = basicCaseMat;
            loseCases[i].ResetColor();
        }
        _gameplayManager.ChangePlayer();
    }
    
    public void SwitchGainAndLoseCases()
    {
        foreach (CasesNeutral cases in _gameplayManager.allCases)
        {
            if (cases.nameFunction == "GainCase")
            {
                cases.nameFunction = "LoseCase";
                cases.baseSecondMat = loseCaseMat;
                cases.ResetColor();
            }
            else if (cases.nameFunction == "LoseCase")
            {
                cases.nameFunction = "GainCase";
                cases.baseSecondMat = gainCaseMat;
                cases.ResetColor();
            }
        }
        _gameplayManager.ChangePlayer();
    }
    
    public void HideCase()
    {
        List<CasesNeutral> nonNeutralCases = new List<CasesNeutral>();
        allCase = _gameplayManager.allCases;
        foreach (CasesNeutral cases in allCase)
        {
            if (cases.nameFunction != "NeutralCase" && !CheckIfHidden(cases) && cases.nameFunction != "ShopCase")
            {
                nonNeutralCases.Add(cases);
            }
        }

        int rdmToHide = Random.Range(4, 6);
        for (int i = 0; i < rdmToHide; i++)
        {
            if (nonNeutralCases.Count == 0)
                return;
            int rdm = Random.Range(0, nonNeutralCases.Count);
            nonNeutralCases[rdm].baseSecondMat = basicCaseMat;
            nonNeutralCases[rdm].ResetColor();
            
            //activate fog particle system
            hiddenCases.Add(nonNeutralCases[rdm]);
            nonNeutralCases.RemoveAt(rdm);
        }
        nonNeutralCases.Clear();
        _gameplayManager.ChangePlayer();
    }

    public void UnhideCase(CasesNeutral caseToUnhide)
    {
        if (caseToUnhide.nameFunction == "GainCase")
        {
            caseToUnhide.baseSecondMat = gainCaseMat;
            //deactivate fog particle
            caseToUnhide.ResetColor();
        }
        else if (caseToUnhide.nameFunction == "LoseCase")
        {
            caseToUnhide.baseSecondMat = loseCaseMat;
            //deactivate fog particle
            caseToUnhide.ResetColor();
        }
        else if (caseToUnhide.nameFunction == "EventCase")
        {
            caseToUnhide.baseSecondMat = eventCaseMat;
            //deactivate fog particle
            caseToUnhide.ResetColor();
        }
        _gameplayManager.ChangePlayer();
    }
    
    public void GiveGoldRanking()
    {
        int worst = 1000;
        
        for (int i = 0; i < allPlayers.Count; i++)
        {
            foreach (Player player in allPlayers)
            {
                if (player.point.point < worst)
                {
                    worstPlayer[i] = player;
                }
            }
        }

        if (_gameplayManager.players.Count == 3)
        {
            worstPlayer[0].point.gold += 10;

            if (worstPlayer[1].point.point == worstPlayer[0].point.point)
            {
                worstPlayer[1].point.gold += 10;
                if (worstPlayer[2].point.point == worstPlayer[1].point.point)
                {
                   worstPlayer[2].point.gold += 10;
                }
                else
                {
                    worstPlayer[2].point.gold += 4;
                }
            }
            else
            {
                worstPlayer[1].point.gold += 8;
                if (worstPlayer[2].point.point == worstPlayer[1].point.point)
                {
                    worstPlayer[2].point.gold += 8;
                }
                else
                {
                    worstPlayer[2].point.gold += 4;
                }
            }
        }
        else if (_gameplayManager.players.Count > 3)
        {
            worstPlayer[0].point.gold += 10;

            if (worstPlayer[1].point.point == worstPlayer[0].point.point)
            {
                worstPlayer[1].point.gold += 10;
                if (worstPlayer[2].point.point == worstPlayer[1].point.point)
                {
                    worstPlayer[2].point.gold += 10;
                    if (worstPlayer[3].point.point == worstPlayer[2].point.point)
                    {
                        worstPlayer[3].point.gold += 10;
                    }
                    else
                    {
                        worstPlayer[3].point.gold += 2;
                    }
                }
                else
                {
                    worstPlayer[2].point.gold += 4;
                    if (worstPlayer[3].point.point == worstPlayer[2].point.point)
                    {
                        worstPlayer[3].point.gold += 4;
                    }
                    else
                    {
                        worstPlayer[3].point.gold += 2;
                    }
                }
            }
            else
            {
                worstPlayer[1].point.gold += 8;
                if (worstPlayer[2].point.point == worstPlayer[1].point.point)
                {
                    worstPlayer[2].point.gold += 8;
                }
                else
                {
                    worstPlayer[2].point.gold += 4;
                }
            }
        }        
    }
}