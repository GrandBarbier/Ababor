using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Objectif : MonoBehaviour
{
    private GameplayManager _gameplayManager;
    public List<string> allLateObjectifs;
    public List<string> allMidObjectifs;
    public List<string> allEarlyObjectifs;
    public List<string> actualObjectif;
    public List<PlayerPoint> allPlayerPoint;
    public bool lastCase;
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
        for (int i = 0; i < _gameplayManager.allPlayer.Count; i++)
        {
            allPlayerPoint.Add(_gameplayManager.allPlayer[i].GetComponent<PlayerPoint>());
        }

        for (int i = 0; i <= allPlayerPoint.Count/2; i++)
        {
            actualObjectif.Add(allEarlyObjectifs[Random.Range(0,allEarlyObjectifs.Count)]);
            allEarlyObjectifs.Remove(actualObjectif[i]);
        }
        for (int i = 0; i <= allPlayerPoint.Count/2; i++)
        {
            actualObjectif.Add(allMidObjectifs[Random.Range(0,allMidObjectifs.Count)]);
            allMidObjectifs.Remove(actualObjectif[i+2]);
        }
        
        
        foreach (PlayerPoint player in allPlayerPoint)
        {
            foreach (string stg in actualObjectif)
            {
                player.objectifVerif.Add(false);
            }
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
            if (best == player.numberShopCase)
            {
                best = player.numberShopCase;
            }
            if(lastCase)
            {
                player.point += 30;
            }
        }

     
    }

    public void GoldEarly()
    {
        Debug.Log("1");
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
}
