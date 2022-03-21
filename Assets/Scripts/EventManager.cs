using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EventManager : MonoBehaviour
{
    
    public List<CasesNeutral> allCase, hiddenCases;
    private GameplayManager _gameplayManager;
    public Material basicCaseMat,loseCaseMat,gainCaseMat,eventCaseMat;

    public List<CasesNeutral> nonNeutralCases;
    
    public List<CasesNeutral> newGainCases = new List<CasesNeutral>();
    public List<CasesNeutral> newLoseCases = new List<CasesNeutral>();

    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
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
    
    public void SwitchGainAndLoseCases()
    {
        foreach (CasesNeutral cases in _gameplayManager.allCases)
        {
            if (cases.nameFunction == "GainCase")
            {
                newLoseCases.Add(cases);
                cases.nameFunction = "LoseCase";
                cases.baseSecondMat = loseCaseMat;
                cases.ResetColor();
            }
            else if (cases.nameFunction == "LoseCase")
            {
                newGainCases.Add(cases);
                cases.nameFunction = "GainCase";
                cases.baseSecondMat = gainCaseMat;
                cases.ResetColor();
            }
        }
    }
    
    public void HideCase()
    {
        nonNeutralCases = new List<CasesNeutral>();
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
    }
}