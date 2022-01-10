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
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void ShopEarly()
    {
        Debug.Log("nique");
        bool verif = false;
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            if (obj.numberShopCase >= 1 && verif == false)
            {
                obj.point += 10;
                verif = true;
            }
        }
    }

    public void ShopMid()
    {
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            if (obj.numberShopCase >= 3)
            {
                obj.point += 20;
            }
        }
    }

    public void GoldEarly()
    {
        Debug.Log("1");
        bool verif = false;
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            if (obj.numberGainCase >= 3 && verif == false)
            {
                obj.point += 10;
                verif = true;
            }
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
    
}
