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

    public void ShopOpen(CasesNeutral cases)
    {
        gameplayManager.enabled = false;
        shopMenu.SetActive(true); 
        player = gameplayManager.activPlayer;
        playerPoint = player.GetComponent<PlayerPoint>();
        playerMove = player.GetComponent<PlayerMovement>();
        foreach (GameObject obj in gameplayManager.allPlayer)
        {
            obj.GetComponent<PlayerMovement>().enabled = false;
        }
        caseScript = cases;
    }

    public void MoveButton()
    {
        gameplayManager.enabled = true;
        playerPoint.gold -= 10;
        playerMove.InitialMove ++;
        shopMenu.SetActive(false);
        caseScript.ChangePLayer();
        playerMove.actualMove = playerMove.InitialMove;
    }

    public void CardButton()
    {
        
        playerPoint.gold -= 5;
        shopMenu.SetActive(false);
        caseScript.ChangePLayer();
        gameplayManager.enabled = true;
    }
}
