using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using Wizama.Hardware.Antenna;

public class CasesNeutral : MonoBehaviour
{
    public bool isInRanged;
    public List<GameObject> nextCases;
    public Color baseColor;
    private GameplayManager _gameplayManager;
    public Renderer renderer;
    public int index;
    public string nameFunction;
    private PlayerPoint _playerPoint;
    private PlayerMovement _playerMove;
    public GameObject activPlayer;

    public Objectif objectif;
    // Start is called before the first frame update
    void Awake()
    {
        
        _gameplayManager = FindObjectOfType<GameplayManager>();
        renderer = gameObject.GetComponent<Renderer>();
        ResetColor();
        index = _gameplayManager.allCases.IndexOf(gameObject);
        objectif = FindObjectOfType<Objectif>();

    }

    // Update is called once per frame
    void Update()
    {
        if (activPlayer != _gameplayManager.activPlayer)
        {
            activPlayer = _gameplayManager.activPlayer;
            _playerPoint = activPlayer.GetComponent<PlayerPoint>();
            _playerMove = activPlayer.GetComponent<PlayerMovement>();
        }
    }

    public void Outline(List<GameObject> list, float remain)
    {
        if (remain > 0)
        {
            foreach (GameObject obj in nextCases )
            {
                obj.GetComponent<CasesNeutral>().Outline(obj.GetComponent<CasesNeutral>().nextCases, remain-1);
                obj.GetComponent<Renderer>().material.color = Color.blue;
                obj.GetComponent<CasesNeutral>().isInRanged = true;
               
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

    public void EarnCase()
    {
        objectif.GoldEarly();
        _playerPoint.gold += 3;
        _playerPoint.numberGainCase++;
        _gameplayManager.ChangePlayer();
    }

    public void NeutralCase()
    {
        _gameplayManager.ChangePlayer();
    }

    public void LoseCase()
    {
        _playerPoint.gold -= 3;
        if (_playerPoint.gold < 0)
        {
            _playerPoint.gold = 0;
        }
        _playerPoint.numberLoseCase++;
        _gameplayManager.ChangePlayer();
    }

    public void MoveCase()
    {
        int u = _playerMove.FindCase(); 
        _playerMove.actualMove = 2;
        _playerMove.PlayerShowMove();
        _playerMove.agent.destination = _playerMove.child.transform.position;
        _playerMove.actualMove = _playerMove.InitialMove;
    }

    public void ShopCase()
    {
        objectif.Invoke("ShopEarly",1);
        Shop shop = FindObjectOfType<Shop>();
        shop.ShopOpen(this);
        _playerPoint.numberShopCase++;
    }
    
    
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            _playerPoint.numberCase++;
        }
    }
}
