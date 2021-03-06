using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shop : MonoBehaviour
{
    public PlayerPoint playerPoint;
   
    public GameplayManager _gameplayManager;
    
    public PlayerMovement playerMove;

    public List<GameObject> shopMenu;

    private CasesNeutral caseScript;
    
    // Update is called once per frame
    void Update()
    {
        playerPoint = _gameplayManager.actualPoint;
        playerMove = _gameplayManager.actualMove;
    }

    public void ShopOpen()
    {
        shopMenu[playerPoint.index].SetActive(true);
    }

    public void ShopClose()
    {
     /*   foreach (GameObject obj in shopMenu)
        {
            obj.SetActive(false);
        }*/
        shopMenu[playerPoint.index].SetActive(false);
        _gameplayManager.OpenVerifMenu();
        if (_gameplayManager.cardManager.numberClub == false)
        {
            _gameplayManager.ChangePlayer();
        }
        else
        {
            _gameplayManager.cardManager.numberClub = false;
            _gameplayManager.cardManager.ResetIndexPlayer();
            _gameplayManager.currentstate = new CardPlay();
        }
    }

    public void MoveButton()
    {
        if (playerPoint.gold >= 10)
        {

            _gameplayManager.enabled = true;
            playerPoint.gold -= 10;
            playerMove.InitialMove++;
            shopMenu[playerPoint.index].SetActive(false);
            if (_gameplayManager.cardManager.numberClub == false)
            {
                _gameplayManager.ChangePlayer();
            }
            else
            {
                _gameplayManager.cardManager.numberClub = false;
                _gameplayManager.cardManager.ResetIndexPlayer();
                _gameplayManager.currentstate = new CardPlay();
            }

            playerMove.actualMove = playerMove.InitialMove;
        }
        else
        {
            ShopClose();
        }
    }

    public void CardButton()
    {
        if (playerPoint.gold >= 5)
        {


            playerPoint.gold -= 5;
            shopMenu[playerPoint.index].SetActive(false);
            _gameplayManager.cardManager.playerPlayed[playerPoint.index] = false;
            _gameplayManager.cardManager.hardManager.Colorize();
          
            if (_gameplayManager.cardManager.playerPlayed[playerPoint.index] == false)
            {
                _gameplayManager.cardManager.shopBuyed[playerPoint.index] = true;
            }
            
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
        else
        {
            ShopClose();
        }
    }
}
