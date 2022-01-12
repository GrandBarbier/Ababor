using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shop : MonoBehaviour
{
    public PlayerPoint playerPoint;
    public GameplayManager gameplayManager;
    public PlayerMovement playerMove;
    public GameObject player;
    public GameObject shopMenu;

    private CasesNeutral caseScript;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
       /* if (player != gameplayManager.activPlayer)
        {
            
        }*/
    }

    public void ShopOpen(CasesNeutral cases,PlayerMovement plMove, PlayerPoint plPoint)
    {
        gameplayManager.enabled = false;
        shopMenu.SetActive(true); 
        player = gameplayManager.activPlayer;
        playerPoint = plPoint;
        playerMove = plMove;
        foreach (PlayerMovement obj in gameplayManager.allMove)
        {
            obj.enabled = false;
        }
        caseScript = cases;
    }

    public void MoveButton()
    {
        gameplayManager.enabled = true;
        playerPoint.gold -= 10;
        playerMove.InitialMove ++;
        shopMenu.SetActive(false);
        gameplayManager.ChangePlayer();
        playerMove.actualMove = playerMove.InitialMove;
    }

    public void CardButton()
    {
        playerPoint.gold -= 5;
        shopMenu.SetActive(false);
        gameplayManager.ChangePlayer();
        gameplayManager.enabled = true;
    }
}
