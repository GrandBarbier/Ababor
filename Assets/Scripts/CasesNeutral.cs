using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using Random = UnityEngine.Random;

public class CasesNeutral : MonoBehaviour
{
    public bool isInRanged;
    public List<CasesNeutral> nextCases;
    public Color baseColor;
   [SerializeField] private GameplayManager _gameplayManager;
    public Renderer renderer;
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
        renderer = gameObject.GetComponent<Renderer>();
        ResetColor();
        index = _gameplayManager.allCases.IndexOf(gameObject);
        objectif = FindObjectOfType<Objectif>();
        eventS = gameObject.GetComponent<Event>();

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
                obj.GetComponent<Renderer>().material.color = Color.blue;
                obj.isInRanged = true;
               
            }
        }
    }

    public void ResetColor()
    {
        renderer.material.color = baseColor;
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
        Debug.Log(5);
        _gameplayManager.ChangePlayer();
    }

    public void LoseCase()
    {
        activPlayer.point.gold -= 3;
        if (activPlayer.point.gold < 0)
        {
            activPlayer.point.gold = 0;
        }
        activPlayer.point.numberLoseCase++;
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
      //  _gameplayManager.playerIndex--;
    }

    public void ShopCase()
    {
        Shop shop = FindObjectOfType<Shop>();
        shop.ShopOpen();
        activPlayer.point.numberShopCase++;
    }

    public void EndCase()
    { 
        objectif.lastCase = true;
        menuEnd.SetActive(true);
        Debug.Log("win");
        Time.timeScale = 0;
        //_gameplayManager.ChangePlayer();
        _gameplayManager.FindBestPlayer();
    }

    public void EventCase()
    {
        eventS.GetEvent();
        eventS.Invoke(eventS.eventName,0);
    }
    
    
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            activPlayer.point.numberCase++;
        }
    }
}
