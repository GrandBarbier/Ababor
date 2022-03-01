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
    
    public int index;
    
    public string nameFunction;
    
    public Player activPlayer;
    
    public Event eventS;
    
    public Objectif objectif;
    
    public GameObject menuEnd, nextIsle, lastIsle;
    
    public CasesNeutral lastCase;
 
    // Start is called before the first frame update
    void Awake()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
        objectif = FindObjectOfType<Objectif>();
        eventS = gameObject.GetComponent<Event>();
        allMat = renderer.materials;
        ResetColor();
    }

    // Update is called once per frame
    void Update()
    {
        activPlayer = _gameplayManager.allPlayers[_gameplayManager.playerIndex];
        
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
                activPlayer.move.allNextCases.Add(nextCases[i]);
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
        activPlayer.point.gold += 3;
        activPlayer.point.numberGainCase++;
        _gameplayManager.ChangePlayer();
    }

    public void NeutralCase()
    {
        _gameplayManager.ChangePlayer();
    }

    public void LoseCase()
    {
        activPlayer.point.gold -= 3;
        _gameplayManager.treasure += 3;
        if (activPlayer.point.gold < 0)
        {
            activPlayer.point.gold = 0;
        }
        activPlayer.point.numberLoseCase++;
        _gameplayManager.ResetLast();
        _gameplayManager.ChangePlayer();
    }

    public void MoveCase()
    {
        int u = activPlayer.move.FindCase(); 
        activPlayer.move.actualMove = 2;
        activPlayer.move.PlayerShowMove();
        activPlayer.move.agent.destination = activPlayer.move.child.transform.position;
        activPlayer.move.actualMove = activPlayer.move.InitialMove;
        _gameplayManager.playerIndex++;
    }

    public void ShopCase()
    {
        Shop shop = FindObjectOfType<Shop>();
        shop.ShopOpen();
        activPlayer.point.numberShopCase++;
        _gameplayManager.ResetLast();
    }

    public void EndCase()
    { 
        objectif.lastCase = true;
       // menuEnd.SetActive(true);
       nextIsle.SetActive(true);
       lastIsle.SetActive(false);
       _gameplayManager.ChangePlayer();
       _gameplayManager.GetCase();
       foreach (Player player in _gameplayManager.allPlayers)
       {
           player.move.caseNext[0] = _gameplayManager.allCases[0];
           player.player.transform.position = player.move.caseNext[0].transform.position;
       }
    }

    public void EventCase()
    {
        eventS.GetEvent();
        eventS.Invoke(eventS.eventName,0);
        _gameplayManager.ResetLast();
    }
}
