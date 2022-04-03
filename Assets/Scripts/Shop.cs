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
        switch (_gameplayManager.playerIndex)
        {
            case 0 :
                shopMenu.transform.rotation = Quaternion.Euler(0,0,0);
                break;
            case 1:
                shopMenu.transform.rotation = Quaternion.Euler(0,0,0);
                break;
            case 2:
                shopMenu.transform.rotation = Quaternion.Euler(0,0,180);
                break;
            case 3:
                shopMenu.transform.rotation = Quaternion.Euler(0,0,180);
                break;
        }
    }

    public void ShopClose()
    {
        shopMenu.SetActive(false);
        _gameplayManager.OpenVerifMenu();
        if (_gameplayManager.cardManager.numberClub == false)
        {
            _gameplayManager.ChangePlayer();
        }
        else
        {
            _gameplayManager.cardManager.numberClub = false;
            _gameplayManager.cardManager.ResetIndexPlayer();
        }
    }

    public void MoveButton()
    {
        _gameplayManager.enabled = true;
        playerPoint.gold -= 10;
        playerMove.InitialMove ++;
        shopMenu.SetActive(false);
        if (_gameplayManager.cardManager.numberClub == false)
        {
            _gameplayManager.ChangePlayer();
        }
        else
        {
            _gameplayManager.cardManager.numberClub = false;
            _gameplayManager.cardManager.ResetIndexPlayer();
        }
        playerMove.actualMove = playerMove.InitialMove;
    }

    public void CardButton()
    {
        playerPoint.gold -= 5;
        shopMenu.SetActive(false);
        if (_gameplayManager.cardManager.numberClub == false)
        {
            _gameplayManager.ChangePlayer();
        }
        else
        {
            _gameplayManager.cardManager.numberClub = false;
            _gameplayManager.cardManager.ResetIndexPlayer();
        }
        _gameplayManager.enabled = true;
    }
}
