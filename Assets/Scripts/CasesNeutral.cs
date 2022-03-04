using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using UnityEngine;
using UnityEngine.SceneManagement;
using Random = UnityEngine.Random;

public class CasesNeutral : MonoBehaviour
{
    public bool isInRanged;
  
    public List<CasesNeutral> nextCases;
    
    public Material baseMat;
    public Material rangedMat;
    public Material baseSecondMat;
    public Material[] allMat;
    
    [SerializeField] private GameplayManager _gameplayManager;
    
    public Renderer renderer;

    public Shop shop;
    
    public int index;
    
    public string nameFunction;
    
    public Player activPlayer;
    
    public Event eventS;
    
    public Objectif objectif;
    
    public GameObject menuEnd;
    
    public CasesNeutral lastCase;
 
    // Start is called before the first frame update
    void Awake()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
        objectif = FindObjectOfType<Objectif>();
        eventS = gameObject.GetComponent<Event>();
        shop = FindObjectOfType<Shop>();
        allMat = renderer.materials;
        ResetColor();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Outline(List<CasesNeutral> list, float remain)
    {
        
        if (remain > 0)
        {
            foreach (CasesNeutral obj in nextCases )
            {
                obj.Outline(obj.nextCases, remain-1);
                obj.allMat[0] = rangedMat;
                obj.renderer.materials = obj.allMat;
                obj.isInRanged = true;
            }

            for (int i = 0; i < nextCases.Count; i++)
            {
              _gameplayManager.activPlayer.move.allNextCases.Add(nextCases[i]);
            }
        }
    }

    public void ResetColor()
    {
        allMat[0] = baseMat;
        allMat[1] = baseSecondMat;
        renderer.materials = allMat;
        isInRanged = false;
    }

    public void ActualCaseFunction()
    {
        
        Invoke(nameFunction,0);
    }

    public void GainCase()
    {
        _gameplayManager.activPlayer.point.gold += 3;
        _gameplayManager.activPlayer.point.numberGainCase++;
        _gameplayManager.ChangePlayer();
    }

    public void NeutralCase()
    {
        _gameplayManager.ChangePlayer();
    }

    public void LoseCase()
    {
        _gameplayManager.activPlayer.point.gold -= 3;
        _gameplayManager.treasure += 3;
        if (_gameplayManager.activPlayer.point.gold < 0)
        {
            _gameplayManager.activPlayer.point.gold = 0;
        }
        _gameplayManager.activPlayer.point.numberLoseCase++;
        _gameplayManager.ResetLast();
        _gameplayManager.ChangePlayer();
    }

    public void ShopCase()
    {
        shop.ShopOpen();
        _gameplayManager.activPlayer.point.numberShopCase++;
        _gameplayManager.ResetLast();
    }

    public void EndCase()
    {
        if (_gameplayManager.lastTurn == false)
        {
            _gameplayManager.turnWait = 3;
            _gameplayManager.lastTurn = true;
            _gameplayManager.endPlayer = _gameplayManager.activPlayer;
            _gameplayManager.activPlayer.move.isEnd = true;
            _gameplayManager.ChangePlayer();
        }
        else
        {
            _gameplayManager.WaitForNextIsland();
        }
    }

    public void EventCase()
    {
        eventS.GetEvent();
        eventS.Invoke(eventS.eventName,0);
        _gameplayManager.ResetLast();
    }
}
