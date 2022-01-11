using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Objectif : MonoBehaviour
{
    private GameplayManager _gameplayManager;
    public List<string> allObjectifs;
    public List<string> actualObjectif;
    public List<PlayerPoint> allPlayerPoint;
   
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
        for (int i = 0; i < _gameplayManager.allPlayer.Count; i++)
        {
            allPlayerPoint.Add(_gameplayManager.allPlayer[i].GetComponent<PlayerPoint>());
        }

        for (int i = 0; i < 4; i++)
        {
            actualObjectif.Add(allObjectifs[i]);
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
            verif = obj.objectifVerif[actualObjectif.IndexOf("ShopEarly")];   
            if (obj.numberShopCase == 1 && verif == false)
            {
                obj.point += 10;
                actualObjectif.Remove("ShopEarly");
            }
        }

        
    }

    public void ShopMid()
    {
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            bool verif = obj.objectifVerif[actualObjectif.IndexOf("ShopMid")];   
            if (obj.numberShopCase >= 1 && verif == false)
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
        Debug.Log(best);
        foreach (PlayerPoint player in allPlayerPoint )
        {
            if (best == player.numberShopCase)
            {
                Debug.Log("truc");
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
            if (obj.numberGainCase >= 5)
            {
                obj.point += 15;
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
            if (obj.numberLoseCase >= 1)
            {
                obj.point += 10;
            }
        }
    }

    public void MoveEarly()
    {
        bool verif = false;
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            if (obj.numberCase >= 10 && verif == false)
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
            if (obj.numberCase >= 20)
            {
                obj.point += 10;
            }
        }
    }
}
