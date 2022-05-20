using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using Random = UnityEngine.Random;

public class Objectif : MonoBehaviour
{
    private GameplayManager _gameplayManager;
    
    public List<string> allLateObjectifs;
    public List<string> allMidObjectifs;
    public List<string> allEarlyObjectifs;
    public List<string> actualObjectif;
    public List<string> baseObjectif;
    
    public List<string> descriptionsEarly;
    public List<string> descriptionMid;
    public List<string> descriptionLate;
    public List<string> actualDescription;

    public List<int> scoreEarly;
    public List<int> scoreMid;
    public List<int> scoreLate;
    public List<int> allScore;
    
    public List<PlayerPoint> allPlayerPoint;
    public PlayerPoint pointWinner;
    
    public bool lastCase;
    
    public List<TMP_Text> text;
    // public List<TMP_Text> score;

    private void Awake()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
    }

    void Start()
    {
        
        for (int i = 0; i < _gameplayManager.allPlayers.Count; i++)
        {
            allPlayerPoint.Add(_gameplayManager.allPlayers[i].point);
        }

        for (int i = 0; i <= allPlayerPoint.Count/3; i++)
        {
            int rdm = Random.Range(0, allEarlyObjectifs.Count);
            actualObjectif.Add(allEarlyObjectifs[rdm]);
            allEarlyObjectifs.Remove(allEarlyObjectifs[rdm]);
            actualDescription.Add(descriptionsEarly[rdm]);
            descriptionsEarly.Remove(descriptionsEarly[rdm]);
            allScore.Add(scoreEarly[rdm]);
            scoreEarly.Remove(scoreEarly[rdm]);
        }
        for (int i = 0; i <= allPlayerPoint.Count/3; i++)
        {
            int rdm = Random.Range(0, allMidObjectifs.Count);
            actualObjectif.Add(allMidObjectifs[rdm]);
            allMidObjectifs.Remove(allMidObjectifs[rdm]);
            actualDescription.Add(descriptionMid[rdm]);
            descriptionMid.Remove(descriptionMid[rdm]);
            allScore.Add(scoreMid[rdm]);
            scoreMid.Remove(scoreMid[rdm]);
        }
        
        for (int i = 0; i <= allPlayerPoint.Count/3; i++)
        {
            int rdm = Random.Range(0, allLateObjectifs.Count);
            actualObjectif.Add(allLateObjectifs[rdm]);
            allLateObjectifs.Remove(allLateObjectifs[rdm]);
            actualDescription.Add(descriptionLate[rdm]);
            descriptionLate.Remove(descriptionLate[rdm]);
            allScore.Add(scoreLate[rdm]);
            scoreLate.Remove(scoreLate[rdm]);
        }
        
        
        foreach (PlayerPoint player in allPlayerPoint)
        {
            foreach (string stg in actualObjectif)
            {
                player.objectifVerif.Add(false);
            }
        }

        for (int i = 0; i < text.Count; i++)
        {
            text[i].text = actualDescription[i];
        }
        baseObjectif = actualObjectif;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void ShopEarly()
    {
        bool verif = false;
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            if (obj.numberShopCase == 1 && verif == false)
            {
                obj.point += 10;
                verif = true;
                obj.objectifVerif[baseObjectif.IndexOf("ShopEarly")] = true;
            }
        }
        if (verif)
        {
            actualObjectif.Remove("ShopEarly");
        }
    }

    public void ShopMid()
    {
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            bool verif = obj.objectifVerif[baseObjectif.IndexOf("ShopMid")];   
            if (obj.numberShopCase >= 2 && verif == false)
            {
                obj.point += 20;
                obj.objectifVerif[baseObjectif.IndexOf("ShopMid")] = true;
            }
        }
    }
    
    public void ShopLate()
    {
        List<int> intList = new List<int>();
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            intList.Add(obj.numberShopCase);
        }
        int best = Mathf.Max(intList.ToArray());
        foreach (PlayerPoint player in allPlayerPoint )
        {
            if (best == player.numberShopCase && lastCase)
            {
                best = player.numberShopCase;
                player.point += 30;
                player.objectifVerif[baseObjectif.IndexOf("ShopLate")] = true;
            }
        }
    }

    public void GoldEarly()
    {
        bool verif = false;
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            if (obj.numberGainCase == 1 && verif == false)
            {
                obj.point += 10;
                verif = true;
                obj.objectifVerif[baseObjectif.IndexOf("GoldEarly")] = true;
            }
        }
        if (verif)
        {
            actualObjectif.Remove("GoldEarly");
        }
    }
    
    public void GoldMid()
    {
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            bool verif = obj.objectifVerif[baseObjectif.IndexOf("GoldMid")];   
            if (obj.numberGainCase >= 2 && verif == false)
            {
                obj.point += 20;
                obj.objectifVerif[baseObjectif.IndexOf("GoldMid")] = true;
            }
        }
    }

    public void GoldLate()
    {
       
        List<int> intList = new List<int>();
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            intList.Add(obj.numberGainCase);
        }
        int best = Mathf.Max(intList.ToArray());
        foreach (PlayerPoint player in allPlayerPoint )
        {
            if (best == player.numberGainCase && lastCase)
            {
                Debug.Log("zerda");
                best = player.numberGainCase;
                player.point += 30;
                player.objectifVerif[baseObjectif.IndexOf("GoldLate")] = true;
            }
        }
    }

    public void LoseEarly()
    {
        bool verif = false;
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            if (obj.numberLoseCase == 1 && verif == false)
            {
                obj.point += 10;
                verif = true;
                obj.objectifVerif[baseObjectif.IndexOf("LoseEarly")] = true;
            }
        }
        if (verif)
        {
            actualObjectif.Remove("LoseEarly");
        }
    }
    
    public void LoseMid()
    {
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            bool verif = obj.objectifVerif[baseObjectif.IndexOf("LoseMid")];   
            if (obj.numberLoseCase >= 2 && verif == false)
            {
                obj.point += 20;
                obj.objectifVerif[baseObjectif.IndexOf("LoseMid")] = true;
            }
        }
    }

    public void LoseLate()
    {
        List<int> intList = new List<int>();
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            intList.Add(obj.numberLoseCase);
        }
        int best = Mathf.Max(intList.ToArray());
        foreach (PlayerPoint player in allPlayerPoint )
        {
            if (best == player.numberLoseCase && lastCase)
            {
                best = player.numberLoseCase;
                player.point += 30;
                player.objectifVerif[actualObjectif.IndexOf("LoseLate")] = true;
            }
        }
    }

    public void MoveEarly()
    {
        bool verif = false;
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            if (obj.numberCase >= 7 && verif == false)
            {
                obj.point += 10; 
                verif = true;
            }
        }
        if (verif)
        {
            actualObjectif.Remove("MoveEarly");
        }
    }

    public void MoveMid()
    {
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            bool verif = obj.objectifVerif[actualObjectif.IndexOf("MoveMid")];   
            if (obj.numberCase >= 13 && verif == false)
            {
                obj.point += 20;
                obj.objectifVerif[actualObjectif.IndexOf("MoveMid")] = true;
            }
        }
    }

    public void MoveLate()
    {
        List<int> intList = new List<int>();
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            intList.Add(obj.numberCase);
        }
        int best = Mathf.Max(intList.ToArray());
        foreach (PlayerPoint player in allPlayerPoint )
        {
            if (best == player.numberCase && lastCase)
            {
                best = player.numberCase;
                player.point += 30;
            }
        }
    }

    public void EventEarly()
    {
        bool verif = false;
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            if (obj.numberEventCase >= 1 && verif == false)
            {
                obj.point += 10;
                verif = true;
                obj.objectifVerif[actualObjectif.IndexOf("EventEarly")] = true;
            }
        }
        if (verif)
        {
            actualObjectif.Remove("EventEarly");
        }
    }

    public void EventMid()
    {
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            bool verif = obj.objectifVerif[actualObjectif.IndexOf("EventMid")];  
            if (obj.numberEventCase >= 2 && verif == false)
            {
                obj.point += 20;
                obj.objectifVerif[actualObjectif.IndexOf("EventMid")] = true;
                
            }
        }
    }

    public void EventLate()
    {
        List<int> intList = new List<int>();
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            intList.Add(obj.numberEventCase);
        }
        int best = Mathf.Max(intList.ToArray());
        foreach (PlayerPoint player in allPlayerPoint)
        {
            if (best == player.numberEventCase && lastCase)
            {
                best = player.numberEventCase;
                player.point += 30;
                player.objectifVerif[actualObjectif.IndexOf("EventLate")] = true;
            }
        }
    }
}
