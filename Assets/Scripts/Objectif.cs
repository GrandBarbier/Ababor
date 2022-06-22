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
    public List<string> actualLateObjectif;
    
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
    public List<bool> boolVerif ;
    
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
            actualDescription.Add(descriptionsEarly[rdm]);
            Debug.Log(rdm);
            allScore.Add(scoreEarly[rdm]);
            Debug.Log(rdm);
            actualObjectif.Add(allEarlyObjectifs[rdm]);
            baseObjectif.Add(allEarlyObjectifs[rdm]);
            Debug.Log(rdm);
            descriptionsEarly.Remove(descriptionsEarly[rdm]);
            scoreEarly.Remove(scoreEarly[rdm]);
            allEarlyObjectifs.Remove(allEarlyObjectifs[rdm]);
        }
        for (int i = 0; i <= allPlayerPoint.Count/3; i++)
        {
            int rdm = Random.Range(0, allMidObjectifs.Count);
            actualDescription.Add(descriptionMid[rdm]);
            allScore.Add(scoreMid[rdm]);
            actualObjectif.Add(allMidObjectifs[rdm]);
            baseObjectif.Add(allMidObjectifs[rdm]);
            descriptionMid.Remove(descriptionMid[rdm]);
            scoreMid.Remove(scoreMid[rdm]);
            allMidObjectifs.Remove(allMidObjectifs[rdm]);
        }
        
        for (int i = 0; i <= allPlayerPoint.Count/3; i++)
        {
            int rdm = Random.Range(0, allLateObjectifs.Count);
            actualDescription.Add(descriptionLate[rdm]);
            allScore.Add(scoreLate[rdm]);
            actualObjectif.Add(allLateObjectifs[rdm]);
            actualLateObjectif.Add(allLateObjectifs[rdm]);
            baseObjectif.Add(allLateObjectifs[rdm]);
            descriptionLate.Remove(descriptionLate[rdm]);
            scoreLate.Remove(scoreLate[rdm]);
            allLateObjectifs.Remove(allLateObjectifs[rdm]);
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
            if (obj.numberShopCase == 1 && verif == false && boolVerif[baseObjectif.IndexOf("ShopEarly")] == false)
            {
              
                verif = true;
                obj.objectifVerif[baseObjectif.IndexOf("ShopEarly")] = true;
                boolVerif[baseObjectif.IndexOf("ShopEarly")] = true;
            }
        }
        if (verif)
        {
           
        }
    }

    public void ShopMid()
    {
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            bool verif = obj.objectifVerif[baseObjectif.IndexOf("ShopMid")];   
            if (obj.numberShopCase >= 2 && verif == false)
            {
              
                obj.objectifVerif[baseObjectif.IndexOf("ShopMid")] = true;
                Debug.Log("obj" + baseObjectif.IndexOf("ShopMid") );
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
               
                player.objectifVerif[baseObjectif.IndexOf("ShopLate")] = true;
                Debug.Log("obj wtf");
            }
        }
    }

    public void GoldEarly()
    {
        bool verif = false;
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            if (obj.numberGainCase == 1 && verif == false && boolVerif[baseObjectif.IndexOf("GoldEarly")] == false)
            {
               
                verif = true;
                obj.objectifVerif[baseObjectif.IndexOf("GoldEarly")] = true;
                Debug.Log("obj" + baseObjectif.IndexOf("GoldEarly") );
                boolVerif[baseObjectif.IndexOf("GoldEarly")] = true;
            }
        }
        if (verif)
        {
           
        }
    }
    
    public void GoldMid()
    {
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            bool verif = obj.objectifVerif[baseObjectif.IndexOf("GoldMid")];   
            if (obj.numberGainCase >= 2 && verif == false)
            {
             
                obj.objectifVerif[baseObjectif.IndexOf("GoldMid")] = true;
                Debug.Log("obj" + baseObjectif.IndexOf("GoldMid") );
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
              
                player.objectifVerif[baseObjectif.IndexOf("GoldLate")] = true;
                Debug.Log("obj wtf g");
            }
        }
    }

    public void LoseEarly()
    {
        bool verif = false;
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            if (obj.numberLoseCase == 1 && verif == false && boolVerif[baseObjectif.IndexOf("LoseEarly")] == false)
            {
                
                verif = true;
                obj.objectifVerif[baseObjectif.IndexOf("LoseEarly")] = true;
                boolVerif[baseObjectif.IndexOf("LoseEarly")] = true;
            }
        }
        if (verif)
        {
            
        }
    }
    
    public void LoseMid()
    {
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            bool verif = obj.objectifVerif[baseObjectif.IndexOf("LoseMid")];   
            if (obj.numberLoseCase >= 2 && verif == false)
            {
               
                obj.objectifVerif[baseObjectif.IndexOf("LoseMid")] = true;
                Debug.Log("obj" + baseObjectif.IndexOf("LoseMid") );
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
            Debug.Log(best);
            if (best == player.numberLoseCase && lastCase)
            {
                
                best = player.numberLoseCase;
                
                player.objectifVerif[actualObjectif.IndexOf("LoseLate")] = true;
                Debug.Log("obj wtf l");
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
                
            }
        }
    }

    public void EventEarly()
    {
        bool verif = false;
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            if (obj.numberEventCase >= 1 && verif == false && boolVerif[baseObjectif.IndexOf("EventEarly")] == false)
            {
                
                verif = true;
                obj.objectifVerif[actualObjectif.IndexOf("EventEarly")] = true;
                boolVerif[baseObjectif.IndexOf("EventEarly")] = true;
            }
        }
        if (verif)
        {
           
        }
    }

    public void EventMid()
    {
        foreach (PlayerPoint obj in allPlayerPoint )
        {
            bool verif = obj.objectifVerif[actualObjectif.IndexOf("EventMid")];  
            if (obj.numberEventCase >= 2 && verif == false)
            {
            
                obj.objectifVerif[actualObjectif.IndexOf("EventMid")] = true;
                Debug.Log("obj" + baseObjectif.IndexOf("EventMid"));
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
                player.objectifVerif[actualObjectif.IndexOf("EventLate")] = true;
                Debug.Log("obj wtf e");
            }
        }
        Debug.Log("late");
    }
}
