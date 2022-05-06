using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class CardManager : MonoBehaviour
{
    public GameObject menu;
    public GameObject waitMenu;
    public GameObject targetMenu;
    public GameObject useCard;
    
    public Image playerSelected;
    public Image targetSelected;
    public Image player1Target;
    
    public GameplayManager gameplayManager;

    public TMP_Text text;
    public TMP_Text textTarget;
    
    public int index, gmIndex;
    
    public bool verif;
    public bool oneTarget;
    public bool numberClub;
    public bool openMove;
    
    public Player player;
    public List<Player> allPlayer;
    public Player target;

    public Button button;
    public Button buttonTarget;

    public string functionName, lastName;

    // Start is called before the first frame update
    void Start()
    {
        gameplayManager = FindObjectOfType<GameplayManager>();
        player = gameplayManager.allPlayers[0];
        allPlayer = gameplayManager.allPlayers;
    }

    // Update is called once per frame
    void Update()
    {
        if (index != gameplayManager.playerIndex && verif)
        {
            gameplayManager.playerIndex = gmIndex;
            ResetIndexPlayer();
            verif = false;
        }

        if (target == null)
        {
            button.gameObject.SetActive(false);
            buttonTarget.gameObject.SetActive(false);
        }
        else
        {
            button.gameObject.SetActive(true);
            buttonTarget.gameObject.SetActive(true);
        }
    }

    public void OneGreen()
    {
        gmIndex = gameplayManager.playerIndex;
        index = target.move.index;
        target.move.isLast = false;
        gameplayManager.playerIndex = index;
        target.move.enabled = true;
        target.move.actualMove = 1;
        gameplayManager.currentstate = new Moving();
        gameplayManager.currentstate.DoState(target.move,gameplayManager);
        target.move.PlayerShowMove();
        verif = true;
        target.move.actualMove = target.move.InitialMove;
        waitMenu.SetActive(false);
        numberClub = true;
        useCard.SetActive(true);
    }

    public void TwoGreen()
    {
        gmIndex = gameplayManager.playerIndex;
        index = target.move.index;
        target.move.isLast = false;
        gameplayManager.playerIndex = index;
        target.move.enabled = true;
        target.move.actualMove = 2;
        target.move.PlayerShowMove();
        for (int i = 0; i < target.move.allNextCases.Count/2; i++)
        {
            if (target.move.caseNext[0].nextCases[i].nameFunction != "EndCase")
            {
                target.move.caseNext[0].nextCases[i].isInRange = false;
                target.move.caseNext[0].nextCases[i].ResetColor();
            }
        }
        verif = true;
        target.move.actualMove = target.move.InitialMove;
        waitMenu.SetActive(false);
        numberClub = true;
        useCard.SetActive(true);
    }

    public void OneBlue()
    {
        gmIndex = gameplayManager.playerIndex;
        if (target.move.caseNext[0] == target.move.caseNext[0].lastCase)
        {
        }
        else
        {
            target.move.caseNext[0] = target.move.caseNext[0].lastCase; 
        }
        target.player.transform.position = target.move.caseNext[0].transform.position + Vector3.up;
        target.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
        verif = true;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        gameplayManager.playerIndex--;
        useCard.SetActive(true);
    }

    public void TwoBlue()
    {
        gmIndex = gameplayManager.playerIndex;
        if (target.move.caseNext[0] == target.move.caseNext[0].lastCase.lastCase)
        {
        }
        else
        {
            target.move.caseNext[0] = target.move.caseNext[0].lastCase.lastCase;   
        }
        target.player.transform.position = target.move.caseNext[0].transform.position + Vector3.up;
        target.move.caseNext[0].ActualCaseFunction();
        gameplayManager.playerIndex = gmIndex;
        verif = true;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        gameplayManager.playerIndex--;
        useCard.SetActive(true);
    }

    public void ThreeRed()
    {
        target.point.gold -= 3;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void FiveRed()
    {
        target.point.gold -= 5;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void ThreeYellow()
    {
        target.point.gold += 3;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void FiveYellow()
    {
        target.point.gold += 5;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
        StartCoroutine("ShowThrowCard");
    }
    public void QueenGreen()
    {
        gmIndex = gameplayManager.playerIndex;
        player.player.transform.position = target.move.caseNext[0].transform.position + Vector3.up;
        player.move.caseNext[0] = target.move.caseNext[0];
        player.move.caseNext[0].ActualCaseFunction();
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        numberClub = true;
        useCard.SetActive(true);
    }

    public void QueenBlue()
    {
        gmIndex = gameplayManager.playerIndex;
        player.player.transform.position = target.move.caseNext[0].transform.position + Vector3.up;
        player.move.caseNext[0] = target.move.caseNext[0];
        player.move.caseNext[0].ActualCaseFunction();
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        numberClub = true;
        useCard.SetActive(true);
    }
    
    public void QueenRed()
    {
        player.point.gold -= 5;
        target.point.gold += 5;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void QueenYellow()
    {
        target.point.gold += gameplayManager.treasure;
        gameplayManager.treasure = 0;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void KingGreen()
    {
         CasesNeutral cases = player.move.caseNext[0];
         gmIndex = gameplayManager.playerIndex;
         index = gameplayManager.playerIndex;
         player.move.isLast = false;
         target.move.isLast = false;
         player.player.transform.position = target.move.caseNext[0].transform.position +Vector3.up;
         target.player.transform.position = cases.transform.position + Vector3.up;
         player.move.caseNext[0] = target.move.caseNext[0];
         target.move.caseNext[0] = cases;
         player.move.caseNext[0].ActualCaseFunction();
         target.move.caseNext[0].ActualCaseFunction();
         verif = true;
         waitMenu.SetActive(false);
         gameplayManager.OpenVerifMenu();
         useCard.SetActive(true);
    }
    
    public void KingBlue()
    {
        CasesNeutral cases = player.move.caseNext[0];
        gmIndex = gameplayManager.playerIndex;
        index = gameplayManager.playerIndex;
        player.move.isLast = false;
        target.move.isLast = false;
        player.player.transform.position = target.move.caseNext[0].transform.position+ Vector3.up;
        target.player.transform.position = cases.transform.position + Vector3.up;
        player.move.caseNext[0] = target.move.caseNext[0];
        target.move.caseNext[0] = cases;
        player.move.caseNext[0].ActualCaseFunction();
        target.move.caseNext[0].ActualCaseFunction();
        verif = true;
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void KingRed()
    {
        foreach (Player pl in gameplayManager.allPlayers)
        {
            if (pl != target)
            {
                target.point.gold -= 3;
                pl.point.gold += 3;
            }
        }
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void KingYellow()
    {
        foreach (Player pl in gameplayManager.allPlayers)
        {
            if (pl != target)
            {
                pl.point.gold -= 5;
                target.point.gold += 5;
            }
        }
        waitMenu.SetActive(false);
        gameplayManager.OpenVerifMenu();
        useCard.SetActive(true);
    }

    public void Jack()
    {
        waitMenu.SetActive(false);
        Invoke(lastName,1);
        index = gameplayManager.playerIndex;
        verif = true;
        useCard.SetActive(true);
    }
    
    public void ButtonSelectPlayer(int index)
    {
        player = allPlayer[index];

        switch (index)
        {
            case 0 :
                playerSelected.color = Color.red;
                break;
            case 1 :
                playerSelected.color = Color.blue;
                break;
            case 2 :
                playerSelected.color = Color.yellow;
                break;
            case 3 :
                playerSelected.color = Color.green;
                break;
        }

    }

    public void ButtonSelectTarget(int index)
    {
        target = allPlayer[index];
        switch (index)
        {
            case 0 :
                targetSelected.color = Color.red;
                break;
            case 1 :
                targetSelected.color = Color.blue;
                break;
            case 2 :
                targetSelected.color = Color.yellow;
                break;
            case 3 :
                targetSelected.color = Color.green;
                break;
        }
    }

    public void ButtonSelect1Target(int index)
    {
        target = allPlayer[index];

        switch (index)
        {
            case 0 :
                player1Target.color = Color.red;
                break;
            case 1 :
                player1Target.color = Color.blue;
                break;
            case 2 :
                player1Target.color = Color.yellow;
                break;
            case 3 :
                player1Target.color = Color.green;
                break;
        }
    }

    public void CallCardFunction()
    {
        if (player == target)
        {
            Debug.Log("non");
        }
        else
        {
            Invoke(functionName, 5);
            if (functionName == "Jack")
            {
                functionName = lastName;
            }

            menu.SetActive(false);
            targetSelected.gameObject.SetActive(false);
            targetSelected.color = Color.white;
            playerSelected.color = Color.white;
            waitMenu.SetActive(true);
        }
    }

    public void CallCardFunction1Target()
    {
        if (target == gameplayManager.activPlayer && functionName == "KingGreen" || functionName == "QueenGreen")
        {
            Debug.Log("non");
        }
        else
        {
            Invoke(functionName, 5);
            if (functionName == "Jack")
            {
                functionName = lastName;
            }

            targetMenu.SetActive(false);
            targetSelected.gameObject.SetActive(false);
            targetSelected.color = Color.white;
            waitMenu.SetActive(true);
        }
    }

    public void CloseMenu()
    {
        menu.SetActive(false);
        text.gameObject.SetActive(false);
        text.text = null;
        playerSelected.gameObject.SetActive(false);
        targetSelected.gameObject.SetActive(false);
        if (waitMenu.activeSelf == false)
        {
            gameplayManager.OpenVerifMenu();
        }
    }

    public void CloseMenu1Target()
    {
        targetMenu.SetActive(false);
        textTarget.gameObject.SetActive(false);
        textTarget.text = null;
        playerSelected.gameObject.SetActive(false);
        targetSelected.gameObject.SetActive(false);
        if (waitMenu.activeSelf == false)
        {
            gameplayManager.OpenVerifMenu();
        }
    }
    
    public void OpenCardMenu(string stg, Player pl, string texte)
    {
        switch (pl.move.index)
        {
            case 0 :
                menu.transform.rotation = Quaternion.Euler(0,0,0);
                Debug.Log(0);
                break;
            case 1:
                menu.transform.rotation = Quaternion.Euler(0,0,0);
                Debug.Log(1);
                break;
            case 2:
                menu.transform.rotation = Quaternion.Euler(0,0,180);
                Debug.Log(2);
                break;
            case 3:
                menu.transform.rotation = Quaternion.Euler(0,0,180);
                Debug.Log(3);
                break;
        }
        
        if (waitMenu.activeSelf == false || stg == "Jack")
        {
            menu.SetActive(true);
            text.gameObject.SetActive(true);
            gameplayManager.verifMenu.SetActive(false);
            gameplayManager.verifMenu2.SetActive(false);
            targetSelected.gameObject.SetActive(true);
            text.text = texte;
            if (functionName != lastName)
            {
                lastName = stg;
            }
            functionName = stg;
            player = pl;
        }
    }

    public void OpenCardMenu1Target(string stg, Player pl, string texte)
    {
        switch (pl.move.index)
        {
            case 0 :
                menu.transform.rotation = Quaternion.Euler(0,0,0);
                Debug.Log(0);
                break;
            case 1:
                menu.transform.rotation = Quaternion.Euler(0,0,0);
                Debug.Log(1);
                break;
            case 2:
                menu.transform.rotation = Quaternion.Euler(0,0,180);
                Debug.Log(2);
                break;
            case 3:
                menu.transform.rotation = Quaternion.Euler(0,0,180);
                Debug.Log(3);
                break;
        }
        
        if (waitMenu.activeSelf == false|| stg == "Jack")
        {
            targetMenu.SetActive(true);
            textTarget.gameObject.SetActive(true);
            gameplayManager.verifMenu.SetActive(false);
            gameplayManager.verifMenu2.SetActive(false);
            textTarget.text = texte;
            if (functionName != lastName)
            {
                lastName = stg;
            }
            functionName = stg;
            player = pl;
        }
        targetSelected.gameObject.SetActive(true);
    }

    public void ResetIndexPlayer()
    {
        gameplayManager.activPlayer.move.enabled = false;
        gameplayManager.playerIndex = gmIndex;
    }

    IEnumerator ShowThrowCard()
    {
        useCard.SetActive(true);
        yield return new WaitForSeconds(5f);
        useCard.SetActive(false);
    }
}
