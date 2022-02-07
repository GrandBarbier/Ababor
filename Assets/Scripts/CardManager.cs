using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CardManager : MonoBehaviour
{
    public GameObject menu;
    public GameplayManager gameplayManager;
    public PlayerMovement move;
    public PlayerPoint point;
    
    // Start is called before the first frame update
    void Start()
    {
        gameplayManager = FindObjectOfType<GameplayManager>();
    }

    // Update is called once per frame
    void Update()
    {
        move = gameplayManager.actualMove;
        point = gameplayManager.actualPoint;
    }

    public void TestingCard(Player player)
    {
        
    }
}
