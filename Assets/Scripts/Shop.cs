using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shop : MonoBehaviour
{
    public PlayerPoint playerPoint;
   
    public GameplayManager _gameplayManager;
    
    public PlayerMovement playerMove;

    public GameObject shopMenu;

    private CasesNeutral caseScript;
    
    // Update is called once per frame
    void Update()
    {
        playerPoint = _gameplayManager.actualPoint;
        playerMove = _gameplayManager.actualMove;
    }

    public void ShopOpen()
    {
        shopMenu.SetActive(true);
    }

    public void ShopClose()
    {
        shopMenu.SetActive(false);
    }

    public void MoveButton()
    {
        _gameplayManager.enabled = true;
        playerPoint.gold -= 10;
        playerMove.InitialMove ++;
        shopMenu.SetActive(false);
        _gameplayManager.ChangePlayer();
        playerMove.actualMove = playerMove.InitialMove;
    }

    public void CardButton()
    {
        playerPoint.gold -= 5;
        shopMenu.SetActive(false);
        _gameplayManager.ChangePlayer();
        _gameplayManager.enabled = true;
    }
}
