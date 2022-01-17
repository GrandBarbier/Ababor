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
    public List<PlayerPoint> allPlayerPoint;
    public bool lastCase;

    public TMP_Text text;
    // Start is called before the first frame update

    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
        
        for (int i = 0; i < _gameplayManager.allPlayer.Count; i++)
        {
            allPlayerPoint.Add(_gameplayManager.allPoint[i]);
        }

        for (int i = 0; i <= allPlayerPoint.Count/2; i++)
        {
            int rdm = Random.Range(0, allEarlyObjectifs.Count);
            actualObjectif.Add(allEarlyObjectifs[rdm]);
            allEarlyObjectifs.Remove(allEarlyObjectifs[rdm]);
        }
        for (int i = 0; i <= allPlayerPoint.Count/2; i++)
        {
            int rdm = Random.Range(0, allMidObjectifs.Count);
            actualObjectif.Add(allMidObjectifs[rdm]);
            allMidObjectifs.Remove(allMidObjectifs[rdm]);
        }
        
        for (int i = 0; i <= allPlayerPoint.Count/2; i++)
        {
            int rdm = Random.Range(0, allLateObjectifs.Count);
            actualObjectif.Add(allLateObjectifs[rdm]);
            allLateObjectifs.Remove(allLateObjectifs[rdm]);
        }
        
        
        foreach (PlayerPoint player in allPlayerPoint)
        {
            foreach (string stg in actualObjectif)
            {
                player.objectifVerif.Add(false);
            }
        }

        foreach (string stg in actualObjectif)
        {
            text.text += stg + " ";
        }
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
                actualObjectif.Remove("ShopEarly");
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
            bool verif = obj.objectifVerif[actualObjectif.IndexOf("ShopMid")];   
            if (obj.numberShopCase >= 2 && verif == false)
            {
                obj.point += 20;
                obj.objectifVerif[actualObjectif.IndexOf("ShopMid")] = true;
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
            bool verif = obj.objectifVerif[actualObjectif.IndexOf("GoldMid")];   
            if (obj.numberGainCase >= 2 && verif == false)
            {
                obj.point += 20;
                obj.objectifVerif[actualObjectif.IndexOf("GoldMid")] = true;
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
                best = player.numberGainCase;
                player.point += 30;
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
            bool verif = obj.objectifVerif[actualObjectif.IndexOf("LoseMid")];   
            if (obj.numberLoseCase >= 2 && verif == false)
            {
                obj.point += 20;
                obj.objectifVerif[actualObjectif.IndexOf("LoseMid")] = true;
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
            }
        }
    }

    public void MoveEarly()
    {
        bool verif = false;
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            if (obj.numberCase >= 5 && verif == false)
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
            if (obj.numberCase >= 10 && verif == false)
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
}
