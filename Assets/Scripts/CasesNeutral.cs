using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using Wizama.Hardware.Antenna;

public class CasesNeutral : MonoBehaviour
{
    public bool isInRanged;
    public List<CasesNeutral> nextCases;
    public Color baseColor;
    private GameplayManager _gameplayManager;
    public Renderer renderer;
    public int index;
    public string nameFunction;
    [SerializeField] private PlayerPoint _playerPoint;
    [SerializeField] private PlayerMovement _playerMove;
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
            _playerPoint = _gameplayManager.actualPoint;
            _playerMove = _gameplayManager.actualMove;
        }
    }

    public void Outline(List<CasesNeutral> list, float remain)
    {
        if (remain > 0)
        {
            foreach (CasesNeutral obj in nextCases )
            {
                obj.Outline(obj.nextCases, remain-1);
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
        Shop shop = FindObjectOfType<Shop>();
        shop.ShopOpen(this,_playerMove,_playerPoint);
        _playerPoint.numberShopCase++;
    }

    public void EndCase()
    {
        objectif.lastCase = true;
        _gameplayManager.ChangePlayer();
    }
    
    
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            _playerPoint.numberCase++;
        }
    }
}
